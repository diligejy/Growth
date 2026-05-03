# 당근마켓 DAE 면접 준비 자료 (DAE 특화 버전)

> **DAE 직무 핵심**: "비즈니스 임팩트를 위해 분석하기 좋은 데이터 환경을 설계하는 사람"
> 단순 파이프라인 엔지니어 X, 비즈니스 지향적 데이터 엔지니어 O

---

## 1. 당근 비즈니스 모델 이해

### 핵심 수익원

| BM | 비중 | 데이터 역할 |
|----|------|-------------|
| **하이퍼로컬 광고** | 90%+ | 지역/관심사 타겟팅 정교화 |
| **비즈프로필** | 성장 중 | 커머스 데이터 (예약, 결제, 단골) |
| **버티컬 서비스** | 확장 중 | 신뢰도 지표(매너온도), 매칭 알고리즘 |
| **당근페이** | Lock-in | 구매력 데이터 확보 |

### DAE가 설계해야 할 데이터

```
하이퍼로컬 광고를 위한 데이터:
├── 사용자: 위치 데이터, 관심 카테고리, 검색 패턴
├── 광고주: 업종, 타겟 반경, 예산, 광고 효과
└── 매칭: 광고 노출 -> 클릭 -> 채팅/문의 -> 전환

비즈프로필 데이터:
├── 가게 정보: 카테고리, 위치, 영업시간
├── 고객 행동: 방문, 예약, 결제, 리뷰
└── 단골 관리: 재방문 주기, 선호도

버티컬 서비스 데이터:
├── 중고거래: 매너온도, 거래 완료율, 분쟁율
├── 알바: 구인/구직 매칭, 지원 -> 면접 -> 채용 전환율
├── 부동산: 매물 관심도, 중개사 신뢰도
└── 중고차: 차량 상태, 가격 적정성, 거래 안전성
```

---

## 2. DAE 기술 스택

| 기술 | 용도 | 면접에서 강조할 점 |
|------|------|------------------|
| **GCP BigQuery** | 메인 데이터 저장소 | 비용 최적화, 파티셔닝/클러스터링 |
| **dbt** | 데이터 모델링/문서화 | SQL 기반 변환, 버전 관리, 테스트 |
| **Airflow** | 파이프라인 스케줄링 | Idempotency(멱등성) 보장 |
| **Python/SQL** | 데이터 가공/분석 | 복잡한 비즈니스 로직 구현 |

---

## 3. 면접 질문 & 답변 (꼬리 질문 포함)

### 📋 [직무/기술 질문]

---

#### Q1. 당근의 중고거래 데이터를 스타 스키마로 설계한다면?

**메인 답변**:
```
중고거래 스타 스키마 설계:

[Fact Table - fct_transactions]
- transaction_id (PK)
- transaction_date (Partition Key)
- buyer_id (FK)
- seller_id (FK)
- product_id (FK)
- location_id (FK)
- price
- status (completed/cancelled/disputed)
- manner_score_change

[Dimension Tables]
- dim_users: user_id, signup_date, location, manner_score
- dim_products: product_id, category_id, condition, brand
- dim_categories: category_id, category_name, parent_category
- dim_locations: location_id, dong, gu, city, lat, lng
- dim_dates: date, year, month, day, weekday, is_holiday

선택 이유: 
- 분석 쿼리 단순화 (JOIN 최소화)
- 집계 성능 최적화
- 비즈니스 질문 답변 용이 ("어떤 카테고리가 어떤 지역에서 잘 팔리는가?")
```

**꼬리 질문 1**: 왜 스타 스키마를 선택했나요? Snowflake Schema는?
> "스타 스키마는 쿼리 성능이 우수하고 분석가가 이해하기 쉽습니다. 
> 당근처럼 빠른 비즈니스 의사결정이 필요한 환경에서는 
> 정규화로 인한 복잡성보다 단순함이 더 중요하다고 판단했습니다."

**꼬리 질문 2**: 파티셔닝과 클러스터링은 어떻게 설계하나요?
> "파티션은 transaction_date(일 단위)로 분할하고,
> 클러스터링은 location_id, category_id 순서로 지정합니다.
> 이유: 대부분의 쿼리가 최근 데이터 + 특정 지역/카테고리 필터링하기 때문입니다."

---

#### Q2. 특정 기간 내 '재방문율'을 계산하는 SQL 쿼리

