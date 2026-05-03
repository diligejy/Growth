# Q1. 중고거래 스타 스키마 설계

> 데이터 모델링 질문

---

## 질문

"당근의 중고거래 데이터를 스타 스키마(Star Schema)로 설계한다면 팩트(Fact) 테이블과 디멘션(Dimension) 테이블을 어떻게 나누겠는가?"

---

## 핵심 답변 포인트 (30초 요약)

```
Fact Table: 거래 이벤트 중심
- transaction_id, 날짜, FK들, 측정값(가격, 상태)

Dimension Tables: 분석 관점
- 사용자, 상품, 카테고리, 위치, 시간

최적화:
- 파티션: transaction_date
- 클러스터링: location_id, category_id
```

---

## 상세 답변

### Schema 설계

```sql
-- Fact Table: 거래 이벤트
CREATE TABLE fct_transactions (
    transaction_id STRING PRIMARY KEY,
    transaction_date DATE,  -- Partition Key
    
    -- Foreign Keys
    buyer_id STRING,        -- FK → dim_users
    seller_id STRING,       -- FK → dim_users  
    product_id STRING,      -- FK → dim_products
    category_id STRING,     -- FK → dim_categories
    location_id STRING,     -- FK → dim_locations
    
    -- Measures (측정값)
    price DECIMAL,
    status STRING,          -- completed/cancelled/disputed/pending
    manner_score_change INT,
    
    -- Metadata
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)
PARTITION BY DATE(transaction_date)
CLUSTER BY location_id, category_id;

-- Dimension: 사용자
CREATE TABLE dim_users (
    user_id STRING PRIMARY KEY,
    signup_date DATE,
    primary_location_id STRING,
    manner_score INT,
    user_type STRING        -- regular/biz_profile
);

-- Dimension: 상품  
CREATE TABLE dim_products (
    product_id STRING PRIMARY KEY,
    product_name STRING,
    category_id STRING,   -- FK → dim_categories
    condition STRING,       -- new/likenew/used
    brand STRING,
    original_price DECIMAL
);

-- Dimension: 카테고리
CREATE TABLE dim_categories (
    category_id STRING PRIMARY KEY,
    category_name STRING,
    parent_category_id STRING,
    level INT              -- 1:대분류, 2:중분류, 3:소분류
);

-- Dimension: 위치 (동네)
CREATE TABLE dim_locations (
    location_id STRING PRIMARY KEY,
    dong_name STRING,
    gu_name STRING,
    city_name STRING,
    latitude FLOAT,
    longitude FLOAT
);

-- Dimension: 시간 (날짜)
CREATE TABLE dim_dates (
    date DATE PRIMARY KEY,
    year INT,
    month INT,
    day INT,
    weekday INT,            -- 0=일요일
    is_holiday BOOLEAN,
    is_weekend BOOLEAN
);
```

### 설계 이유

**왜 Star Schema인가?**

1. **쿼리 성능**: JOIN이 Dimension 테이블과만 발생, 쿼리 단순화
2. **분석가 이해도**: 직관적인 구조, 셀프서비스 분석 용이
3. **집계 최적화**: Fact Table만 스캔하면 대부분의 집계 가능

**파티셔닝/클러스터링 전략**:

```
Partition: transaction_date
- 대부분의 쿼리가 최근 데이터 필터링
- 오래된 데이터는 아카이브/삭제 용이

Clustering: location_id, category_id
- 하이퍼로컬 광고 분석에 필수 (지역 필터)
- 카테고리별 트렌드 분석에 최적화
```

---

## 꼬리 질문 및 답변

### Q: 왜 Snowflake Schema가 아닌 Star Schema인가?

**답변**:
```
"Snowflake는 Dimension을 정규화하여 저장 효율성이 높지만,
당근처럼 빠른 비즈니스 의사결정이 필요한 환경에서는
쿼리 복잡성이 더 큰 문제입니다.

Star Schema는:
- 쿼리가 단순해 분석가가 직접 작성 가능
- BigQuery가 Star Schema에 최적화됨
- 저장 비용보다 쿼리 비용/시간 절감이 더 중요"
```

### Q: 클러스터링 컬럼 선정 기준은?

**답변**:
```
"Cardinality가 높고, 자주 필터링되는 컬럼을 선택합니다.

선택: location_id (동 수천 개), category_id (카테고리 수백 개)
제외: status (4개 값) - 너무 낮은 cardinality

데이터 분포가 바뀌면:
- 모니터링으로 쿼리 패턴 변화 감지
- 필요시 클러스터링 컬럼 재조정"
```

### Q: SCD (Slowly Changing Dimension)는 어떻게 처리하나?

**답변**:
```
"사용자 매너온도나 위치 변경이 있을 수 있습니다.

SCD Type 2 방식:
- effective_start_date, effective_end_date 추가
- is_current 플래그로 현재 값 표시
- 거래 시점의 Dimension 값 정확히 추적 가능

예: 사용자가 강남→분당 이사 시
- 과거 거래는 강남 기준 분석
- 최신 거래는 분당 기준 분석"
```

### Q: Fact Table이 너무 커지면?

**답변**:
```
"3가지 전략:

1. 파티션 아카이브
   - 2년 이상된 파티션은 Coldline Storage로 이동
   
2. Aggregation 테이블 별도 생성
   - 일별 집계: fct_daily_transactions
   - 월별 집계: fct_monthly_transactions
   
3. 샘플링 테이블
   - 과거 데이터는 10% 샘플링으로 분석용 테이블 생성"
```

---

## 실전 팁

### 면접에서 그리기

```
        ┌─────────────────┐
        │   fct_transactions  │
        │   (Fact Table)    │
        └────────┬────────┘
                 │
    ┌────────────┼────────────┐
    │            │            │
    ▼            ▼            ▼
┌───────┐   ┌───────┐   ┌───────┐
│dim_users│   │dim_products│   │dim_locations│
└───────┘   └───────┘   └───────┘
    │            │            │
    ▼            ▼            ▼
┌───────┐   ┌───────┐
│dim_categories│   │dim_dates│
└───────┘   └───────┘

(차트 그리며 설명하면 가산점)
```

### 강조할 키워드

- **파티셔닝/클러스터링**: BigQuery 비용 최적화
- **SCD Type 2**: 시간에 따른 변화 추적
- **BigQuery 특화**: partition pruning, cluster pruning

---

## Cross-Links

- 상위 문서: [key-questions.md](../key-questions.md)
- DAE 역할: [dae-role.md](../../design-docs/dae-role.md)
- 다음 질문: [Q2 SQL 재방문율](./q02-retention.md)
