# Q4. BigQuery 비용 최적화

> 효율성 질문

---

## 질문

"BigQuery 비용이 급증하고 있다면, 쿼리 최적화나 아키텍처 측면에서 어떻게 개선하겠는가?"

---

## 핵심 답변 포인트 (30초 요약)

```
비용 최적화 4단계:
1. 쿼리 패턴 분석 (INFORMATION_SCHEMA.JOBS)
2. 저장소 최적화 (파티셔닝/클러스터링)
3. 쿼리 최적화 (SELECT *, JOIN 순서)
4. 아키텍처 변경 (Materialized View, BI Engine)
```

---

## 상세 답변

### 1단계: 쿼리 패턴 분석

```sql
-- 가장 비용이 많이 드는 쿼리 식별
SELECT 
    job_id,
    user_email,
    query,
    total_bytes_processed / 1024/1024/1024 as gb_processed,
    total_bytes_processed / 1024/1024/1024 * 5 as estimated_cost_usd  -- $5/TB
FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
  AND job_type = 'QUERY'
ORDER BY total_bytes_processed DESC
LIMIT 20;
```

### 2단계: 저장소 최적화

| 기법 | 설명 | 효과 |
|------|------|------|
| **파티셔닝** | 날짜/시간 기준 분할 | WHERE 절로 특정 파티션만 스캔 |
| **클러스터링** | 컬럼 값 기준 정렬 | WHERE 절로 특정 범위만 스캔 |
| **오래된 데이터 아카이브** | Coldline Storage 이동 | 저장 비용 절감 |

```sql
-- 파티셔닝/클러스터링 예시
CREATE TABLE fct_transactions (
    transaction_id STRING,
    transaction_date DATE,
    location_id STRING,
    category_id STRING,
    price FLOAT
)
PARTITION BY DATE(transaction_date)  -- 파티셔닝
CLUSTER BY location_id, category_id;  -- 클러스터링
```

### 3단계: 쿼리 최적화

| 안티패턴 | 개선안 | 효과 |
|----------|--------|------|
| `SELECT *` | 필요한 컬럼만 | 50%+ 절감 |
| `LIMIT`만 있는 필터 | `WHERE` 절 필터링 | 90%+ 절감 |
| 대소문자 변환 후 JOIN | 원본값으로 JOIN | 불필요한 연산 제거 |
| 큰 테이블 LEFT JOIN | 작은 테이블이 왼쪽 | 메모리 효율 |

```sql
-- 개선 전
SELECT * 
FROM large_table
LIMIT 100;
-- → 전체 테이블 스캔 후 100행 반환

-- 개선 후
SELECT transaction_id, price, status
FROM large_table
WHERE transaction_date >= '2024-01-01'
  AND location_id = 'gangnam_001';
-- → 파티션/클러스터 프루닝으로 최소 데이터만 스캔
```

### 4단계: 아키텍처 변경

| 기법 | 사용 사례 | 효과 |
|------|----------|------|
| **Materialized View** | 자주 쓰는 집계 | 쿼리 10x+ 빠름 |
| **BI Engine** | 대시보드 캐싱 | 쿼리 100x+ 빠름 |
| **Slot Reservation** | 예측 가능한 워크로드 | 비용 예측 가능 |

---

## 꼬리 질문 및 답변

### Q: dbt incremental 모델에서 비용을 줄이려면?

**답변**:
```sql
-- last_run_timestamp 활용
{% if is_incremental() %}
  WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
{% endif %}

-- MERGE 문으로 UPSERT 최적화
MERGE target_table T
USING source_table S
ON T.id = S.id
WHEN MATCHED THEN UPDATE SET ...
WHEN NOT MATCHED THEN INSERT ...
```

### Q: 반복 실행되는 쿼리가 많다면?

**답변**:
1. **Materialized View** - 자주 쓰는 집계 미리 계산
2. **Query Cache** - 24시간 캐싱 활용
3. **Result Cache** - 동일 쿼리 결과 재사용
4. **데이터 마트** - 자주 쓰는 조합 테이블 미리 생성

### Q: Storage 비용도 높다면?

**답변**:
1. **Time Partitioning Expiration** - 90일 이후 자동 삭제
2. **Lifecycle Policy** - 1년 후 Coldline으로 이동
3. **Unused Table Detection** - 90일 미사용 테이블 아카이브
4. **Column-level compression** - 중복 데이터 제거

---

## 실전 팁

### 비용 모니터링 대시보드

```sql
-- 일별 비용 추이
SELECT 
    DATE(creation_time) as date,
    SUM(total_bytes_processed) / 1024/1024/1024/1024 as tb_processed,
    SUM(total_bytes_processed) / 1024/1024/1024/1024 * 5 as cost_usd
FROM `region-us`.INFORMATION_SCHEMA.JOBS_BY_PROJECT
WHERE creation_time >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY 1
ORDER BY 1;
```

### 면접에서 강조할 점

- **proactive monitoring**: 비용 폭증을 사전에 감지
- **cost-performance balance**: 비용 절감이 쿼리 성능을 해치지 않도록
- **dbt incremental**: 가장 효과적인 비용 절감 기법

---

## Cross-Links

- 상위 문서: [key-questions.md](../key-questions.md)
- 이전 질문: [Q3 데이터 품질](./q03-data-quality.md)
- 다음 질문: [Q5 Airflow 멱등성](./q05-airflow-idempotency.md)
