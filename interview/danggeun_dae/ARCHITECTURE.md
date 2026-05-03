# ARCHITECTURE.md

> 당근마켓 DAE 면접 준비 - 시스템 아키텍처 개요

---

## 1. 면접 준비 전체 구조

```
┌─────────────────────────────────────────────────────────────┐
│                     ENTRY POINT                              │
│                    AGENTS.md                                 │
│              (지금 여기 계신 것)                              │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐    ┌─────────────────┐    ┌───────────────┐
│  DESIGN-DOCS  │    │   QUESTIONS     │    │  CHECKLISTS   │
│   (설계 문서)  │    │   (질문 모음)    │    │   (체크리스트) │
└───────────────┘    └─────────────────┘    └───────────────┘
        │                     │                     │
   ┌────┴────┐           ┌────┴────┐           ┌────┴────┐
   │         │           │         │           │         │
   ▼         ▼           ▼         ▼           ▼         ▼
metrics.md  dae-role.md  technical/ business/  pre-interview.md
business-              culture/
model.md
```

---

## 2. 문서별 목적과 의존성

### 2.1 DESIGN-DOCS (핵심 신념)

| 문서 | 목적 | 언제 읽나 |
|------|------|----------|
| `metrics.md` | 당근 지표 분석 및 인사이트 | 데이터 질문 준비 시 |
| `business-model.md` | BM 이해 및 전략 분석 | 비즈니스 질문 준비 시 |
| `dae-role.md` | DAE 직무 및 기술 스택 | 역할 관련 질문 준비 시 |

**의존성**: metrics.md → business-model.md → dae-role.md (순차적 읽기 권장)

### 2.2 QUESTIONS (실전 준비)

| 폴더 | 내용 | 난이도 |
|------|------|--------|
| `technical/` | 기술/데이터 엔지니어링 질문 | 중~상 |
| `business/` | 비즈니스/전략 질문 | 중 |
| `culture/` | 컬처핏/경험 질문 | 하~중 |

**의존성**: 각 폴더 내에서 번호 순서대로 읽기 (난이도 순)

### 2.3 EXEC-PLANS (실행 계획)

| 문서 | 목적 | 사용 시점 |
|------|------|----------|
| `tomorrow-prep.md` | 내일 면접 D-1 준비 플랜 | 면접 전날 |

### 2.4 CHECKLISTS (품질 검증)

| 문서 | 목적 | 완료 기준 |
|------|------|----------|
| `pre-interview.md` | 면접 전 필수 체크사항 | 모든 항목 체크 |

---

## 3. 질문 카테고리별 매핑

### 기술 질문 (TECHNICAL)

| 질문 ID | 질문 유형 | 관련 문서 |
|---------|----------|----------|
| T01 | 스타 스키마 설계 | `design-docs/dae-role.md` |
| T02 | SQL 재방문율 | `questions/technical/q02-retention.md` |
| T03 | 데이터 품질 | `questions/technical/q03-data-quality.md` |
| T04 | BigQuery 최적화 | `questions/technical/q04-bq-optimization.md` |
| T05 | Airflow 멱등성 | `questions/technical/q05-airflow-idempotency.md` |

### 비즈니스 질문 (BUSINESS)

| 질문 ID | 질문 유형 | 관련 문서 |
|---------|----------|----------|
| B01 | 동네 연결 지표 | `design-docs/business-model.md` |
| B02 | 매너온도 개선 | `design-docs/metrics.md` |

### 컬처핏 질문 (CULTURE)

| 질문 ID | 질문 유형 | 관련 문서 |
|---------|----------|----------|
| C01 | 협업/설득 | `questions/culture/q01-collaboration.md` |
| C02 | 비즈니스 가치 | `questions/culture/q02-business-value.md` |
| C03 | 왜 당근인가 | `questions/culture/q03-why-danggeun.md` |

---

## 4. 추천 학습 경로

### 경로 A: 시간 없음 (2시간)

1. `checklists/pre-interview.md` 체크 (15분)
2. `questions/key-questions.md` 핵심 10개 (45분)
3. `docs/exec-plans/tomorrow-prep.md` 실행 (60분)

### 경로 B: 적당한 시간 (4시간)

1. 경로 A 수행 (2시간)
2. `design-docs/metrics.md` 읽기 (30분)
3. `questions/technical/` 중 필수 질문 3개 (60분)
4. `questions/culture/q03-why-danggeun.md` 작성 (30분)

### 경로 C: 충분한 시간 (6시간+)

1. 경로 B 수행 (4시간)
2. 모든 `design-docs/` 읽기 (60분)
3. 모든 `questions/` 읽고 답변 연습 (60분+)

---

## 5. 문서 작성 규칙

### 파일 네이밍

- 설계 문서: `topic.md` (소문자, 하이픈 구분)
- 질문 문서: `qNN-title.md` (번호-제목)
- 체크리스트: `action.md` (동사 중심)

### 문서 구조

```markdown
# 제목

> 한 줄 요약

---

## 핵심 포인트 (3-5개)

## 상세 내용

## 면접 답변 가이드

---

## Cross-Links
- 상위 문서:
- 관련 문서:
```

---

## 6. 품질 기준

| 문서 유형 | 완료 기준 | 검증 방법 |
|----------|----------|----------|
| DESIGN-DOCS | 핵심 인사이트 3개 이상 | 질문에 답변 가능 여부 |
| QUESTIONS | 질문-답변-꼬리질문 구조 | 1분 내 답변 가능 여부 |
| CHECKLISTS | 모든 항목 체크 | 체크리스트 검토 |

---

*참고: AGENTS.md의 작업 완료 조건과 연결됨*
