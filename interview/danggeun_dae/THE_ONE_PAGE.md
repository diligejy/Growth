# 당근 DAE 통합 면접 준비 - THE ONE PAGE

> 이력서 + 채용공고 + 블로그 인사이트 + 화상 인터뷰 가이드 통합

---

## 🎯 핵심 정보 (한눈에 보기)

### 면접 정보
| 항목 | 내용 |
|------|------|
| **직무** | Data Analytics Engineer (데이터 가치화 팀) |
| **날짜** | 2026년 4월 7일 (내일) |
| **형태** | 화상 인터뷰 + Coderpad 코딩 테스트 |
| **시간** | 인터뷰 5분 전 입장 |
| **복장** | 완전 자유 (편한 복장) |

### 지원자 프로필 (송진영)
| 항목 | 내용 |
|------|------|
| **경력** | 3년 7개월 (Coupang CLS, Big Insight) |
| **핵심 강점** | Factory DAG, DQC 51규칙+pytest 153테스트, Metric Catalog |
| **기술** | Airflow, Python, SQL, Jinja2, Presto, Redshift |
| **특이사항** | PyTorch 문서 한글화 기여 (오픈소스) |

---

## 📋 3단계 면접 전형

```
┌─────────────────────────────────────────────────────────────┐
│  1. 화상 인터뷰 (코딩 테스트)                                │
│     ├── Coderpad에서 SQL/Python 문제 해결                    │
│     ├── 복잡한 알고리즘 X, 데이터 분석 중심                   │
│     └── Factory DAG 패턴 관련 문제 예상                       │
│                                                              │
│  2. 직무 인터뷰                                              │
│     ├── 기술 질문 (dbt, Airflow, BigQuery)                   │
│     ├── 비즈니스 질문 (당근 지표, 데이터 거버넌스)            │
│     └── 프로젝트 경험 심층 질문                              │
│                                                              │
│  3. 컬처핏 인터뷰                                            │
│     ├── 협업 경험                                            │
│     ├── 문제 해결 방식                                        │
│     └── "왜 당근인가?"                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔥 핵심 질문 5선 (반드시 준비)

### Q1. Factory DAG + Jinja2 템플릿 경험을 dbt에 어떻게 적용하나요?

**답변 포인트**:
- 33개 물류센터를 Factory DAG로 통합 (온보딩 2주→2시간)
- Jinja2 템플릿 SQL로 스키마 추상화
- dbt macro로 당근 서비스(중고/알바/비즈)별 템플릿화 가능

### Q2. DQC 51규칙 + pytest 153테스트로 구축한 이중 품질 체계를 설명해주세요.

**답변 포인트**:
- Presto 기반 DQC (비즈니스 로직 품질)
- pytest 기반 파이프라인 테스트 (엔지니어링 품질)
- 140만 행 누락 버그 사전 탐지
- dbt tests + Airflow SLA로 당근에서도 구현 가능

### Q3. 6개 팀 간 3년 미해결 데이터 연동 불일치를 어떻게 해결했나요?

**답변 포인트**:
- 타임스탬프 분석으로 근본 원인 규명 (KST vs UTC, 정밀도 차이)
- 전사 표준 정의 (UTC + millisecond + ISO 8601)
- 당근도 동네 기반으로 시간대 처리 중요

### Q4. Metric Catalog로 전사 지표 거버넌스를 어떻게 운영했나요?

**답변 포인트**:
- 전사 지표 정의 통일
- 데이터 신뢰성(Observability) 확보
- 당근의 "매일 데이터를 통한 의사결정" 비전과 부합

### Q5. 왜 당근인가요?

**답변 포인트**:
1. "매일 데이터를 통해 사용자를 위한 의사결정을 한다"는 비전에 공감
2. Factory DAG + DQC + Metric Catalog 경험이 당근 DAE와 완벽한 fit
3. dbt와 Airflow를 활용해 데이터 분석가들이 "뛰어놀 수 있는 환경"을 만들고 싶음

---

## 🐍 Coderpad 코딩 테스트 대비

### SQL (윈도우 함수 중심)

```sql
-- 일별 DAU + 전일 대비 증가율
WITH daily_stats AS (
    SELECT 
        DATE(event_time) as date,
        COUNT(DISTINCT user_id) as dau
    FROM user_events
    GROUP BY 1
)
SELECT 
    date,
    dau,
    LAG(dau) OVER (ORDER BY date) as prev_dau,
    ROUND((dau - LAG(dau) OVER (ORDER BY date)) / LAG(dau) OVER (ORDER BY date) * 100, 2) as growth_pct
FROM daily_stats;
```

### Python (pandas 중심)

```python
import pandas as pd

# Factory DAG 패턴 (서비스별 설정)
SERVICE_CONFIGS = [
    {'name': 'karrot_used', 'schedule': '0 3 * * *'},
    {'name': 'karrot_alba', 'schedule': '0 4 * * *'},
]

def create_dag(config):
    return {
        'dag_id': f"etl_{config['name']}",
        'schedule': config['schedule']
    }

# 자동 생성
dags = [create_dag(cfg) for cfg in SERVICE_CONFIGS]
```

---

## 🎯 기술-경험 매핑

| 당근 요구사항 | 이력서 경력 | 어필 포인트 |
|---------------|-------------|-------------|
| dbt | Jinja2 템플릿 경험 | macro 학습 빠름 |
| Airflow | Factory DAG | 33개 센터 자동화 |
| BigQuery | Redshift, Presto | SQL 호환, 최적화 이해 |
| 데이터 거버넌스 | Metric Catalog | 전사 지표 정의/관리 |
| A/B 테스트 | 이벤트 택소노미 | 실험 인프라 이해 |

---

## ✅ 최종 체크리스트 (내일 아침까지)

### 기술
- [ ] Factory DAG 패턴 코드 1개 손으로 작성 가능
- [ ] SQL 윈도우 함수 (LAG/LEAD) 복습 완료
- [ ] dbt incremental model 개념 설명 가능

### 비즈니스
- [ ] 당근 데이터 가치화 팀 비전: "매일 데이터를 통해 사용자를 위한 의사결정"
- [ ] MAU 정체 속 DAU/사용시간 성장 의미 설명 가능
- [ ] 하이퍼로컬 광고 99.7% 이해

### 컬처핏
- [ ] "왜 당근인가" 1분 답변 외우기
- [ ] PyTorch 기여 → 공유 문화 연결
- [ ] 질문할 내용 3개 준비

### 코딩 테스트
- [ ] Coderpad sandbox 접속 확인
- [ ] SQL 집계/윈도우 함수 연습
- [ ] Python pandas 연습

---

## 🗣️ 면접관 역할 시작

이제 저는 당근 DAE 면접관입니다. **실전 모의 면접을 시작하겠습니다.**

### 준비되셨나요?

아래 중 선택해주세요:

1. **코딩 테스트 연습** - Coderpad 환경에서 SQL/Python 문제
2. **직무 인터뷰 연습** - 기술/비즈니스 질문
3. **컬처핏 인터뷰 연습** - "왜 당근인가" 및 협업 질문
4. **풀 모의 인터뷰** - 모든 단계 30분 연습

**원하시는 모드를 알려주세요.**

---

*통합 자료 완료. 이제 면접 연습을 시작합니다.*
