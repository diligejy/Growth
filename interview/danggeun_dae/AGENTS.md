# AGENTS.md

> 당근마켓 DAE 면접 준비 - 하네스 엔지니어링 원칙 적용

---

## 🎯 핵심 원칙

1. **저장소가 진실의 원천**: 모든 면접 준비 자료는 이 폴더 내에 있음
2. **Progressive Disclosure**: 작은 entry point에서 시작, 필요시 deeper sources 탐색
3. **Agent/User 가독성 우선**: "boring" 기술 사용, 복잡성 숨김
4. **품질 기반 완료**: 체크리스트 충족 시 준비 완료

---

## 📁 저장소 구조

```
interview/danggeun_dae/
├── AGENTS.md              # 이 파일 (Entry Point)
├── ARCHITECTURE.md        # 전체 구조 개요
├── docs/
│   ├── design-docs/       # 설계 원칙 및 인사이트
│   │   ├── metrics.md     # 당근 지표 분석
│   │   ├── business-model.md  # 비즈니스 모델 이해
│   │   └── dae-role.md    # DAE 직무 이해
│   ├── exec-plans/        # 실행 계획
│   │   └── tomorrow-prep.md   # 내일 면접 준비 플랜
│   └── questions/         # 질문별 상세 답변
│       ├── technical/     # 기술 질문
│       ├── business/      # 비즈니스 질문
│       └── culture/       # 컬처핏 질문
└── checklists/
    └── pre-interview.md   # 면접 전 체크리스트
```

---

## 🚀 작업 시작하기

### 빠른 시작 (지금 당장 필요한 것)

**[15분 완성] 필수 체크리스트**
→ `checklists/pre-interview.md`

**[30분 완성] 핵심 질문 답변 준비**
→ `docs/questions/key-questions.md`

---

### 심층 학습 (시간이 있을 때)

| 주제 | 문서 | 예상 시간 |
|------|------|-----------|
| 당근 지표 분석 | `docs/design-docs/metrics.md` | 20분 |
| 비즈니스 모델 | `docs/design-docs/business-model.md` | 15분 |
| DAE 직무 이해 | `docs/design-docs/dae-role.md` | 10분 |
| 기술 질문 모음 | `docs/questions/technical/` | 40분 |
| 비즈니스 질문 모음 | `docs/questions/business/` | 30분 |

---

## ✅ 작업 완료 조건

- [ ] `checklists/pre-interview.md` 모든 항목 체크
- [ ] 핵심 질문 10개 답변 연습 완료
- [ ] 당근 앱 오늘 한 번 실행해서 화면 확인
- [ ] "왜 당근인가" 답변 1분 분량 준비

---

## 📚 핵심 인사이트 (한눈에 보기)

### 당근 현황 (2025년 기준)

| 지표 | 수치 | 의미 |
|------|------|------|
| 누적 가입자 | 4,300만 | 국민 1/3 가입 |
| MAU | 2,000만 | 정체 (성숙기) |
| DAU 성장 | 2023년 +9.7% | 매일 쓰는 앱 전환 성공 |
| 앱 사용시간 | 2024년 +13.2% | 광고 매출 직결 |
| 광고 매출 | 1,891억 (2024) | 전체의 99.7% |
| 영업이익 | 376억 (2024) | 흑자 전환 유지 |

### DAE 직무 핵심

> **"비즈니스 임팩트를 위해 분석하기 좋은 데이터 환경을 설계하는 사람"**

| 기술 | 용도 |
|------|------|
| BigQuery | 메인 데이터 저장소 (GCP) |
| dbt | 데이터 모델링/문서화 |
| Airflow | 파이프라인 스케줄링 |
| Python/SQL | 데이터 가공/분석 |

---

## 🔗 Cross-Links

- 전체 구조: [ARCHITECTURE.md](./ARCHITECTURE.md)
- 내일 준비 플랜: [docs/exec-plans/tomorrow-prep.md](./docs/exec-plans/tomorrow-prep.md)
- 체크리스트: [checklists/pre-interview.md](./checklists/pre-interview.md)

---

*Last updated: 2026-04-06*
*면접일: 2026-04-07*
