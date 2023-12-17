##### 2-2-1 ts

# ts 객체는 R에서 기본적으로 제공되는 시계열 데이터 타입
# ts 객체는 stats 패키지를 로딩해야 사용할 수 있지만, stats 패키지는 R이 실행될 때 기본적으로 로딩되기 때문에 바로 활용 할 수 있음 
# ts 객체는 stats 패키지에서 제공하는 다양한 시계열 데이터 처리 함수가 다루기 때문에 많이 사용됨 

# ts 객체의 가장 큰 단점 - ts 객체는 원본 데이터 시간을 사용하지 않는다는 점 

# ts 객체 생성 함수인 ts()는 매개변수로 원본 데이터의 측정값은 사용하지만, 원본 데이터의 시간은 사용하지 않음
# 그 대신 시계열 데이터의 시작일, 종료일, 저장 주기(1은 연도별, 12는 월별 등)를 설정하면, 데이터의 시간을 설정함

# 예시 
# 주5일 근무하는 직장인의 매일 근무시간인 10개의 시계열 데이터, 시작일은 2월 1일 월요일, 주말 6, 7일은 근무하지 않음
# 실제 데이터는 2월 1일 월요일부터 2월 12일 금요일까지의 데이터
# 하지만 ts객체로 저장될 때는 2월 1일이 시작일이고 저장주기가 1일이기 때문에 2월 1일 월요일부터 2월 10일 수요일까지의 데이터가 됨 

ts(1:10, frequency=4, start=c(1959, 2))


##### 2-2-2 xts

# xts = extensible time-series의 준말
# xts 패키지를 로딩해야 호라용할 수 있는 시계열 데이터 객체
# xts는 forecast, fable, modeltime에서 사용되지 않는 시계열 객체
# 시계열 데이터 처리를 위한 다양한 함수를 제공하기 때문에 간단히 데이터를 확인하거나 데이터를 원하는 형태로 변환하는 데 쉽게 사용 가능 
# xts 객체를 사용하여 원하는 형태로 데이터를 만들고 다른 시계열 객체로 변환하는 것도 좋은 방법 

if(!require(xts)){
  install.packages("xts")
  library(xts)
}

set.seed(345)
xts(rnorm(5), as.Date("2008-08-01") + 0:4)

#as.xts()는 timeSeries, ts, irts, fts, matrix, data.frame, zoo 객체를 xts 객체로 변환하는 함수 
ts <- ts(1:10, frequency=4, start=c(1959, 1))
xts(ts)

as.xts(ts)

# ts, xts는 모두 시계열을 다루는 객체이지만, xts가 ts보다 시계열 데이터를 다루는 데 유연한 함수가 많음
# 최근에는 ts 객체에도 동일하게 적용할 수 있는 xts 함수가 제공되고 있음
# xts 메뉴얼에 의하면 as.xts()와 reclass()를 활용하는 것이 xts()를 사용하는 것보다 이익이 있다고 명기하고 있음
# bit.ly/38FrmWt

# 시계열 데이터 형태로 보이지 않음
head(ts)

# 시계열 형태로 보임
head(as.xts(ts))

##### 2-2-3 tsbibble

# tidyverts 패밀리 패키지는 tidyverse를 사용하는 방법을 시계열 데이터 작업에도 사용 가능하게 함

# tidyverts는 시계열 데이터 저장 할 수 있는 객체 패키지인 tsbibble, 시계열 예측을 위한 fable, 시계열 특성 추출과 통계를 위한 feast, 최근에 페이스북에서 개발된 prophet 모델을 사용하기 위한 fable.prophet 패키지 등을 포함함
# tsibble 객체는 tsibble 패키지를 통해 제공되는 시계열 데이터 객체로서 tidy 데이터 원칙을 준용하여 시계열 데이터를 다룰 수 있도록 tibble 객체를 확장한 객체 

# tsibble 객체는 각 관찰값(observation)을 고유하게 식별할 수 있는 칼럼 혹은 칼럼의 집합인 key와 시간의 순서가 지정되는 index를 필요로 함 

# 즉, tibble 객체에서는 key로 특정 데이터의 관찰값을 식별할 수 있지만, 
# tsibble에서는 key를 통해 특정 데이터를 식별하고 index를 통해 식별된 데이터의 특정 시간의 데이터 값을 식별할 수 있음

# 따라서 tsibble은 key와 index를 사용하여 고유한 데이터의 고유한 관찰값을 식별하게 됨 
if(!require(tsibble)){
  install.packages("tsibble")
  library(tsibble)
}

# tsibble 객체 생성
library(dplyr)
set.seed(345)

x <- data.frame(date=as.Date("2008-01-01") + 0:9, id=1:10, x1=rnorm(10), x2=rep("a", 10))
as_tsibble(x, key=id, index=date)
# key값은 id로 생략
as_tsibble(x, index=date) 
