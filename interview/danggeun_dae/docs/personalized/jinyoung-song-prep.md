# 송진영 님 맞춤형 면접 준비

> Coupang CLS + Big Insight 경력 기반 당근 DAE 면접 대비

---

## 이력서 핵심 포인트 요약

| 구분 | 핵심 강점 | 당근 DAE 연결 |
|------|-----------|---------------|
| **경력** | 3년 7개월 (CLS, Big Insight) | DAE 요구사항 충족 |
| **데이터 마트** | 33개 센터 통합, Factory DAG | 전사 데이터 마트 설계 경험 |
| **품질 관리** | DQC 51규칙 + pytest 153테스트 | 관측성/자동화 품질 체크 |
| **문제 해결** | 3년 미해결 이슈 타임스탬프 분석 해결 | 복잡한 데이터 정합성 문제 해결 능력 |
| **셀프서비스** | Dash + ClickHouse, 요청 90% 감소 | BI/데이터 탐색 환경 구축 |
| **거버넌스** | Metric Catalog 운영 | 전사 지표 정의/관리 경험 |
| **오픈소스** | PyTorch 문서 한글화 | 커뮤니티 지향, 공유 문화 |

---

## 맞춤형 면접 질문 & 강력한 답변

### Q1. "33개 물류센터 통합 프로젝트에서 데이터 편향/스키마 불일치를 어떻게 해결했나요?"

**[강력한 답변]**

```
"33개 물류센터마다 스키마가 달랐던 문제를 2가지 전략으로 해결했습니다.

첫째, Jinja2 템플릿 SQL로 유연한 스키마 매핑:
- 센터별로 다른 컬럼명을 공통 템플릿 변수로 추상화
- {% if center_type == 'A' %} column_x {% else %} column_y {% endif %}
- 새로운 센터 온보딩 시 템플릿 파라미터만 추가

둘째, Factory DAG 패턴으로 확장성 확보:
- 하나의 DAG Factory 함수로 33개 센터 DAG 자동 생성
- 공통 로직은 부모 클래스, 센터 특화 로직은 오버라이드
- 결과: 온보딩 시간 2주 → 2시간으로 단축

데이터 편향은 Metric Catalog로 모니터링:
- 센터별 데이터 품질 스코어 대시보드화
- 이상 징상 센터 자동 감지 및 알림"
```

**[꼬리질문 대비]**

Q: 당근에서도 동네별/서비스별로 스키마가 다를 수 있는데?
> "비즈프로필/당근알바/중고거래 각각 다른 스키마를 dbt의 macro로 추상화하고, 
> source() 함수로 동적 연결하여 유사한 Factory 패턴 적용 가능합니다."

---

### Q2. "DQC 51개 규칙과 pytest 153개 테스트로 구축한 이중 품질 체계를 설명해주세요"

**[강력한 답변]**

```
"데이터 품질을 2단계 방어선으로 설계했습니다.

1단계: Presto 기반 DQC (51개 규칙)
- SQL 기반 데이터 품질 체크
- not_null, uniqueness, range check 등
- 140만 행 누락 버그를 사전 탐지한 사례

2단계: pytest 기반 파이프라인 테스트 (153개 테스트)
- Python 코드 레벨 검증
- DAG 의존성 테스트, 스키마 변경 감지
- Airflow 태스크 결과 검증

이중 체계의 이유:
- DQC: 비즈니스 로직 품질 (데이터 정확성)
- pytest: 엔지니어링 품질 (파이프라인 안정성)

당근에서도 dbt tests + Airflow SLA 모니터링으로
유사한 이중 체계를 구축할 수 있습니다."
```

**[꼬리질문 대비]**

Q: dbt tests와 어떻게 통합하나요?
> "dbt의 schema.yml 테스트를 DQC SQL로 변환하는 어댑터를 만들 수 있습니다.
> 예: dbt의 not_null → SELECT count(*) FROM table WHERE col IS NULL = 0"

---

### Q3. "6개 팀 간 3년 미해결 데이터 연동 불일치 문제를 타임스탬프 분석으로 해결한 구체적 방법은?"

**[강력한 답변]**

