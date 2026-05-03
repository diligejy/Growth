# 당근 DAE 면접 준비 - 완전 통합 가이드

> 송진영 님 전용 - 이력서 기반 맞춤형 면접 준비 자료

---

## 📚 문서 구조 (어디서 뭘 찾아야 하나요?)

| 필요한 것 | 문서 위치 | 용도 |
|----------|----------|------|
| **10분 완성** | `THE_ONE_PAGE.md` | 핵심만 쏙쏙 |
| **30분 완성** | 이 문서 (Section 1-3) | 핵심 질문 + 답변 |
| **1시간 완성** | 이 문서 전체 + `docs/questions/` | 심층 준비 |
| **당일 아침 복습** | Section 6 체크리스트 | 최종 점검 |
| **이력서 기반 질문** | `docs/personalized/jinyoung-song-prep.md` | 맞춤형 답변 |
| **코딩 테스트** | `docs/exec-plans/coding-test-guide.md` | Coderpad 대비 |

---

# SECTION 1: 당근 이해하기 (15분 분량)

## 1.1 당근 현황 (2025년 기준)

### 핵심 지표
| 지표 | 수치 | 의미 |
|------|------|------|
| 누적 가입자 | 4,300만 | 국민 1/3 가입 |
| MAU | 2,000만 | 정체 (성숙기) |
| DAU 성장 | 2023년 +9.7% | "매일 쓰는 앱" 전환 성공 |
| 앱 사용시간 | 2024년 +13.2% | 광고 매출 직결 |
| 광고 매출 | 1,891억 (2024) | 전체의 99.7% |
| 영업이익 | 376억 (2024) | 흑자 전환 유지 |

### 데이터적 인사이트
```
MAU 정체 + DAU/사용시간 성장 = 방어적 성장(Defensive Growth)
- 새 사용자 유입 대신 기존 사용자 사용 빈도/시간 증대
- 앱 사용시간 증가 → 광고 인벤토리 확대 → 수익 상승
```

## 1.2 수익 모델

| BM | 비중 | 데이터 역할 |
|----|------|-------------|
| **하이퍼로컬 광고** | 99.7% | 지역/관심사 타겟팅 정교화 |
| **비즈프로필** | 성장 중 | 커머스 데이터 (예약, 결제, 단골) |
| **버티컬 서비스** | 확장 중 | 알바/부동산/중고차 매칭 알고리즘 |

## 1.3 데이터 가치화 팀 비전

> **"매일 데이터를 통해 사용자를 위한 의사결정을 한다"**

### 팀 구성 (2022년 기준)
| 역할 | 담당 | 핵심 활동 |
|------|------|-----------|
| 데이터 분석가 | 매튜, 띠오, 샘 | 실험 플랫폼, 분석 지원 |
| 소프트웨어 엔지니어 | 이안, 램버트 | 기술적 문제 해결 |
| 데이터 엔지니어 | 루크 | Beam Pipeline |
| 데이터 인프라 | 헨리 | **실험플랫폼, 이벤트 로깅, 데이터 파이프라인** |

---

# SECTION 2: 이력서 기반 핵심 질문 5선 (30분 분량)

## Q1. Factory DAG + Jinja2 템플릿 → dbt 적용

### 면접관 질문
"33개 물류센터 통합 경험이 있는데, 당근의 다양한 서비스(중고/알바/비즈) 데이터도 통합해야 한다면 어떻게 접근하시겠어요?"

### 완벽한 답변 구조
```
1단계: 문제 인식 (10초)
"당근도 Coupang CLS와 유사하게 서비스별로 다른 스키마를 가지고 있을 것 같습니다."

2단계: 해결책 제시 (30초)
"Coupang에서 33개 센터를 통합할 때 Factory DAG 패턴과 Jinja2 템플릿을 활용했습니다.
- 공통 로직은 부모 클래스로, 서비스 특화 로직은 오버라이드
- Jinja2로 SQL 템플릿화하여 스키마 차이 추상화
- 결과: 온보딩 시간 2주 → 2시간 단축"

3단계: 당근 적용 (20초)
"당근에서도 dbt의 macro와 source() 함수를 활용하여
중고거래/당근알바/비즈프로필별로 동일한 Factory 패턴을 적용할 수 있습니다.
새로운 서비스가 추가되어도 템플릿 파라미터만 추가하면 됩니다."
```

### 꼬리질문 대비
**Q**: dbt를 써본 적 있나요? → Jinja2 템플릿 경험이 있어 빠르게 적응 가능
**Q**: 스키마가 완전히 다르면? → 공통 필드 식별 후 나머지는 dynamic 처리

---