**메인 답변**:
```sql
WITH user_sessions AS (
    SELECT 
        user_id,
        DATE_TRUNC('week', session_date) as cohort_week,
        MIN(session_date) as first_session
    FROM sessions
    WHERE session_date >= '2024-01-01'
    GROUP BY 1, 2
),
-- 각 유저의 첫 방문 후 7일, 14일, 30일 내 재방문 여부
retention AS (
    SELECT 
        s.user_id,
        s.cohort_week,
        CASE WHEN MAX(CASE WHEN s2.session_date BETWEEN s.first_session + 7 
                            AND s.first_session + 14 THEN 1 END) = 1 
             THEN 1 ELSE 0 END as week_2_retained,
        CASE WHEN MAX(CASE WHEN s2.session_date BETWEEN s.first_session + 30 
                            AND s.first_session + 60 THEN 1 END) = 1 
             THEN 1 ELSE 0 END as month_2_retained
    FROM user_sessions s
    LEFT JOIN sessions s2 ON s.user_id = s2.user_id
        AND s2.session_date > s.first_session
    GROUP BY 1, 2
)
SELECT 
    cohort_week,
    COUNT(DISTINCT user_id) as cohort_size,
    ROUND(AVG(week_2_retained) * 100, 2) as week_2_retention_pct,
    ROUND(AVG(month_2_retained) * 100, 2) as month_2_retention_pct
FROM retention
GROUP BY 1
ORDER BY 1;
```

**꼬리 질문 1**: 윈도우 함수를 쓰지 않고 풀 수 있나요?
> "가능하지만, 윈도우 함수가 가독성과 성능이 우수합니다. 
> SELF JOIN 방식은 데이터가 많을 때 성능이 저하됩니다."

**꼬리 질문 2**: 당근알바의 채용 전환율을 측정하려면?
> ```sql
> WITH funnel AS (
>     SELECT 
>         job_id,
>         COUNT(DISTINCT CASE WHEN event = 'view' THEN user_id END) as viewers,
>         COUNT(DISTINCT CASE WHEN event = 'apply' THEN user_id END) as applicants,
>         COUNT(DISTINCT CASE WHEN event = 'interview_scheduled' THEN user_id END) as interviewees,
>         COUNT(DISTINCT CASE WHEN event = 'hired' THEN user_id END) as hires
>     FROM job_events
>     GROUP BY 1
> )
> SELECT 
>     AVG(applicants::FLOAT / NULLIF(viewers, 0)) as view_to_apply_rate,
>     AVG(hires::FLOAT / NULLIF(applicants, 0)) as apply_to_hire_rate
> FROM funnel;
> ```

---

#### Q3. 로그 데이터 누락 시 비즈니스 지표 완곡 방지 조치

**메인 답변**:
```
3단계 방어 전략:

1단계: 실시간 모니터링
- 로그 수집량 기준선 설정 (시간별/분별 기대량)
- 예상량 대비 20% 이상 차이 시 알림 발송
- Airflow DAG 실패/지연 감지

2단계: 데이터 품질 검증
- dbt tests: not_null, unique, accepted_values
- 새벙 배치 시 데이터 검증 파이프라인 실행
- 지표 비교: 어제 대비 오늘 변화율이 이상치인지

3단계: 누락 시 복구 절차
- 누락 기간 표시 (is_partial_data = true)
- 백필(backfill) 파이프라인 즉시 실행
- 대시보드에 데이터 품질 상태 표시 (신뢰도 표시)
```

**꼬리 질문**: 지표가 이미 왜곡되어 리포트되었다면?
> "즉시 이해관계자에게 통보하고, 
> 정정된 데이터와 함께 원인 분석 보고서를 제공합니다.
> 장기적으로는 데이터 거버넌스 문서에 복구 프로세스를 명문화합니다."

---

#### Q4. BigQuery 비용 급증 시 최적화 방안

**메인 답변**:
```
비용 최적화 4단계:

1. 쿼리 패턴 분석 (INFORMATION_SCHEMA.JOBS)
   - 가장 비용이 많이 드는 쿼리 식별
   - 반복 실행되는 쿼리 확인

2. 저장소 최적화
   - 파티셔닝/클러스터링 재검토
   - 오래된 데이터는 Coldline Storage로 이동
   - 불필요한 테이블/파티션 삭제

3. 쿼리 최적화
   - SELECT * 대신 필요한 컬럼만
   - LIMIT 대신 WHERE 절 필터링
   - JOIN 시 작은 테이블을 왼쪽에
   - Caching 활용 (동일 쿼리 재실행 방지)

4. 아키텍처 변경
   - Materialized View 도입 (자주 쓰는 집계)
   - BI Engine 사용 (캐싱)
   - Slot reservation 고려 (예측 가능한 비용)
```

