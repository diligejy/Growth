import os
from dotenv import load_dotenv

from langchain_openai import ChatOpenAI
from langchain_neo4j import Neo4jGraph, GraphCypherQAChain

load_dotenv()

OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-5.5")

graph = Neo4jGraph(
    url=os.getenv("NEO4J_URI"),
    username=os.getenv("NEO4J_USERNAME"),
    password=os.getenv("NEO4J_PASSWORD"),
    database=os.getenv("NEO4J_DATABASE"),
)
graph.refresh_schema()

llm = ChatOpenAI(
    model=OPENAI_MODEL,
    temperature=0,
)

chain = GraphCypherQAChain.from_llm(
    llm=llm,
    graph=graph,
    verbose=True,
    validate_cypher=True,
    allow_dangerous_requests=True,
)

print("Graph schema:")
print(graph.schema)

questions = [
    "김민수와 보안팀은 어떤 관계야?",
]

for question in questions:
    print("\n질문:", question)
    result = chain.invoke({"query": question})
    print("답변:", result["result"])