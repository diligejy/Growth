# 당근 DAE 면접 준비 - LLM Handover 문서

> 다른 LLM에게 인계하기 위한 완전 정리본
> 대상: Data Analytics Engineer (DAE) 면접 준비 중인 송진영 님

---

## 🎯 Handover 요약 (3줄)

**송진영 님**이 **오늘 15:00** 당근마켓 DAE 면접을 앞두고 있습니다.  
**Coupang CLS + Big Insight 경력**을 바탕으로 **Factory DAG, DQC 51+pytest 153, Metric Catalog** 경험이 핵심 강점입니다.  
**화상 인터뷰 + Coderpad 코딩 테스트(SQL/Python)** 형식이며, **dbt 미경험**이 유일한 약점입니다.

---

## 📋 면접 기본 정보

| 항목 | 내용 |
|------|------|
| **지원자** | 송진영 (Jinyoung Song) |
| **직무** | Data Analytics Engineer (데이터 가치화 팀) |
| **면접 시간** | **2026년 4월 7일 (오늘) 15:00** |
| **면접 형식** | 화상 인터뷰 + Coderpad 코딩 테스트 |
| **남은 시간** | 약 4시간 |
| **코딩 테스트** | SQL, Python (복잡한 알고리즘 X) |
| **입장 시간** | 14:55 (5분 전) |

---

## 👤 지원자 프로필 (핵심)

### 경력 요약
| 회사 | 기간 | 역할 | 핵심 성과 |
|------|------|------|-----------|
| **Coupang CLS** | 주요 | BA/Data Engineer | 33개 물류센터 통합 (Factory DAG), DQC 51+pytest 153, Metric Catalog |
| **Big Insight** | 이전 | Data Analyst/Product | 이벤트 택소노미, Dash+ClickHouse 셀프서비스 (요청 90% 감소) |

### 기술 스택
- **강점**: Airflow (Factory DAG), Python, SQL, Jinja2, Presto, Redshift, Metric Catalog
- **약점**: **dbt (직접 경험 없음, Jinja2 템플릿 경험으로 간접 이해)**
- **특이사항**: PyTorch 문서 한글화 기여 (오픈소스)

### 핵심 강점 3가지
1. **Factory DAG + Jinja2** → dbt macro로 확장 가능성
2. **DQC 51 + pytest 153** → dbt tests + Airflow SLA로 마이그레이션 가능
3. **Metric Catalog** → 당근 데이터 거버넌스와 완벽한 fit

---

## 📁 준비된 모든 문서 (경로 포함)

### 메인 문서 (반드시 먼저 확인)
| 문서 | 경로 | 용도 | 우선순위 |
|------|------|------|----------|
| **THE_ONE_PAGE.md** | `interview/danggeun_dae/THE_ONE_PAGE.md` | 10분 훑기용 요약 | ⭐⭐⭐⭐⭐ |
| **COMPLETE_GUIDE.md** | `interview/danggeun_dae/COMPLETE_GUIDE.md` | 완전 통합 가이드 | ⭐⭐⭐⭐⭐ |
| **TODAY_SCHEDULE.md** | `interview/danggeun_dae/TODAY_SCHEDULE.md` | 오늘 시간별 플랜 | ⭐⭐⭐⭐⭐ |

### 맞춤형 문서
| 문서 | 경로 | 내용 |
|------|------|------|
| **jinyoung-song-prep.md** | `interview/danggeun_dae/docs/personalized/jinyoung-song-prep.md` | 이력서 기반 5선 질문+완벽 답변 |
| **coding-test-guide.md** | `interview/danggeun_dae/docs/exec-plans/coding-test-guide.md` | Coderpad SQL/Python 예제 |

### 참고 문서
| 문서 | 경로 | 내용 |
|------|------|------|
| **job-posting-analysis.md** | `interview/danggeun_dae/docs/references/job-posting-analysis.md` | 채용공고 분석 |
| **tech-blog-insights.md** | `interview/danggeun_dae/docs/references/tech-blog-insights.md` | 당근 테크 블로그 인사이트 |
| **AGENTS.md** | `interview/danggeun_dae/AGENTS.md` | 저장소 구조 안내 |

### 질문별 상세 문서
| 위치 | 문서 수 | 내용 |
|------|---------|------|
| `docs/questions/technical/` | 5개 | Star Schema, Retention SQL, 데이터 품질, BQ 최적화, Airflow Idempotency |
| `docs/questions/business/` | 2개 | 동네 연결 측정, 매너온도 개선 |
| `docs/questions/culture/` | 3개 | 협업/설득, 비즈니스 가치, 왜 당근인가 |

---

## 🔥 핵심 질문 5선 (반드시 준비됨)

### Q1. Factory DAG → dbt 적용
**질문**: "33개 센터 통합 경험을 당근에 어떻게 적용하시겠어요?"

**핵심 답변**:
- 33개 센터를 Factory DAG + Jinja2로 통합 (온보딩 2주→2시간)
- dbt macro + source()로 서비스별(중고/알바/비즈) 템플릿화 가능

### Q2. DQC 51 + pytest 153 → dbt tests
**질문**: "데이터 품질 관리를 어떻게 하시나요?"

**핵심 답변**:
- Presto DQC (비즈니스 로직) + pytest (파이프라인) 이중 체계
- 140만 행 누락 버그 사전 탐지
- dbt tests + Airflow SLA로 마이그레이션 가능

### Q3. 3년 미해결 타임스탬프 이슈
**질문**: "6개 팀 데이터 불일치를 어떻게 해결했나요?"

**핵심 답변**:
- 타임스탬프 분석으로 근본 원인 규명 (KST vs UTC, 정밀도 차이)
- 전사 표준 정의 (UTC + millisecond + ISO 8601)
- 3년간 누적된 2% 불일치 해결