```
"근본 원인이 타임스탬프 불일치에 있었습니다.

문제 상황:
- 팀 A는 KST 기준, 팀 B는 UTC 기준 로깅
- 일부는 millisecond, 일부는 second 정밀도
- DST(일광절약시간) 처리 방식도 달랐습니다

분석 방법:
1. 6개 팀의 로그에서 타임스탬프 포맷 추출
2. unix_timestamp 변환 후 차이 분석
3. 불일치 패턴이 특정 시간대에 집중되는 것 확인

해결책:
- 전사 표준: UTC + millisecond + ISO 8601
- 기존 데이터: 배치 보정 파이프라인 구축
- 신규 데이터: SDK에 강제 표준 적용

결과: 3년간 누적된 2% 데이터 불일치 해결"
```

**[꼬리질문 대비]**

Q: 당근에서도 시간대 문제가 있을 수 있는데?
> "당근은 동네 기반 서비스라 KST가 기본이지만,
> 글로벌 확장 시 UTC 표준화 필요.
> dbt에서 timezone conversion macro를 미리 준비하는 것이 좋습니다."

---

### Q4. "셀프서비스 분석 도구로 데이터 추청 90% 감소시킨 구체적 방법은?"

**[강력한 답변]**

```
"분석가들이 직접 데이터를 탐색할 수 있는 환경을 만들었습니다.

기술 스택:
- Python Dash: 웹 기반 인터랙티브 대시보드
- ClickHouse: 실시간 집계 엔진
- ELT 파이프라인: Raw → ClickHouse 자동 적재

핵심 기능:
1. 드래그앤드롭 필터링 (SQL 없이)
2. 실시간 피벗 테이블
3. 자주 쓰는 쿼리 저장/공유

성과:
- 단순 추출 요청 90% 감소
- 분석가들이 복잡한 분석에 집중
- 데이터 리터러시 향상

당근에서도:
- dbt + BI Tool (Looker/Tableau)로 유사 환경 구축 가능
- 데이터 거버넌스와 셀프서비스의 균형"
```

**[꼬리질문 대비]**

Q: 셀프서비스와 데이터 거버넌스의 균형은?
> "Metric Catalog로 '신뢰할 수 있는 지표'만 노출하고,
> raw 데이터 접근은 제한하는 티어드 접근 제어입니다."

---

### Q5. "PyTorch 문서 한글화 기여가 당근의 '공유' 문화와 어떻게 연결되나요?"

**[강력한 답변]**

```
"기술적 지식의 민주화에 공감대가 있습니다.

PyTorch 기여:
- 어려운 딥러닝 개념을 한국어로 풀어쓰며
- 더 많은 개발자가 접근할 수 있게 기여

당근 데이터 가치화 팀의 비전:
- '매일 데이터를 통해 사용자를 위한 의사결정을 한다'
- 이를 위해 데이터 분석가들이 '뛰어놀 수 있는 환경' 필요

연결:
- 데이터 거버넌스 문서화 = 지식 공유
- 셀프서비스 환경 = 데이터 접근 민주화
- dbt 모델 문서화 = 분석가들의 생산성 향상

당근의 '공유' 가치와 기술적 지식 공유 경험이 맞닿아 있습니다."
```

---

## 기술 스택 매핑 (당근 DAE 요구사항)

| 당근 요구 | 이력서 경력 | 어필 포인트 |
|-----------|-------------|-------------|
| **dbt** | 관심/유사경험 | Jinja2 템플릿 경험 → dbt macro 학습 빠름 |
| **Airflow** | Factory DAG 패턴 | 33개 센터 DAG 자동화, 확장성 증명 |
| **BigQuery** | Redshift, Presto | ANSI SQL 호환, 파티셔닝/클러스터링 이해 |
| **데이터 거버넌스** | Metric Catalog | 전사 지표 정의/관리 실제 경험 |
| **A/B 테스트** | 이벤트 택소노미 | AARRR 설계, 실험 인프라 이해 |
| **클라우드** | AWS S3 | GCP 빠른 적응 가능 |

---

## "왜 당근인가?" 최종 답변

```
"당근의 '매일 데이터를 통해 사용자를 위한 의사결정을 한다'는 
비전에 깊이 공감합니다.

쿠팡 CLS에서 33개 물류센터의 데이터를 통합하며 
'데이터가 쌓이는 것을 넘어 인사이트를 얻는 것'의 중요성을 깨달았고,

Big Insight에서 셀프서비스 환경을 만들며 
'분석가들이 뛰어놀 수 있는 환경'의 가치를 체감했습니다.

당근 데이터 가치화 팀은 이 두 가지를 모두 추구하는 팀입니다.

특히 dbt와 Airflow를 활용해 데이터 거버넌스와 품질 관리를 
하고 싶습니다. 'dbt 도입하며 마주한 7가지 문제들' 글을 읽고
당근의 문제 해결 방식에 큰 인상을 받았습니다.

Factory DAG 패턴과 Jinja2 템플릿 경험을 바탕으로
당근의 다양한 서비스(중고거래, 알바, 비즈프로필) 데이터를 
통합하고, 분석가들이 신뢰할 수 있는 데이터 환경을 
만드는 데 기여하고 싶습니다."
```

