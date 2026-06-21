import os
import json
from typing import Literal

from dotenv import load_dotenv
from pydantic import BaseModel, Field

from langchain_openai import ChatOpenAI
from langchain_neo4j import Neo4jGraph


load_dotenv()

NEO4J_URI = os.getenv("NEO4J_URI")
NEO4J_USERNAME = os.getenv("NEO4J_USERNAME")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-5.5")


class KGNode(BaseModel):
    id: str = Field(description="노드 이름. 예: 김민수, 결제 시스템 리팩터링")
    type: Literal["Person", "Project", "Team", "Metric", "System", "Unknown"]


class KGRelationship(BaseModel):
    source: str = Field(description="출발 노드 id")
    target: str = Field(description="도착 노드 id")
    kind: Literal[
        "RESPONSIBLE_FOR",
        "AIMS_TO_REDUCE",
        "COLLABORATED_ON",
        "RELATED_TO",
    ]


class KGGraph(BaseModel):
    nodes: list[KGNode]
    relationships: list[KGRelationship]


graph = Neo4jGraph(
    url=NEO4J_URI,
    username=NEO4J_USERNAME,
    password=NEO4J_PASSWORD,
    database=os.getenv("NEO4J_DATABASE"),
)

llm = ChatOpenAI(
    model=OPENAI_MODEL,
    temperature=0,
)

structured_llm = llm.with_structured_output(
    KGGraph,
    method="json_schema",
)

text = """
김민수는 결제 시스템 리팩터링을 담당했다.
결제 시스템 리팩터링은 장애율을 낮추기 위한 프로젝트였다.
결제 시스템 리팩터링은 보안팀과 플랫폼팀이 공동으로 진행했다.
"""

prompt = f"""
다음 한국어 문장에서 지식 그래프를 추출하세요.

규칙:
- 문장에 명시된 정보만 사용하세요.
- 노드는 중요한 사람, 프로젝트, 팀, 지표, 시스템을 추출하세요.
- 관계는 가능한 한 아래 중 하나를 사용하세요:
  - RESPONSIBLE_FOR: 사람이 프로젝트나 업무를 담당함
  - AIMS_TO_REDUCE: 프로젝트가 어떤 지표를 낮추는 목적을 가짐
  - COLLABORATED_ON: 팀이 프로젝트를 공동 진행함
  - RELATED_TO: 위 관계로 표현하기 어려운 일반 관계
- relationship의 source와 target은 반드시 nodes의 id 중 하나여야 합니다.

문장:
{text}
"""

kg = structured_llm.invoke(prompt)

print("LLM 추출 결과:")
print(json.dumps(kg.model_dump(), ensure_ascii=False, indent=2))


# 중복 생성을 줄이기 위한 제약 조건
graph.query("""
CREATE CONSTRAINT entity_id_unique IF NOT EXISTS
FOR (e:Entity)
REQUIRE e.id IS UNIQUE
""")


nodes = [node.model_dump() for node in kg.nodes]
relationships = [rel.model_dump() for rel in kg.relationships]


# 노드 저장
graph.query(
    """
    UNWIND $nodes AS node
    MERGE (e:Entity {id: node.id})
    SET e.type = node.type
    """,
    params={"nodes": nodes},
)

# GraphCypherQAChain이 스키마 의미를 더 잘 보도록 type별 라벨도 붙입니다.
for node_type in ["Person", "Project", "Team", "Metric", "System", "Unknown"]:
    graph.query(
        f"""
        MATCH (e:Entity {{type: $node_type}})
        SET e:{node_type}
        """,
        params={"node_type": node_type},
    )

# 관계 저장
for kind in [
    "RESPONSIBLE_FOR",
    "AIMS_TO_REDUCE",
    "COLLABORATED_ON",
    "RELATED_TO",
]:
    graph.query(
        f"""
        UNWIND $relationships AS rel
        WITH rel
        WHERE rel.kind = $kind
        MATCH (source:Entity {{id: rel.source}})
        MATCH (target:Entity {{id: rel.target}})
        MERGE (source)-[r:{kind}]->(target)
        """,
        params={"relationships": relationships, "kind": kind},
    )

print("그래프 생성 완료!")