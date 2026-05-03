# 당근마켓 DAE 면접 준비 자료

## 1. 지표 심층 분석 및 인사이트

### 사용자 지표 분석 (2025년 3월 기준)

| 지표 | 수치 | 성장률 | 인사이트 |
|------|------|--------|----------|
| 누적 가입자 | 4,300만 명 | - | 국민 1/3 이상 가입 |
| MAU | 2,000만 명 | 정체 | 시장 포화 단계 진입 |
| WAU | 1,400만 명 | - | 주간 리텐션 70% (높은 충성도) |
| DAU 성장 | - | 2022 +6.4%, 2023 +9.7% | MAU 정체 속 DAU 성장 = 고착도 상승 |
| 앱 사용 시간 | - | 2023 +12.7%, 2024 +13.2% | 광고 매출 직결 지표 |

**핵심 인사이트**: 
- MAU 정체와 DAU/사용시간 성장의 역학 관계
- 방어적 성장(Defensive Growth): 새 사용자 유입 대신 기존 사용자 사용 빈도/시간 증대
- 광고 비즈니스 최적화: 앱 사용 시간 증가 -> 광고 인벤토리 확대 -> 수익 상승

### 재무 지표 분석

```
매출 성장률:
2020->2021: +117%
2021->2022: +94%  
2022->2023: +156% (흑자전환)
2023->2024: +48%
2024->2025: +43%
```

**연결/별도 기준 차이 분석**:
| 기준 | 매출 | 영업이익 | 영업이익률 |
|------|------|----------|-----------|
| 연결 | 2,707억 | 146억 | 5.4% |
| 별도 | 2,690억 | 671억 | 24.9% |

- 본업은 25% 영업이익률로 매우 건강
- 자회사 투자가 중장기 성장을 위한 전략적 투자

### 광고 비즈니스 분석

| 지표 | 성장률 | 의미 |
|------|--------|------|
| 광고주 수 | +37% | 시장 확대 |
| 집행 광고 수 | +52% | 기존 광고주의 투자 확대 |
| 광고 매출 | +48% | 수익 모델 검증 완료 |

집행 광고 수 > 광고주 수 성장:
- 기존 광고주들이 ROAS(광고 투자 수익률)를 경험하고 예산 확대
- 향후 광고 단가 상승 가능성

## 2. 예상 면접 질문 및 답변

### Q1. 당근마켓 데이터 조직의 핵심 문제는?

**답변 프레임**:
1단계: 현재 상황 인식 - "MAU 정체 속 DAU/사용시간 성장 중인 성숙기 플랫폼"
2단계: 핵심 문제 - "매일 쓰는 앱 전환과 신규 수익 모델 발굴"
3단계: 데이터 역할 - 생활밀착형 서비스 퍼널 최적화, 광고 효율과 UX 균형, 거래 매칭 품질 개선

### Q2. 번개장터 에스크로 전환 성공이 주는 시사점?

**답변**:
- 안전성이 중고거래 사용자의 핵심 니즈
- 고가 상품 거래 시 사용자 이탈 분석 필요
- 안전결제 도입 시 수수료 모델 시뮬레이션

### Q3. 광고 매출 99.7% 의존을 다각화하려면?

**3가지 분석 방향**:
1. 당근알바 수수료 모델 검증 (5,000만 지원 중 유료 전환 가능 구인 분석)
2. 비즈프로필 구독 모델 검증 (265만 개 중 유료 전환 가능성 분석)
3. 중고거래 프리미엄 서비스 수요 분석

## 3. 비즈니스 모델 분석

### 당근 vs 경쟁사 전략 비교

| 항목 | 당근마켓 | 번개장터 | 중고나라 |
|------|----------|----------|----------|
| MAU | 2,000만 | 680만 | 비공개 |
| 수익 모델 | 광고 99.7% | 수수료(3.5%) | 수수료 중심 |
| 영업이익 | 흑자 | 적자 지속 | 적자 지속 |