**꼬리 질문**: dbt incremental 모델에서 비용을 줄이려면?
> "last_run_timestamp를 저장하고, 
> 변경된 데이터만 처리하는 incremental strategy를 사용합니다.
> MERGE 문을 활용해 UPSERT 처리를 최적화합니다."

---

#### Q5. Airflow DAG 설계 시 Idempotency(멱등성) 보장

**메인 답변**:
```
Idempotency 보장 방법:

1. INSERT OVERWRITE 방식
   - 매 실행마다 타겟 파티션 완전 교체
   - 중복 걱정 없음

2. UPSERT (MERGE) 패턴
   - 기존 데이터와 비교
   - 변경된 행만 UPDATE, 새로운 행은 INSERT

3. 실행 ID 기반 관리
   - dbt의 invocation_id 활용
   - _loaded_at, _loaded_by 컬럼 추가

예시:
```sql
-- Idempotent INSERT
INSERT OVERWRITE TABLE fact_transactions
PARTITION(transaction_date)
SELECT * FROM staging_transactions
WHERE transaction_date = '{{ ds }}';
```
```

**꼬리 질문**: 동일 시간에 DAG가 두 번 실행되면?
> "Airflow의 concurrency 설정으로 1번만 실행되도록 하고,
> 만약 두 인스턴스가 동시에 실행되더라도 
> INSERT OVERWRITE로 인해 동일한 결과가 생성됩니다."

---

### 📋 [비즈니스/지표 질문]

---

#### Q6. "동네 연결"이 잘 되고 있는지 측정할 수 있는 지표는?

**메인 답변**:
```
동네 연결 지표 (KPI Tree):

[L1: 핵심 목표]
└── 지역 기반 거래/활동 활성도

[L2: 측정 지표]
├── 동네별 거래 밀도 (거래 건수 / 사용자 수)
├── 동네별 응답률 (채팅 응답률, 댓글 반응률)
├── 동네 커뮤니티 참여도 (동네생활 게시글/댓글 수)
└── 재거래율 (같은 지역 내 반복 거래 비율)

[L3: 세부 지표]
├── 평균 거래 완료 시간
├── 동네 이웃 친구 수 (네트워크 효과)
└── 오프라인 만족도 (리뷰, 매너온도)
```

**꼬리 질문**: 동네별로 차이가 클 텐데 어떻게 비교하나요?
> "인구 밀도, 상권 활성도를 고려한 정규화가 필요합니다.
> 예: (거래 건수 / 동네 인구) 또는 (거래 건수 / 상점 수) 등의 상대적 지표 사용."

---

#### Q7. 매너온도를 더 신뢰할 수 있게 만들기 위한 데이터

**메인 답변**:
```
매너온도 개선을 위한 추가 데이터:

1. 거래 완료 데이터
   - 실제 거래 완료 여부 (채팅만 하고 무산된 거래 vs 실제 거래)
   - 거래 소요 시간 (빠른 응답 = 높은 매너)

2. 상대적 평가 데이터
   - 거래 상대방의 평가 (양방향)
   - 평가자의 신뢰도 가중치 (악의적 평가 필터링)

3. 행동 패턴 데이터
   - 노쇼(no-show) 비율
   - 가격 흥정 패턴 (정당한 흥정 vs 무리한 요구)
   - 분쟁 발생률 및 해결 방식

4. 시간 가중치
   - 최근 거래에 더 높은 가중치
   - 오래된 평가는 점진적 감소
```

**꼬리 질문**: 가짜 거래/리뷰를 어떻게 탐지하나요?
> "이상 탐지 모델을 활용합니다:
> - 동일 IP/디바이스에서의 반복 평가
> - 평가 패턴의 시간적 집중도
> - 평가 내용의 텍스트 유사도 분석
> - 거래 없이 평가만 있는 경우"

---

### 📋 [컬처핏/경험 질문]

---

#### Q8. 분석가가 기술적으로 불가능한 데이터 추출을 요청할 때

**메인 답변**:
```
3단계 접근법:

1단계: 요청 의도 파악
- "어떤 비즈니스 문제를 해결하려고 하나요?"
- 실제 필요한 인사이트가 무엇인지 이해

2단계: 대안 제시
- "이 방식은 6시간이 걸리는데, 이렇게 바꾸면 10분에 가능합니다"
- 근사치(approximation)로 충분한지 확인
- 샘플링으로 먼저 탐색 가능한지 제안

3단계: 장기적 해결책
- 반복되는 요청이라면 데이터 마트 구축 제안
- 셀프서비스 대시보드 제공
```

