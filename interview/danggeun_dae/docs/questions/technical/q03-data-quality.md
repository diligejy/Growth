# Q3. 데이터 품질 관리

> 데이터 품질 질문

---

## 질문

"로그 데이터에 누락이 발생했을 때, 비즈니스 지표 왜곡을 막기 위해 DAE로서 어떤 조치를 취하겠는가?"

---

## 핵심 답변 포인트 (30초 요약)

```
3단계 방어:
1. 실시간 모니터링 - 로그 수집량 기준선 이탈 감지
2. 데이터 품질 검증 - dbt tests, 지표 변화율 모니터링
3. 누락 시 복구 - is_partial_data 표시, 백필 실행
```

---

## 상세 답변

### 3단계 방어 전략

**1단계: 실시간 모니터링**
- 로그 수집량 기준선 설정 (시간별/분별 기대량)
- 예상량 대비 20% 이상 차이 시 알림 발송
- Airflow DAG 실패/지연 감지

**2단계: 데이터 품질 검증**
- dbt tests: not_null, unique, accepted_values
- 새벽 배치 시 데이터 검증 파이프라인 실행
- 지표 비교: 어제 대비 오늘 변화율 이상치 감지

**3단계: 누락 시 복구 절차**
- 누락 기간 표시 (is_partial_data = true)
- 백필(backfill) 파이프라인 즉시 실행
- 대시보드에 데이터 품질 상태 표시 (신뢰도 표시)

### 구현 예시

**dbt 테스트**:
```sql
models:
  - name: fct_transactions
    columns:
      - name: transaction_id
        tests:
          - unique
          - not_null
      - name: price
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
```

---

## 꼬리 질문 및 답변

### Q: 이미 지표가 왜곡되어 리포트되었다면?

**답변**:
1. 즉시 이해관계자에게 통보
2. 정확한 데이터로 재생성된 리포트 제공
3. 원인 분석 보고서 제공
4. 데이터 거버넌스 문서에 복구 프로세스 명문화

### Q: 누락된 데이터를 복구할 수 없다면?

**답변**:
1. 추정(Imputation) 고려 - 과거 패턴 기반
2. 해당 기간은 '데이터 불확실'로 표시
3. 원천 시스템 로그 백업 강화

---

## 실전 팁

### 데이터 품질 SLA
- P0 (Critical): 2시간 내 감지, 4시간 내 복구
- P1 (High): 4시간 내 감지, 24시간 내 복구
- P2 (Medium): 24시간 내 감지, 주간 복구

---

## Cross-Links

- 상위 문서: [key-questions.md](../key-questions.md)
- 이전 질문: [Q2 SQL 재방문율](./q02-retention.md)
- 다음 질문: [Q4 BigQuery 최적화](./q04-bq-optimization.md)