### Q4. Metric Catalog → 데이터 거버넌스
**질문**: "전사 지표를 어떻게 관리했나요?"

**핵심 답변**:
- Metric Catalog로 지표 정의 통일, 계보 제공
- Observability 대시보드로 데이터 신뢰성 확보
- 당근 "매일 데이터를 통한 의사결정" 비전과 부합

### Q5. 왜 당근인가 (컬처핏)
**질문**: "왜 당근마켓 DAE에 지원하셨나요?"

**핵심 답변**:
1. 비전 공감: "매일 데이터를 통해 사용자를 위한 의사결정"
2. 기여 가능: Factory DAG, DQC, Metric Catalog 경험이 fit
3. 성장 의지: dbt/Airflow로 "분석가가 뛰어놀 수 있는 환경" 만들고 싶음

---

## 💻 Coderpad 코딩 테스트 대비

### 예상 문제 유형
| 유형 | 확률 | 준비 상태 |
|------|------|-----------|
| **Factory DAG 패턴 (Python)** | 높음 | 예제 코드 완성됨 |
| **SQL 윈도우 함수** | 높음 | 예제 쿼리 완성됨 |
| **pandas 데이터 처리** | 중간 | 예제 코드 완성됨 |
| **데이터 품질 체크 SQL** | 중간 | 예제 쿼리 완성됨 |

### 준비된 예제 코드 위치
- **Python Factory DAG**: `docs/exec-plans/coding-test-guide.md` Section 3.2
- **SQL 윈도우 함수**: `docs/exec-plans/coding-test-guide.md` Section 3.3
- **pandas 집계**: `docs/exec-plans/coding-test-guide.md` Section 3.4

---

## ⚠️ 약점 및 대비책

### 주요 약점: dbt 직접 경험 부족
**현황**: dbt를 프로덕션에서 사용한 경험 없음

**대비책** (이미 준비됨):
1. **Jinja2 템플릿 경험** 강조 → dbt macro 학습 빠름
2. **Factory DAG 패턴** → dbt incremental model과 유사성 어필
3. **SQL-based DQC** → dbt tests 개념 이미 이해함
4. **당근 블로그** "dbt 도입하며 마주한 7가지 문제들" 읽음

**꼬리질문 대비**:
- Q: "dbt 써본 적 있나요?"
- A: "프로덕션 경험은 없지만, Jinja2 템플릿과 Factory DAG 경험으로 빠르게 적응 가능합니다. 당근 블로그 읽고 주요 개념을 이해했습니다."

---

## ✅ 아직 하지 않은 것 (해야 할 일)

| 항목 | 중요도 | 예상 시간 |
|------|--------|-----------|
| **"왜 당근인가" 답변 실제 연습** | ⭐⭐⭐⭐⭐ | 10분 |
| **Coderpad 예제 1개 실제 풀기** | ⭐⭐⭐⭐⭐ | 15분 |
| **핵심 3선 질문 답변 소리내어 연습** | ⭐⭐⭐⭐⭐ | 15분 |
| **dbt 개념 10분 복습** | ⭐⭐⭐ | 10분 |
| **면접 복장/환경 최종 점검** | ⭐⭐⭐ | 10분 |

---

## 🎯 LLM이 해야 할 일 (지원자를 위해)

### 즉시 도와드릴 것 (우선순위 순)
1. **모의 면접 진행** - Q1-Q5 질문하고 답변 평가/피드백
2. **코딩 테스트 연습** - Coderpad 예제 1개 풀어보기
3. **약점 보완** - dbt 질문에 대한 답변 다듬기
4. **"왜 당근인가" 답변 완성** - 1분 분량 완벽하게 외울 수 있도록

### 하지 말아야 할 것
- ❌ 새로운 개념 가르치기 (시간 부족, 불안 증가)
- ❌ 복잡한 이론 설명 (실전 중심으로)
- ❌ 부정적 피드백 (자신감 저하)

---

## 📞 문서 접근 경로 (전체)

```
Windows: C:\Users\sjy04\Videos\Growth\interview\danggeun_dae\

├── THE_ONE_PAGE.md                    (10분 훑기)
├── COMPLETE_GUIDE.md                  (완전 가이드)
├── TODAY_SCHEDULE.md                  (오늘 시간별 플랜)
├── AGENTS.md                            (Entry Point)
├── ARCHITECTURE.md                      (구조 안내)
│
├── docs/
│   ├── personalized/
│   │   └── jinyoung-song-prep.md        (이력서 기반 5선)
│   │
│   ├── exec-plans/
│   │   ├── tomorrow-prep.md             (준비 플랜)
│   │   └── coding-test-guide.md         (Coderpad 대비)
│   │
│   ├── references/
│   │   ├── job-posting-analysis.md      (채용공고)
│   │   └── tech-blog-insights.md        (블로그 인사이트)
│   │
│   └── questions/
│       ├── key-questions.md             (핵심 10선)
│       ├── technical/                   (5개 기술 질문)
│       ├── business/                    (2개 비즈니스)
│       └── culture/                     (3개 컬처핏)
│
└── checklists/
    └── pre-interview.md                 (최종 체크리스트)
```

---

## 🚀 지원자에게 전할 메시지

> **이미 충분히 준비되었습니다.**
>
> Factory DAG + DQC 51 + Metric Catalog 경험은  
> 당근 DAE와 **완벽한 fit**입니다.
>
> 남은 4시간은 **실전 연습**에 집중하세요.  
> 새로운 것을 배우기보다 **준비된 것을 다듬는** 시간으로 사용하세요.
>
> 화이팅! 🥕

---

*Handover 문서 완성*
*작성 시점: 2026-04-07 10:31*
*면접까지: 약 4시간 남음*
