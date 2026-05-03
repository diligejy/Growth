# Q5. Airflow Idempotency

> 효율성 질문

---

## 질문

"Airflow DAG 설계 시 'Idempotency(멱등성)'가 왜 중요한지, 당근의 환경에서 어떻게 보장할 것인지?"

---

## 핵심 답변 포인트 (30초 요약)

```
Idempotency: 동일 입력 → 동일 출력 (여러 번 실행해도 결과 동일)

보장 방법:
1. INSERT OVERWRITE (파티션 교체)
2. UPSERT (MERGE) 패턴
3. 실행 ID 기반 관리
```

---

## 상세 답변

### Idempotency가 중요한 이유

| 상황 | 문제 | 결과 |
|------|------|------|
| DAG 재실행 | 중복 데이터 삽입 | 지표 왜곡 |
| DAG 동시 실행 | 경쟁 상태 | 데이터 불일치 |
| DAG 실패 후 재시도 | 부분 처리 | 불완전한 데이터 |

### 3가지 구현 방법

**방법 1: INSERT OVERWRITE**

```sql
-- 매 실행마다 타겟 파티션 완전 교체
INSERT OVERWRITE TABLE fact_transactions
PARTITION(transaction_date = '{{ ds }}')
SELECT * FROM staging_transactions
WHERE transaction_date = '{{ ds }}';
```

**방법 2: UPSERT (MERGE)**

```sql
-- 기존 데이터와 비교하여 변경된 행만 처리
MERGE fact_transactions T
USING (
    SELECT * FROM staging_transactions 
    WHERE transaction_date = '{{ ds }}'
) S
ON T.transaction_id = S.transaction_id
WHEN MATCHED THEN 
    UPDATE SET price = S.price, status = S.status
WHEN NOT MATCHED THEN 
    INSERT (transaction_id, transaction_date, price, status)
    VALUES (S.transaction_id, S.transaction_date, S.price, S.status);
```

**방법 3: 실행 ID 기반 관리**

```sql
-- dbt의 invocation_id 활용
ALTER TABLE fact_transactions 
ADD COLUMN _loaded_at TIMESTAMP,
ADD COLUMN _loaded_by STRING;

INSERT INTO fact_transactions
SELECT 
    *,
    CURRENT_TIMESTAMP() as _loaded_at,
    '{{ run_id }}' as _loaded_by
FROM staging_transactions;

-- 중복 제거 쿼리
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY transaction_id 
    ORDER BY _loaded_at DESC
) = 1;
```

---

## 꼬리 질문 및 답변

### Q: 동일 시간에 DAG가 두 번 실행되면?

**답변**:
```
"2가지 방어:

1. Airflow 설정
   - max_active_runs=1 (동시 실행 제한)
   - concurrency=1 (태스크 동시성 제한)

2. Idempotent 로직
   - INSERT OVERWRITE로 인해 동일한 결과 생성
   - MERGE로 중복 방지

결과적으로 동시 실행되더라도 데이터 일관성 유지"
```

### Q: 실패한 DAG를 어떻게 재시도하나요?

**답변**:
```python
# Airflow 설정
default_args = {
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
    'retry_exponential_backoff': True,
    'max_retry_delay': timedelta(minutes=30)
}

# Idempotent하게 설계되어 있으므로
# 어느 태스크에서 실패하든 재시도 가능
```

### Q: backfill 시에도 Idempotency가 필요한가요?

**답변**:
```
"특히 중요합니다.

Backfill 특성:
- 과거 날짜 데이터를 재처리
- 이미 존재하는 데이터 덮어쓰기

INSERT OVERWRITE/MERGE가 없으면:
- 과거 데이터 중복 삽입
- 시계열 지표 왜곡 (MAU, 매출 등)

dbt incremental 모델:
- backfill 시에도 안전하게 동작
- {{ is_incremental() }} 조건문 활용"
```

---

## 실전 팁

### Airflow 설정 예시

```python
from airflow import DAG
from airflow.operators.bigquery import BigQueryInsertJobOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
    'max_active_runs': 1,  -- 핵심: 동시 실행 방지
}

with DAG(
    'daily_transactions',
    default_args=default_args,
    schedule_interval='0 3 * * *',  -- 매일 새벽 3시
    catchup=False,  -- 과거 누락분 자동 backfill 방지
) as dag:
    
    load_transactions = BigQueryInsertJobOperator(
        task_id='load_transactions',
        configuration={
            "query": {
                "query": """
                    INSERT OVERWRITE `project.dataset.fact_transactions`
                    PARTITION(transaction_date = '{{ ds }}')
                    SELECT * FROM `project.dataset.staging_transactions`
                    WHERE transaction_date = '{{ ds }}'
                """,
                "useLegacySql": False,
            }
        }
    )
```

### 면접에서 강조할 점

- **data consistency**: 지표 왜곡 방지
- **retry safety**: 장애 발생 시 안전한 재실행
- **dbt integration**: dbt의 incremental model과 자연스럽게 연결

---

## Cross-Links

- 상위 문서: [key-questions.md](../key-questions.md)
- 이전 질문: [Q4 BigQuery 최적화](./q04-bq-optimization.md)
- 비즈니스 질문: [../business/](../business/)
