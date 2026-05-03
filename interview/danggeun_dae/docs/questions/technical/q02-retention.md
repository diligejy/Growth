# Q2. 재방문율 SQL 쿼리

> SQL 역량 질문

---

## 질문

"윈도우 함수나 복잡한 조인을 활용해 특정 기간 내 '재방문율'이나 '전환율'을 구하는 쿼리 로직을 설명해 보세요."

---

## 핵심 답변 포인트 (30초 요약)

```
1. CTE로 사용자별 첫 방문 코호트 생성
2. 윈도우 함수(LAG/LEAD)로 재방문 여부 체크
3. 7일, 30일 리텐션 집계
4. 코호트별 평균 리텐션 계산
```

---

## 상세 답변

### 재방문율 쿼리

```sql
WITH user_first_sessions AS (
    -- 각 사용자의 첫 방일 찾기
    SELECT 
        user_id,
        MIN(DATE(session_date)) as first_date,
        DATE_TRUNC('week', MIN(DATE(session_date))) as cohort_week
    FROM user_sessions
    WHERE session_date >= '2024-01-01'
    GROUP BY 1
),

user_activity AS (
    -- 첫 방문 이후 모든 활동
    SELECT 
        f.user_id,
        f.cohort_week,
        f.first_date,
        s.session_date,
        DATE_DIFF(DATE(s.session_date), f.first_date, DAY) as days_since_first
    FROM user_first_sessions f
    LEFT JOIN user_sessions s 
        ON f.user_id = s.user_id
        AND DATE(s.session_date) > f.first_date
),

retention_flags AS (
    -- 재방문 여부 플래그
    SELECT 
        user_id,
        cohort_week,
        -- Day 1-7 재방문
        MAX(CASE WHEN days_since_first BETWEEN 1 AND 7 THEN 1 ELSE 0 END) as week_1_retained,
        -- Day 8-14 재방문  
        MAX(CASE WHEN days_since_first BETWEEN 8 AND 14 THEN 1 ELSE 0 END) as week_2_retained,
        -- Day 1-30 재방문
        MAX(CASE WHEN days_since_first BETWEEN 1 AND 30 THEN 1 ELSE 0 END) as month_1_retained,
        -- Day 31-60 재방문
        MAX(CASE WHEN days_since_first BETWEEN 31 AND 60 THEN 1 ELSE 0 END) as month_2_retained
    FROM user_activity
    GROUP BY 1, 2
)

-- 최종 집계
SELECT 
    cohort_week,
    COUNT(DISTINCT user_id) as cohort_size,
    ROUND(AVG(week_1_retained) * 100, 2) as week_1_retention_pct,
    ROUND(AVG(week_2_retained) * 100, 2) as week_2_retention_pct,
    ROUND(AVG(month_1_retained) * 100, 2) as month_1_retention_pct,
    ROUND(AVG(month_2_retained) * 100, 2) as month_2_retention_pct
FROM retention_flags
GROUP BY 1
ORDER BY 1;
```

### 윈도우 함수 활용 버전

```sql
WITH user_sessions_ranked AS (
    -- 윈도우 함수로 세션 순서 매기기
    SELECT 
        user_id,
        DATE(session_date) as session_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY session_date) as session_rank,
        LAG(DATE(session_date)) OVER (PARTITION BY user_id ORDER BY session_date) as prev_session_date
    FROM user_sessions
    WHERE session_date >= '2024-01-01'
),

cohorts AS (
    -- 첫 방문 기준 코호트
    SELECT DISTINCT
        user_id,
        FIRST_VALUE(session_date) OVER (PARTITION BY user_id ORDER BY session_date) as first_date,
        DATE_TRUNC('week', FIRST_VALUE(session_date) OVER (PARTITION BY user_id ORDER BY session_date)) as cohort_week
    FROM user_sessions_ranked
)

-- 이후 동일하게 리텐션 계산...
```

---

