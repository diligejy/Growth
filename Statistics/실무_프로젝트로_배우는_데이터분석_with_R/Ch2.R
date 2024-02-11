### 2.9 사용자 함수 정의 

Normalization = function(x){
    y = (x - min(x)) / (max(x) - min(x))
    return(y)
}

# DIR = ""

### 2.11 중고차 데이터를 활용한 데이터 전처리 1 (apply)

Audi = read.csv("rawdata/Audi.csv", stringsAsFactors = FALSE)

str(Audi)

head(Audi)

# apply
Audi_S = Audi[, c("year", "price", "mileage", "mpg")]
Audi_S2 = Normalization(Audi_S)
summary(Audi_S2)

R_Matrix = matrix(data = 0,
                  nrow = nrow(Audi_S), 
                  ncol = ncol(Audi_S))

        
for (k in 1:ncol(Audi_S2)){
    R_Matrix[, k] = Normalization(Audi_S[, k])
}

R_DF = as.data.frame(R_Matrix)
summary(R_DF)

# apply 함수에서 margin = 2 옵션은 함수를 열별로 연산한다는 의미
R_DF2 = apply(Audi_S2, MARGIN = 2, FUN = Normalization)
summary(R_DF2)

# lapply()는 apply의 결과를 list 형태로 만드는 함수 
# lapply(Audi_S2, Normalization)

R_DF3 = as.data.frame(lapply(Audi_S2, Normalization))
summary(R_DF3)

### 2.12 중고차 데이터를 활용한 데이터 전처리 2 (dplyr 패키지1)

library(dplyr)
colMeans(filter(.data = Audi, year > 2016)[, c("tax", "mpg", "engineSize")])

Audi %>%
    filter(year > 2016) %>%
    select(tax, mpg, engineSize) %>%
    colMeans()

# 변수추가 - mutate

Audi2 = Audi %>%
    mutate(tax2 = ifelse(tax > 100, 1, 0),
            engineSize2 = round(engineSize))
head(Audi2)

# 그룹 간 빈도 수 계산 - group_by() + n()

Audi3 = Audi %>%
    group_by(transmission) %>%
    summarise(Count = n())
Audi3

Audi4 = Audi %>%
    group_by(transmission) %>%
    summarise(Count = n(),
              Price_Mean = mean(price),
              Price_Sd = sd(price))
Audi4

Audi5 = Audi %>% 
    group_by(transmission, year) %>% 
    summarise(Count = n(),
              Price_Mean = mean(price))
head(Audi5)

# 그룹 간 비율 계산

Audi6 = Audi %>%
    group_by(transmission, year) %>% 
    summarise(Count = n(),
              Price_Mean = mean(price)) %>%
    mutate(Perc = Count / sum(Count))
head(Audi6)    

# 데이터 정렬 기준 - arrange()

Audi7 = Audi %>% 
    arrange(price)

head(Audi7)

# 내림차순
Audi8 = Audi %>%
    arrange(-price)

head(Audi8)

# 상위 n개 추출 - top_n()

Audi20 = Audi %>%
    arrange(-price) %>% 
    top_n(n = 5, wt = -price)
head(Audi20)

# 데이터 추출 - filter()

Audi9 = Audi %>% 
    filter(year > 2016)

head(Audi9)

Audi10 = Audi %>%
    filter(year > 2016 & transmission == "Manual")
head(Audi10)

# 데이터 병합 - join()
Audi12 = Audi %>% 
    group_by(model) %>%
    summarise(Count = n()) %>% 
    filter(model %in% c(" A1", " A2", " A3", " A4"))

head(Audi12)

Audi13 = Audi %>% 
    group_by(model) %>%
    summarise(Mean = mean(price)) %>% 
    filter(model %in% c(" A3", " A4", " A5", " A6"))

head(Audi13)

Audi14 = Audi12 %>%
    left_join(Audi13, by = "model")

head(Audi14)

Audi15 = Audi12 %>%
    right_join(Audi13, by= "model")
head(Audi15)

Audi16 = Audi12 %>%
    full_join(Audi13, by = "model")
head(Audi16)

# 데이터 샘플링 
# 무작위 데이터 추출 - sample_n(), sample_frac()

# sample_n()은 데이터 개수를 지정해서 무작위 샘플링을 진행하는 함수
# sample_frac()은 비율만큼 샘플링하는 함수 
set.seed(123)
Audi17 = Audi %>%
    sample_n(size=5)
Audi17

Audi18 = Audi %>%
    sample_frac(size=0.05)
head(Audi18)

# 중복 데이터 처리 

# sample_frac(replace=TRUE) => 복원 추출
set.seed(1234)
Audi19 = Audi %>%
    mutate(Unique_Key = 1:nrow(Audi)) %>%
    sample_frac(size=1.5, replace=TRUE)
head(Audi19)
dim(Audi19)

sum(duplicated(Audi19$Unique_Key))

Audi19_2 = Audi19[!duplicated(Audi19$Unique_Key), ]
dim(Audi19_2)

set.seed(1234)

Audi19_3 = Audi %>%
    mutate(Unique_Key = 1:nrow(Audi),
           Unique_Key2 = nrow(Audi):1) %>%
    sample_frac(size=1.5, replace=TRUE)

head(Audi19_3)
dim(Audi19_3)

sum(duplicated(Audi19_3[, c("Unique_Key", "Unique_Key2")]))

Audi19_4 = Audi19_3[!duplicated(Audi19_3[, c("Unique_Key", "Unique_Key2")] ), ]
dim(Audi19_4)

# distinct() - keep_all = TRUE 옵션 설정해야 중복행 제거 
Audi19_5 = Audi19_3 %>%
    distinct(Unique_Key, Unique_Key2, .keep_all = TRUE)

dim(Audi19_5)

### 2.13 dplyr 활용 응용

P1 = Audi %>%
    muy
