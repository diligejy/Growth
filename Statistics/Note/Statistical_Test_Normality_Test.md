## 1. 독립표본 t 검정 조건

1. 독립성
2. 등분산성
3. 정규성

## 2. 독립성
- A 그룹과 B 그룹간의 상호 독립성 만족

## 3. 등분산성
-  A 그룹과 B 그룹 분포의 분산 동일해야 함
- 검정 방법
    - 바틀렛 검정(bartlett) : scipy.stats.bartlett
    - 플리그너 검정(fligner) : scipy.stats.fligner
    - 레빈 검정(levene) : scipy.stats.levene
- 등분산성이 만족하지 않은 경우 이분산 t검정(Welch's Test)를 사용할 수 있음

## 4. 정규성
- 검정 방법
    - 콜모고로프-스미르노프 검정(Kolmogorov-Smirnov test) : scipy.stats.ks_2samp
    - 샤피로-윌크 검정(Shapiro Wilk test) : scipy.stats.shapiro
    - 앤더스-달링 검정(Anderson Darling test) : scipy.stats.anderson
    - 다고스티노 K-제곱 검정(D'Agostino's K-squared test) : scipy.stats.mstats.normaltest
    - 콜모고로프-스미르노프 검정(Kolmogorov-Smirnov test) : statsmodels.stats.diagnostic.kstest_normal
    - 옴니버스 검정(Omnibus Normality test) : statsmodels.stats.stattools.omni_normtest
    - 자크-베라 검정(Jarque Bera test) : statsmodels.stats.stattools.jarque_bera
    - 릴리포스 검정(Lilliefors test) : statsmodels.stats.diagnostic.lillifors
- 1995년 발표된 [Statistical notes for clinical researchers: assessing normal distribution (2) using skewness and kurtosis](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3591587/)에 따르면 skenewss < 2 & kurtosis < 7 일 경우 정규분포에 크게 벗어나지 않고 정규성을 보인다고 함