## 꼬리 질문 및 답변

### Q: 당근알바의 채용 전환율은 어떻게 측정하나요?

**답변**:
```sql
WITH job_funnel AS (
    SELECT 
        job_id,
        -- 퍼널 단계별 카운트
        COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) as viewers,
        COUNT(DISTINCT CASE WHEN event_type = 'apply' THEN user_id END) as applicants,
        COUNT(DISTINCT CASE WHEN event_type = 'interview_scheduled' THEN user_id END) as interview_scheduled,
        COUNT(DISTINCT CASE WHEN event_type = 'interview_completed' THEN user_id END) as interview_completed,
        COUNT(DISTINCT CASE WHEN event_type = 'hired' THEN user_id END) as hires
    FROM job_events
    WHERE created_at >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY 1
)

SELECT 
    job_category,
    AVG(viewers) as avg_viewers,
    -- 전환율 계산
    ROUND(AVG(applicants::FLOAT / NULLIF(viewers, 0)) * 100, 2) as view_to_apply_rate,
    ROUND(AVG(interview_scheduled::FLOAT / NULLIF(applicants, 0)) * 100, 2) as apply_to_interview_rate,
    ROUND(AVG(hires::FLOAT / NULLIF(interview_completed, 0)) * 100, 2) as interview_to_hire_rate,
    -- 총 전환율
    ROUND(AVG(hires::FLOAT / NULLIF(viewers, 0)) * 100, 2) as total_conversion_rate
FROM job_funnel
GROUP BY 1
ORDER BY total_conversion_rate DESC;
```

### Q: 윈도우 함수를 쓰지 않고도 가능한가요?

**답변**:
```
"가능하지만 권장하지 않습니다.

SELF JOIN 방식:
- SELECT a.user_id, b.session_date 
- FROM sessions a 
- JOIN sessions b ON a.user_id = b.user_id AND b.date > a.date
- WHERE a.session_rank = 1

단점:
- 데이터량이 많을 때 성능 저하 (O(n^2))
- 가독성이 떨어짐

윈도우 함수가 가독성과 성능 모두 우수합니다."
```

### Q: 동일일자에 여러 세션은 어떻게 처리하나요?

**답변**:
```sql
-- 방법 1: DISTINCT로 당일 중복 제거
DATE(DISTINCT session_date) as visit_date

-- 방법 2: MIN/MAX으로 일자별 집계
MIN(DATE(session_date)) as first_visit_of_day

-- 방법 3: DAU 정의에 따라
-- DAU = Daily Active User = 당일 1회 이상 활동
-- 리텐션 = 당일 기준 방문 여부 (하루에 100번 와도 1회로 카운트)
```

### Q: 코호트가 너무 작아서 신뢰할 수 없으면?

**답변**:
```sql
-- 코호트 크기 필터링 추가
SELECT ...
FROM retention_flags
GROUP BY cohort_week
HAVING COUNT(DISTINCT user_id) >= 100  -- 최소 100명 이상
ORDER BY 1;

또는 주간/월간 코호트 대신:
- 일간 코호트 → 주간 코호트로 집계
- 더 큰 시간 단위로 코호트 생성
```

---

## 실전 팁

### 쿼리 작성 순서

```
1. CTE 순서대로 작성 (bottom-up)
2. 각 CTE마다 샘플 데이터로 검증
3. 최종 SELECT는 간결하게
4. 주석으로 비즈니스 로직 설명
```

### 면접에서 강조할 점

- **NULLIF**: 0으로 나누기 방지
- **CASTING**: applicants::FLOAT로 정확한 나눗셈
- **윈도우 함수**: 가독성과 성능의 균형

---

## Cross-Links

- 상위 문서: [key-questions.md](../key-questions.md)
- 이전 질문: [Q1 스타 스키마](./q01-star-schema.md)
- 다음 질문: [Q3 데이터 품질](./q03-data-quality.md)