## Q2. DQC 51 + pytest 153 → dbt tests

### 면접관 질문
"데이터 품질 관리를 어떻게 하시나요?"

### 완벽한 답변 구조
```
1단계: 이중 품질 체계 설명 (30초)
"2단계 방어선으로 구축했습니다.

1단계: Presto 기반 DQC (51개 규칙)
- SQL 기반 데이터 품질 체크
- not_null, uniqueness, range check 등
- 실제로 140만 행 누락 버그를 사전 탐지

2단계: pytest 기반 파이프라인 테스트 (153개 테스트)
- Python 코드 레벨 검증
- DAG 의존성 테스트, 스키마 변경 감지"

2단계: 당근 적용 (20초)
"당근에서도 dbt tests로 비즈니스 로직 품질을,
Airflow SLA 모니터링으로 파이프라인 품질을 관리할 수 있습니다.
Metric Catalog와 연동하여 지표 품질도 실시간 모니터링 가능합니다."
```

### 꼬리질문 대비
**Q**: dbt tests가 느리면? → 샘플링 테스트, 증분 테스트, 우선순위 분류
**Q**: 테스트 실패 시? → is_partial_data 플래그, 백필 프로세스

---

## Q3. 3년 미해결 타임스탬프 이슈 해결

### 면접관 질문
"6개 팀 간 데이터 불일치 문제를 해결한 구체적 경험을 들려주세요."

### 완벽한 답변 구조
```
1단계: 문제 상황 (15초)
"6개 팀의 데이터가 연동되지 않아 3년간 지표 불일치가 있었습니다."

2단계: 근본 원인 분석 (30초)
"타임스탬프 분석으로 원인을 규명했습니다.
- 팀 A: KST 기준, 팀 B: UTC 기준
- 일부는 millisecond, 일부는 second 정밀도
- DST(일광절약시간) 처리 방식도 상이

unix_timestamp 변환 후 차이 분석하니
불일치 패턴이 특정 시간대에 집중되는 것을 확인"

3단계: 해결책 (20초)
"전사 표준 정의: UTC + millisecond + ISO 8601
기존 데이터는 배치 보정 파이프라인 구축
신규 데이터는 SDK에 강제 표준 적용
결과: 3년간 누적된 2% 데이터 불일치 해결"

4단계: 당근 적용 (10초)
"당근도 동네 기반으로 시간대 처리가 중요합니다.
dbt에서 timezone conversion macro를 준비하면
향후 글로벌 확장 시에도 유연하게 대응 가능합니다."
```

---

## Q4. Metric Catalog → 데이터 거버넌스

### 면접관 질문
"전사 지표를 어떻게 관리하셨나요?"

### 완벽한 답변 구조
```
"Metric Catalog 기반으로 전사 지표 거버넌스를 구축했습니다.

1. 지표 정의 통일
- 6개 팀의 다른 산출 로직을 표준화
- 단일 Source of Truth 구축

2. 데이터 신뢰성 확보
- Observability 대시보드 구축
- 지표 변화 추이 모니터링
- 이상치 자동 감지

3. 셀프서비스 환경
- 분석가들이 직접 지표 정의 확인 가능
- 지표 계보(Lineage) 제공

당근의 '매일 데이터를 통한 의사결정' 비전과 완벽히 부합하는 경험입니다."
```

---

## Q5. 왜 당근인가? (컬처핏)

### 완벽한 답변 (1분 분량)
```
"3가지 이유에서 지원했습니다.

첫째, 비전에 공감합니다.
'매일 데이터를 통해 사용자를 위한 의사결정을 한다'는
당근 데이터 가치화 팀의 비전에 깊이 공감합니다.
Coupang에서 33개 센터 데이터를 통합하며 '데이터가 쌓이는 것을 넘어
인사이트를 얻는 것'의 중요성을 깨달았고,
Big Insight에서 셀프서비스 환경을 만들며 '분석가들이 뛰어놀 수 있는 환경'의
가치를 체감했습니다.

둘째, 기여할 수 있는 부분이 명확합니다.
Factory DAG 패턴으로 33개 센터를 통합한 경험과,
DQC 51 + pytest 153으로 구축한 이중 품질 체계,
Metric Catalog로 운영한 데이터 거버넌스 경험은
당근 DAE의 핵심 요구사항과 완벽하게 맞닿아 있습니다.

셋째, 성장하고 싶습니다.
dbt와 Airflow를 더 깊이 활용하여
당근의 다양한 서비스 데이터를 통합하고,
분석가들이 신뢰할 수 있는 데이터 환경을 만드는 데 기여하고 싶습니다.
'dbt 도입하며 마주한 7가지 문제들' 글을 읽고
당근 데이터 팀의 문제 해결 방식에 큰 인상을 받았습니다."
```