**당근의 광고 중심 모델 장점**:
- 거래 수수료 없이 사용자 유입 장벽 낮음
- 사용자 증가 -> 광고 가치 상승 -> 흑자 구조
- 로컬 광고 시장 디지털 전환 수혜

## 4. 코딩 면접 준비

### SQL 예상 문제

**문제 1: 월별 DAU 추이 분석**
```sql
SELECT 
    DATE_TRUNC('month', event_date) as month,
    COUNT(DISTINCT user_id) as dau,
    LAG(COUNT(DISTINCT user_id)) OVER (ORDER BY DATE_TRUNC('month', event_date)) as prev_month_dau,
    ROUND(
        (COUNT(DISTINCT user_id) - LAG(COUNT(DISTINCT user_id)) OVER (ORDER BY DATE_TRUNC('month', event_date))) 
        / LAG(COUNT(DISTINCT user_id)) OVER (ORDER BY DATE_TRUNC('month', event_date)) * 100, 
        2
    ) as growth_rate_pct
FROM user_sessions
WHERE event_date >= '2023-01-01'
GROUP BY 1
ORDER BY 1;
```

**문제 2: 광고주별 ROAS 분석**
```sql
SELECT 
    advertiser_id,
    SUM(ad_spend) as total_spend,
    SUM(attributed_revenue) as total_revenue,
    ROUND(SUM(attributed_revenue) / NULLIF(SUM(ad_spend), 0), 2) as roas,
    CASE 
        WHEN SUM(attributed_revenue) / NULLIF(SUM(ad_spend), 0) >= 3 THEN 'High Performer'
        WHEN SUM(attributed_revenue) / NULLIF(SUM(ad_spend), 0) >= 1 THEN 'Profitable'
        ELSE 'Needs Optimization'
    END as performance_tier
FROM ad_performance
WHERE date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY 1
ORDER BY roas DESC;
```

**문제 3: 당근알바 지원 전환율 분석**
```sql
WITH application_funnel AS (
    SELECT 
        job_id,
        COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_id END) as viewers,
        COUNT(DISTINCT CASE WHEN event_type = 'apply' THEN user_id END) as applicants,
        COUNT(DISTINCT CASE WHEN event_type = 'interview' THEN user_id END) as interviewees,
        COUNT(DISTINCT CASE WHEN event_type = 'hired' THEN user_id END) as hires
    FROM danggeun_alba_events
    WHERE created_at >= CURRENT_DATE - INTERVAL '90 days'
    GROUP BY 1
)
SELECT 
    job_category,
    AVG(viewers) as avg_viewers,
    ROUND(AVG(applicants::float / NULLIF(viewers, 0)) * 100, 2) as view_to_apply_rate,
    ROUND(AVG(interviewees::float / NULLIF(applicants, 0)) * 100, 2) as apply_to_interview_rate,
    ROUND(AVG(hires::float / NULLIF(interviewees, 0)) * 100, 2) as interview_to_hire_rate
FROM application_funnel
GROUP BY 1
ORDER BY view_to_apply_rate DESC;
```

### Python 예상 문제