---

## 라이브 코딩 테스트 대비 (이력서 기반 예상)

### 예상 문제 1: Factory DAG 패턴 구현

```python
# 요구: 3개 서비스(중고/알바/비즈)용 DAG를 Factory 패턴으로 생성

from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

SERVICE_CONFIGS = [
    {'name': 'karrot_used', 'schedule': '0 3 * * *'},
    {'name': 'karrot_alba', 'schedule': '0 4 * * *'},
    {'name': 'karrot_biz', 'schedule': '0 5 * * *'},
]

def create_dag(service_config):
    dag_id = f"etl_{service_config['name']}"
    
    with DAG(
        dag_id=dag_id,
        schedule_interval=service_config['schedule'],
        start_date=datetime(2024, 1, 1),
        catchup=False,
    ) as dag:
        
        extract = PythonOperator(
            task_id='extract',
            python_callable=lambda: print(f"Extract {service_config['name']}"),
        )
        
        transform = PythonOperator(
            task_id='transform',
            python_callable=lambda: print(f"Transform {service_config['name']}"),
        )
        
        load = PythonOperator(
            task_id='load',
            python_callable=lambda: print(f"Load {service_config['name']}"),
        )
        
        extract >> transform >> load
    
    return dag

# DAG 자동 생성
globals().update({f"dag_{s['name']}": create_dag(s) for s in SERVICE_CONFIGS})
```

### 예상 문제 2: SQL 데이터 품질 체크

```sql
-- 요구: daily_active_users 테이블의 품질 체크 쿼리

-- 1. not_null 체크
SELECT 'null_check' as test_name,
       COUNT(*) as null_count
FROM daily_active_users
WHERE user_id IS NULL OR date IS NULL;

-- 2. uniqueness 체크
SELECT 'uniqueness_check' as test_name,
       COUNT(*) - COUNT(DISTINCT user_id || date) as duplicate_count
FROM daily_active_users;

-- 3. range 체크 (MAU가 갑자기 50% 변하면 이상)
SELECT 'range_check' as test_name,
       date,
       dau,
       LAG(dau) OVER (ORDER BY date) as prev_dau,
       ABS(dau - LAG(dau) OVER (ORDER BY date)) / LAG(dau) OVER (ORDER BY date) as change_rate
FROM daily_active_users
WHERE ABS(dau - LAG(dau) OVER (ORDER BY date)) / LAG(dau) OVER (ORDER BY date) > 0.5;
```

---

## 최종 체크리스트

### 기술
- [x] dbt: Jinja2 템플릿 경험 연결
- [x] Airflow: Factory DAG 패턴 설명 준비
- [x] 품질 관리: DQC 51 + pytest 153 사례 준비
- [x] BigQuery: Redshift/Presto 경험 연결

### 비즈니스
- [x] 33개 센터 통합 → 전사 데이터 마트 설계
- [x] 셀프서비스 90% 감소 → BI/데이터 탐색 환경
- [x] Metric Catalog → 데이터 거버넌스

### 문화
- [x] PyTorch 기여 → 공유 문화 연결
- [x] 3년 미해결 이슈 해결 → 문제 해결 능력
- [x] BA+DA+DE 경력 → 비즈니스 지향적 엔지니어

### 라이브 코딩
- [ ] Factory DAG 패턴 코드 작성 연습
- [ ] SQL 윈도우 함수 복습
- [ ] pytest 기반 테스트 코드 작성 연습

---

## 다음 단계

1. **라이브 코딩 연습**: Factory DAG + SQL 품질 체크
2. **답변 외우기**: 위 5개 질문 답변 1분 분량으로 압축
3. **당근 블로그**: dbt+Airflow 도입기 한 번 더 읽기

**화이팅하세요! 🥕** 

송진영 님의 Factory DAG + DQC + Metric Catalog 경험은 당근 DAE와 **완벽한 fit**입니다. 자신감 있게 임하세요!

---

*Last updated: 2026-04-06*
