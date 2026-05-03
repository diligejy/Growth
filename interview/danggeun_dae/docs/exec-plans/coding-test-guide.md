# 화상 인터뷰 & 코딩 테스트 최종 가이드

> Coderpad 기반 SQL/Python 코딩 테스트 대비

---

## 🎯 코딩 테스트 핵심 정보

| 항목 | 내용 | 준비 포인트 |
|------|------|-------------|
| **플랫폼** | Coderpad | [sandbox](https://app.coderpad.io/sandbox)에서 미리 연습 |
| **언어** | SQL, Python | 둘 다 준비 |
| **난이도** | 복잡한 알고리즘 X | 데이터 분석/논리적 문제 해결 중심 |
| **화면공유** | Zoom/Google Meet | 환경 테스트 완료 |
| **시간** | 인터뷰 5분 전 입장 | 링크 미리 확인 |

---

## 👉 Coderpad 환경 미리 경험하기

**링크**: https://app.coderpad.io/sandbox

### Coderpad 특징
- **실시간 협업**: 면접관이 코드를 보며 피드백 가능
- **SQL/Python 지원**: 쿼리 실행 및 결과 확인 가능
- **자동완성**: 기본적인 문법 자동완성 제공
- **터미널**: Python 실행 결과 확인

### 연습 팁
1. sandbox에서 간단한 SQL 쿼리 작성해보기
2. Python pandas 코드 실행해보기
3. 화면 레이아웃 익히기 (코드창/결과창)

---

## 📝 SQL 코딩 테스트 준비

### 예상 문제 유형 (복잡한 알고리즘 X)

| 유형 | 예시 | 난이도 |
|------|------|--------|
| **집계/그룹핑** | 일별/월별 지표 집계 | 하 |
| **윈도우 함수** | 누적합, 순위, 전행 비교 | 중 |
| **JOIN** | 여러 테이블 조인 | 중 |
| **서브쿼리/CTE** | 복잡한 필터링 | 중 |

### 연습 문제

**문제 1: 일별 활성 사용자 수 집계**
```sql
-- 주어진 테이블: user_events (user_id, event_time, event_type)
-- 요구: 2024년 1월 일별 DAU 집계

SELECT 
    DATE(event_time) as date,
    COUNT(DISTINCT user_id) as dau
FROM user_events
WHERE event_time >= '2024-01-01'
  AND event_time < '2024-02-01'
GROUP BY 1
ORDER BY 1;
```

**문제 2: 윈도우 함수로 전일 대비 증가율 계산**
```sql
-- 요구: 일별 매출과 전일 대비 증가율

WITH daily_revenue AS (
    SELECT 
        DATE(order_date) as date,
        SUM(amount) as revenue
    FROM orders
    GROUP BY 1
)
SELECT 
    date,
    revenue,
    LAG(revenue) OVER (ORDER BY date) as prev_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY date)) / 
        LAG(revenue) OVER (ORDER BY date) * 100, 
        2
    ) as growth_pct
FROM daily_revenue
ORDER BY date;
```

**문제 3: 사용자별 첫 구매와 마지막 구매 기간**
```sql
-- 요구: 각 사용자의 첫 구매일, 마지막 구매일, 구매 횟수

SELECT 
    user_id,
    MIN(order_date) as first_purchase,
    MAX(order_date) as last_purchase,
    COUNT(*) as purchase_count
FROM orders
GROUP BY user_id
HAVING COUNT(*) >= 2;  -- 2회 이상 구매자만
```

---

## 🐍 Python 코딩 테스트 준비

### 예상 문제 유형 (복잡한 알고리즘 X)

| 유형 | 예시 | 난이도 |
|------|------|--------|
| **데이터 처리** | pandas groupby, filter | 하~중 |
| **간단한 ETL** | CSV 읽고 변환해서 저장 | 중 |
| **집계/통계** | 평균, 중간값, 표준편차 | 하 |
| **날짜 처리** | 날짜 변환, 기간 계산 | 중 |

### 연습 문제

**문제 1: pandas로 데이터 집계**
```python
import pandas as pd

# 데이터 로드 (가정)
df = pd.read_csv('user_events.csv')

# 일별 DAU 집계
daily_dau = df.groupby(df['event_time'].dt.date)['user_id'].nunique().reset_index()
daily_dau.columns = ['date', 'dau']

print(daily_dau)
```

**문제 2: 간단한 데이터 품질 체크**
```python
import pandas as pd

def check_data_quality(df):
    """
    데이터 품질 체크 함수
    - null 값 비율
    - 중복 행 수
    - 이상치 범위
    """
    report = {}
    
    # null 체크
    report['null_counts'] = df.isnull().sum().to_dict()
    
    # 중복 체크
    report['duplicate_rows'] = df.duplicated().sum()
    
    # 수치형 컬럼 이상치 체크 (IQR 방법)
    numeric_cols = df.select_dtypes(include=['int64', 'float64']).columns
    for col in numeric_cols:
        Q1 = df[col].quantile(0.25)
        Q3 = df[col].quantile(0.75)
        IQR = Q3 - Q1
        outliers = df[(df[col] < Q1 - 1.5*IQR) | (df[col] > Q3 + 1.5*IQR)]
        report[f'{col}_outliers'] = len(outliers)
    
    return report

# 사용
# quality_report = check_data_quality(df)
# print(quality_report)
```

**문제 3: 날짜 기준 필터링**
```python
import pandas as pd
from datetime import datetime, timedelta

# 최근 7일 데이터 필터링
def get_recent_data(df, date_col, days=7):
    cutoff_date = datetime.now() - timedelta(days=days)
    return df[df[date_col] >= cutoff_date]

# 사용
# recent_df = get_recent_data(df, 'event_time', 7)
```

---

## 🏭 Factory DAG 패턴 (이력서 기반 예상)

당근 서비스(중고/알바/비즈)용 DAG 자동 생성 패턴

```python
# 예상 문제: 3개 서비스용 DAG를 Factory 패턴으로 생성

SERVICE_CONFIGS = [
    {'name': 'karrot_used', 'schedule': '0 3 * * *', 'table': 'used_transactions'},
    {'name': 'karrot_alba', 'schedule': '0 4 * * *', 'table': 'alba_applications'},
    {'name': 'karrot_biz', 'schedule': '0 5 * * *', 'table': 'biz_profiles'},
]

def create_etl_dag(config):
    """
    서비스별 ETL DAG 생성 함수
    """
    dag_id = f"etl_{config['name']}"
    
    # DAG 정의 (의사코드)
    print(f"Creating DAG: {dag_id}")
    print(f"Schedule: {config['schedule']}")
    print(f"Source table: {config['table']}")
    
    # 실제로는 Airflow DAG 객체 반환
    return {
        'dag_id': dag_id,
        'schedule': config['schedule'],
        'tasks': ['extract', 'transform', 'load']
    }

# 모든 서비스용 DAG 생성
dags = [create_etl_dag(cfg) for cfg in SERVICE_CONFIGS]
print(f"\nCreated {len(dags)} DAGs")
```

---

## ✅ 코딩 테스트 당일 체크리스트

### 입장 전 (5분 전)

- [ ] 링크 접속 확인
- [ ] Coderpad 연결 확인
- [ ] 마이크/카메라 테스트
- [ ] 화면공유 권한 확인
- [ ] 음료 준비

### 테스트 중

- [ ] 문제를 먼저 **충분히 읽기**
- [ ] **의사소통**: "이렇게 접근하겠습니다"라고 말하기
- [ ] **단계별 진행**: 한 번에 전부가 아닌 단계적으로
- [ ] **궁금한 점은 바로 질문**: "이 부분 명확하지 않은데요..."
- [ ] **테스트**: 쿼리/코드 실행해서 결과 확인

### 문제 해결 전략

```
1. 문제 이해 (1-2분)
   - "~한 결과를 원하시는 게 맞나요?"

2. 접근법 설명 (1-2분)
   - "이렇게 접근하겠습니다..."

3. 코드 작성 (10-15분)
   - 단계별로 작성
   - 실행하면서 확인

4. 검토 (2-3분)
   - 결과가 맞는지 확인
   - 엣지케이스 고려
```

---

## 🗣️ 코딩 테스트 중 추천하는 대화법

| 상황 | 추천하는 말 |
|------|------------|
| 문제 이해 후 | "요구사항을 이렇게 정리했습니다. 맞나요?" |
| 접근법 설명 | "이 문제는 ~ 방식으로 접근하겠습니다" |
| 코드 작성 중 | "여기서는 윈도우 함수를 사용해서..." |
| 막혔을 때 | "이 부분에서 잠시 생각이 필요합니다" |
| 완료 후 | "코드를 실행해서 결과 확인하겠습니다" |

---

## 🚨 문제 발생 시

### 인터넷 연결 끊김
- 당황하지 말고 재접속
- 채용 담당자 연락처로 바로 연락
- **영향 없음** (미리 고지됨)

### Coderpad 오류
- 면접관에게 바로 말하기
- "Coderpad에 오류가 있는데, 잠시 시간 괜찮으신가요?"

### 모르는 문제
- 솔직하게 인정
- "정확한 답은 모르겠지만, 이렇게 접근할 것 같습니다"

---

## 📚 마지막 복습 (30분 전)

### SQL
- [ ] GROUP BY + 집계 함수
- [ ] 윈도우 함수 (ROW_NUMBER, LAG/LEAD)
- [ ] JOIN (INNER, LEFT)
- [ ] CTE (WITH 절)

### Python
- [ ] pandas groupby
- [ ] pandas merge/join
- [ ] 날짜 처리 (pd.to_datetime)
- [ ] 간단한 함수 작성

---

## 🎉 최종 메시지

```
당신은 준비되었습니다.

Factory DAG + DQC + Metric Catalog 경험을 바탕으로
Coderpad에서 SQL/Python 문제를 풀 준비가 되었습니다.

중요한 것:
1. 문제를 충분히 이해하기
2. 단계별로 접근하기
3. 면접관과 소통하기
4. 결과를 검증하기

화이팅! 🥕
```

---

*출처: 당근 화상 인터뷰 가이드*
*Last updated: 2026-04-06 23:50*
