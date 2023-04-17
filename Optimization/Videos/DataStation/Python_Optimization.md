## 최적화(Optimization)

- 문제 상황에서 여러 해결방안 중 가장 최적의 해결방안을 찾아가는 작업

### 수학적 접근
- 특정 함수의 값을 최소화(또는 최대화)시키는 최적의 수식값(최적의 파라미터)의 조합을 찾는 문제
- 최적화 문제는 최대화(Maximization)와 최소화(Minimization)으로 나누어볼 수 있음
    - 최대화(Maximization) : 함수의 목표변수(Y, Label, Output)를 최대가 되게끔 파라미터(계수와 절편, Weight)의 조합을 찾는 문제
        - 이윤, 점수
    - 최소화(Minimization) : 함수의 목표변수(Y, Label, Output)를 최소가 되게끔 파라미터(계수와 절편, Weight)의 조합을 찾는 문제        
        - 비용, 손실, 오차 
- 기본적으로 머신러닝(기계학습)을 이용하여 데이터의 관계를 파악해 새로운 데이터가 들어왔을 때, 목표값을 예측/분류하는 수식을 만드는 과정(Modeling)에서 최적화를 이용해 Model(수식) 구축
- 함수식이 예측한 예측값과 실제 데이터 상에서 수집된 실제값을 비교하여, 실제값과 예측값의 차이가 최소가 되는 방향으로 (Minimization)으로 최적화 수행

### 데이터 분석에서 최적화
- 머신러닝 모델을 구축하여 예측/분류를 수행할 때, 정확한 모델을 도출하기 위해 여러 파라미터를 비교하여 찾는 작업
- 여러 알고리즘을 비교하여 가장 적절한 알고리즘을 찾는 작업 
- 회귀 분석에서 최소제곱법(Least Square Method)와 경사하강법(Gradient Descent)와 같은 방법으로 모델 구축


### 최적화의 기본 원리 (Minimization 관점에서)
- 현재의 위치에서 함수의 값(Y)이 감소하는 방향으로 파라미터 값을 변경해 나가는 원리
- 파라미터 값을 변경해도 더 이상 감소하는 부분이 없을 때까지 (Local Minima) 파라미터를 변경

### 최적화의 핵심 포인트
- 어떤 방향(양/음, 고차원의 경우 특정 벡터 방향)으로 감소/증가할 것인가
- 얼마만큼 파라미터를 변경할 것인가