**문제 1: A/B 테스트 결과 분석**
```python
import pandas as pd
import numpy as np
from scipy import stats

def analyze_ab_test(control_data, treatment_data, metric='conversion_rate'):
    """
    A/B 테스트 결과 분석 함수
    
    Parameters:
    - control_data: 대조군 데이터 (array-like)
    - treatment_data: 실험군 데이터 (array-like)
    - metric: 분석할 지표
    
    Returns:
    - 통계적 유의성 결과 및 효과 크기
    """
    # 평균과 표준편차 계산
    control_mean = np.mean(control_data)
    treatment_mean = np.mean(treatment_data)
    control_std = np.std(control_data, ddof=1)
    treatment_std = np.std(treatment_data, ddof=1)
    
    n_control = len(control_data)
    n_treatment = len(treatment_data)
    
    # t-test 수행 (독립 표본 t-test)
    t_stat, p_value = stats.ttest_ind(control_data, treatment_data)
    
    # 효과 크기 (Cohen's d)
    pooled_std = np.sqrt(((n_control - 1) * control_std**2 + 
                         (n_treatment - 1) * treatment_std**2) / 
                        (n_control + n_treatment - 2))
    cohens_d = (treatment_mean - control_mean) / pooled_std
    
    # 상대적 개선율
    relative_uplift = (treatment_mean - control_mean) / control_mean * 100
    
    return {
        'control_mean': control_mean,
        'treatment_mean': treatment_mean,
        'relative_uplift_pct': relative_uplift,
        'p_value': p_value,
        'is_significant': p_value < 0.05,
        'cohens_d': cohens_d,
        't_statistic': t_stat
    }

# 사용 예시
control_conversion = np.random.binomial(1, 0.15, 10000)
treatment_conversion = np.random.binomial(1, 0.17, 10000)

result = analyze_ab_test(control_conversion, treatment_conversion)
print(f"개선율: {result['relative_uplift_pct']:.2f}%")
print(f"p-value: {result['p_value']:.4f}")
print(f"통계적 유의성: {'있음' if result['is_significant'] else '없음'}")
```

**문제 2: 코호트 리텐션 분석**
```python
def calculate_cohort_retention(df, user_col='user_id', date_col='event_date', period='month'):
    """
    코호트 리텐션 테이블 생성
    
    Parameters:
    - df: 이벤트 데이터 (DataFrame)
    - user_col: 사용자 ID 컬럼
    - date_col: 날짜 컬럼
    - period: 집계 단위 ('day', 'week', 'month')
    
    Returns:
    - 코호트 리텐션 테이블 (DataFrame)
    """
    # 첫 방문 날짜 계산 (코호트 기준)
    first_visit = df.groupby(user_col)[date_col].min().reset_index()
    first_visit.columns = [user_col, 'cohort_date']
    
    # 데이터에 코호트 기준 병합
    df = df.merge(first_visit, on=user_col)
    
    # 기간별 날짜 계산
    if period == 'month':
        df['cohort_month'] = df['cohort_date'].dt.to_period('M')
        df['event_month'] = df[date_col].dt.to_period('M')
        df['period_number'] = (df['event_month'] - df['cohort_month']).apply(attrgetter('n'))
    
    # 코호트 테이블 생성
    cohort_data = df.groupby(['cohort_month', 'period_number'])[user_col].nunique().reset_index()
    
    # 피벗 테이블 생성
    cohort_table = cohort_data.pivot(index='cohort_month', 
                                     columns='period_number', 
                                     values=user_col)
    
    # 리텐션 비율 계산 (첫 기준 대비)
    cohort_sizes = cohort_table.iloc[:, 0]
    retention_table = cohort_table.divide(cohort_sizes, axis=0)
    
    return retention_table

# 사용 예시 (당근마켓 가입자 리텐션 분석)
# retention = calculate_cohort_retention(user_events, period='month')
# print(retention.head())
```

## 5. 면접 Tips

### AARRR 프레임워크 활용
- Acquisition: MAU 정체 상황, 신규 유입 채널 포화
- Activation: WAU/MAU 비율 70%, 가입자의 대부분이 주간 활성
- Retention: DAU 성장, 앱 사용시간 증가로 고착도 상승
- Revenue: 광고 매출 48% 성장, 사용시간 증가가 수익으로 연결
- Referral: 4,300만 가입자로 입소문 효과 포화

### 핵심 키워드
- "방어적 성장" (Defensive Growth)
- "생활밀착형 서비스" (당근알바, 모임, 커뮤니티)
- "로컬 광고" (비즈프로필 중심)
- "MAU 정체 속 DAU/사용시간 성장"
- "광고 99.7% vs 수수료 모델"

### 질문할 준비
- 데이터 조직의 현재 구조와 역할 분담
- A/B 테스트 인프라 및 의사결정 프로세스
- 실시간 데이터 파이프라인 구성
- ML 모델 활용 사례 (추천, 광고 최적화 등)

## 화이팅하세요! 🥕