### 꼬리질문 대비
**Q**: 어떤 프로젝트에 참여하고 싶나요?
> "당근알바의 구인 성공률 예측 모델, 비즈프로필 광고 ROAS 최적화, 
> 매너온도 개선 등 데이터로 사용자 경험을 개선하는 프로젝트"

---

# SECTION 3: Coderpad 코딩 테스트 완벽 대비 (20분 분량)

## 3.1 테스트 환경

| 항목 | 내용 | 준비 |
|------|------|------|
| **플랫폼** | Coderpad | [sandbox](https://app.coderpad.io/sandbox)에서 연습 완료 |
| **언어** | SQL, Python | 둘 다 준비 |
| **유형** | 데이터 집계/처리 (복잡한 알고리즘 X) | Factory DAG 관련 예상 |
| **시간** | 약 30분 | 문제 2-3개 |

## 3.2 예상 문제 1: Factory DAG 패턴 (Python)

**문제**: 당근의 3개 서비스(중고거래, 당근알바, 비즈프로필)용 ETL DAG를 Factory 패턴으로 생성하세요.

**제시될 설정**:
```python
SERVICE_CONFIGS = [
    {'name': 'karrot_used', 'schedule': '0 3 * * *', 'table': 'used_transactions'},
    {'name': 'karrot_alba', 'schedule': '0 4 * * *', 'table': 'alba_applications'},
    {'name': 'karrot_biz', 'schedule': '0 5 * * *', 'table': 'biz_profiles'},
]
```

**정답 코드**:
```python
def create_dag(config):
    """
    서비스별 ETL DAG 생성 함수
    """
    dag_id = f"etl_{config['name']}"
    
    # DAG 정의 (의사코드 수준으로도 충분)
    dag = {
        'dag_id': dag_id,
        'schedule': config['schedule'],
        'tasks': [
            {'name': 'extract', 'query': f"SELECT * FROM {config['table']}"},
            {'name': 'transform', 'logic': 'cleanse_and_enrich'},
            {'name': 'load', 'destination': 'warehouse'}
        ]
    }
    
    return dag

# 모든 서비스용 DAG 생성
dags = [create_dag(cfg) for cfg in SERVICE_CONFIGS]

# 결과 확인
for dag in dags:
    print(f"Created DAG: {dag['dag_id']} with schedule {dag['schedule']}")
```

**면접관이 보는 포인트**:
- 함수 분리 (단일 책임)
- 리스트 컴프리헨션 활용
- 설정 기반 접근 (하드코딩 X)

## 3.3 예상 문제 2: SQL 데이터 품질 체크

**문제**: `daily_active_users` 테이블에 대해 다음 품질 체크 쿼리를 작성하세요:
1. NULL 값 체크
2. 중복 행 체크  
3. DAU가 전일 대비 50% 이상 변동한 날짜 찾기

**정답 코드**:
```sql
-- 1. NULL 체크
SELECT 'null_check' as test_name,
       COUNT(*) as null_count
FROM daily_active_users
WHERE user_id IS NULL OR date IS NULL;

-- 2. 중복 체크
SELECT 'duplicate_check' as test_name,
       COUNT(*) - COUNT(DISTINCT user_id || date) as duplicate_count
FROM daily_active_users;

-- 3. 변동율 체크 (윈도우 함수 활용)
WITH daily_stats AS (
    SELECT 
        date,
        dau,
        LAG(dau) OVER (ORDER BY date) as prev_dau
    FROM daily_active_users
)
SELECT 
    date,
    dau,
    prev_dau,
    ABS(dau - prev_dau) / prev_dau * 100 as change_pct
FROM daily_stats
WHERE ABS(dau - prev_dau) / prev_dau > 0.5;
```

**면접관이 보는 포인트**:
- 윈도우 함수 (LAG) 활용
- CTE로 가독성 확보
- 실제 데이터 품질 문제 해결 경험 연결

## 3.4 예상 문제 3: pandas 데이터 처리

**문제**: 사용자 이벤트 데이터에서 일별/서비스별 DAU를 집계하세요.

**정답 코드**:
```python
import pandas as pd

# 데이터 로드 (가정)
# df 컬럼: user_id, event_time, service_type

# 1. datetime 변환
df['event_time'] = pd.to_datetime(df['event_time'])
df['date'] = df['event_time'].dt.date

# 2. 일별/서비스별 DAU 집계
daily_dau = df.groupby(['date', 'service_type'])['user_id'].nunique().reset_index()
daily_dau.columns = ['date', 'service', 'dau']

# 3. 피벗 (서비스별 컬럼)
pivot_dau = daily_dau.pivot(index='date', columns='service', values='dau').reset_index()

print(daily_dau)
print(pivot_dau)
```

---

# SECTION 4: 기술-경험 매핑 표 (참고용)

| 당근 요구사항 | 이력서 경력 | 답변 시 강조 |
|---------------|-------------|--------------|
| **dbt** | Jinja2 템플릿 | "macro 학습 빠름, Factory 패턴 유사" |
| **Airflow** | Factory DAG | "33개 센터 DAG 자동화, 확장성 증명" |
| **BigQuery** | Redshift, Presto | "ANSI SQL 호환, 파티셔닝/클러스터링 이해" |
| **데이터 거버넌스** | Metric Catalog | "전사 지표 정의/관리 실제 경험" |
| **A/B 테스트** | 이벤트 택소노미 | "AARRR 설계, 실험 인프라 이해" |
| **품질 관리** | DQC 51 + pytest 153 | "이중 품질 체계, 140만 행 누락 탐지" |

---

# SECTION 5: 꼬리질문 모음 (추가 대비)

## 기술 꼬리질문

**Q**: dbt를 안 써봤는데 어떻게 하시겠어요?
> "Jinja2 템플릿 경험이 있어 빠르게 적응 가능. Factory DAG 패턴과 유사"

**Q**: BigQuery 비용 최적화 경험 있나요?
> "Redshift에서 파티셔닝/스캔 최소화 경험. BigQuery도 partition pruning 동일"

**Q**: Airflow DAG 동시 실행 문제는?
> "max_active_runs=1 설정 + Idempotent 로직으로 해결"

## 비즈니스 꼬리질문

**Q**: 당근의 MAU 정체가 문제 아닌가요?
> "의도적인 '방어적 성장'. DAU/사용시간 증가가 광고 매출로 연결"

**Q**: 매너온도 어떻게 개선하시겠어요?
> "양방향 평가 + 시간 가중치 + 가짜 리뷰 탐지 모델"

---

# SECTION 6: 면접 당일 체크리스트

## 입장 전 (5분 전)
- [ ] 링크 접속 확인
- [ ] Coderpad 연결 확인
- [ ] 마이크/카메라 테스트
- [ ] 화면공유 권한 확인
- [ ] 음료 준비

## 코딩 테스트 중
- [ ] 문제 충분히 읽기
- [ ] "이렇게 접근하겠습니다"라고 말하기
- [ ] 단계별로 진행
- [ ] 궁금한 점은 바로 질문
- [ ] 실행해서 결과 확인

## 직무/컬처핏 인터뷰
- [ ] Factory DAG → dbt 연결 언급
- [ ] DQC 51 → dbt tests 연결 언급
- [ ] Metric Catalog → 데이터 거버넌스 언급
- [ ] PyTorch 기여 → 공유 문화 연결
- [ ] "왜 당근인가" 외워서 자연스럽게

---

# SECTION 7: 면접관 역할 - 모의 면접 시작

이제 저는 당근 DAE 면접관입니다.

## 모드 선택

| 번호 | 모드 | 시간 | 내용 |
|------|------|------|------|
| **1** | 코딩 테스트 | 20분 | Coderpad 문제 2개 풀기 |
| **2** | 기술 인터뷰 | 25분 | Q1-Q3 심층 질문 |
| **3** | 비즈니스 인터뷰 | 15분 | Q4 + 당근 지표 질문 |
| **4** | 컬처핏 인터뷰 | 10분 | Q5 + 협업 질문 |
| **5** | 풀 인터뷰 | 40분 | 모든 단계 순차 진행 |

**원하시는 모드 번호를 알려주세요.**

---

# APPENDIX: 모든 문서 링크

| 문서 | 경로 | 용도 |
|------|------|------|
| 통합 요약본 | `THE_ONE_PAGE.md` | 10분 훑기용 |
| 이 문서 | `COMPLETE_GUIDE.md` | 30분-1시간 심층용 |
| 이력서 기반 질문 | `docs/personalized/jinyoung-song-prep.md` | 맞춤형 답변 상세 |
| 코딩 테스트 | `docs/exec-plans/coding-test-guide.md` | Coderpad 연습 |
| 핵심 10선 | `docs/questions/key-questions.md` | 질문 리스트 |
| 기술 질문 상세 | `docs/questions/technical/*.md` | SQL/모델링 상세 |
| 비즈니스 질문 | `docs/questions/business/*.md` | 지표/전략 상세 |
| 컬처핏 질문 | `docs/questions/culture/*.md` | 협업/문화 상세 |

---

**면접 준비 완료. 화이팅! 🥕**