**꼬리 질문**: PO가 "지금 당장 필요하다"고 할 때?
> "緊急한 비즈니스 임팩트가 있는지 확인하고,
> 정말 급하다면 샘플링으로 1시간 내 제공 후,
> 정확한 값은 별도로 추출한다고 협의합니다.
> 장기적으로는 이런 긴급 요청이 줄어들도록 데이터 접근성을 개선합니다."

---

#### Q9. 기술적으로 완벽하지만 비즈니스 의미 없는 프로젝트

**메인 답변**:
```
대응 방식:

1. 먼저 프로젝트의 비즈니스 가치 재검토
   - "이 데이터를 누가, 어떤 결정에 사용하나요?"
   - 사용되지 않는다면 과감히 중단 제안

2. 작은 단위로 쪼개서 가치 검증
   - MVP 형태로 핵심 인사이트만 먼저 제공
   - 피드백 받고 확장 여부 결정

3. DAE의 역할 확대
   - 단순 데이터 제공을 넘어, 인사이트 도출 참여
   - "제가 보기에는 이런 패턴이 있는데, 이건 어떠세요?"
```

**꼬리 질문**: 이미 진행 중인데 중단 요청이 오면?
> "지금까지의 산출물(코드, 문서)을 정리해 자산화하고,
> 중단 사유를 명확히 기록합니다.
> 다음부터는 초기에 비즈니스 목표를 더 명확히 설정하도록 프로세스 개선을 제안합니다."

---

#### Q10. 왜 당근인가?

**메인 답변 가이드**:
```
[핵심 포인트: 동네 생활 플랫폼에 대한 애정 + 데이터로 개선하겠다는 의지]

"저는 당근이 '동네'라는 오프라인 관계를 온라인으로 연결하는 
플랫폼이라고 생각합니다.

제가 살고 있는 [본인 동네]에서 실제로 당근으로 [구체적 경험],
이런 경험을 하면서 '이 기능 뒤에는 어떤 데이터가 있을까?' 궁금했습니다.

DAE로서 당근알바의 매칭 효율을 높이거나,
비즈프로필의 로컬 광고 효과를 최적화하는 데이터 인프라를 
만들고 싶습니다.

특히 dbt를 활용한 데이터 모델링과 BigQuery 최적화 경험이 있어,
당근의 데이터 환경 개선에 기여할 수 있을 것이라 확신합니다."
```

**꼬리 질문**: 당근의 어떤 데이터 프로젝트에 참여하고 싶나요?
> "당근알바의 구인 성공률 예측 모델 구축에 참여하고 싶습니다.
> 제공된 자료에서 5,000만 지원이 있었다고 했는데,
> 어떤 공고가 채용까지 연결되는지 데이터로 파악하면
> 구직자와 구인자 모두의 경험을 개선할 수 있을 것 같습니다."

---

## 4. 핵심 체크리스트 (내일 면접 전 확인)

### ✅ 기술 준비
- [ ] Star Schema vs Snowflake Schema 차이점 암기
- [ ] BigQuery 파티셔닝/클러스터링 설명 준비
- [ ] dbt incremental model 개념 확인
- [ ] Airflow Idempotency 예시 준비

### ✅ 비즈니스 준비
- [ ] 하이퍼로컬 광고 개념 설명 가능
- [ ] 당근 수익 모델 (광고 99.7%) 설명
- [ ] MAU 정체 vs DAU/사용시간 성장 의미 설명
- [ ] 경쟁사(번개장터, 중고나라)와의 차이점

### ✅ 컬처핏 준비
- [ ] 당근 앱 오늘 한 번 열어보기
- [ ] 동네생활/알바/비즈프로필 화면 확인
- [ ] "왜 당근인가" 답변 1분 분량으로 준비
- [ ] 질문할 내용 2-3개 준비 (조직문화, 데이터 아키텍처 등)

### ✅ 실전 팁
- **비즈니스 임팩트 강조**: "이 데이터 모델링을 통해 X 지표를 Y% 개선했습니다"
- **dbt 언급**: dbt 경험 있다면 적극 어필 (당근에서 적극 사용)
- **질문하기**: 면접 마지막에 "데이터 조직의 올해 목표는 무엇인가요?" 등 질문

---

## 화이팅하세요! 🥕 당근!
