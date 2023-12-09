
##### 2-1-1 Date Class

# 데이터 형식에 따라 format을 넣어줘야 할 수도 아닐 수도 
date <- as.Date(c('2021-01-31', '2021-02-28', '2021-03-31'))

date <- as.Date(c('21/01/31', '21/02/28', '21/03/31'), format = '%y/%m/%d')

# 내부적으로 저장된 1970년 이후의 날짜
unclass(date)

##### 2-1-2 POSIXct, POSIXlt 클래스

# POSIXct와 POSIXlt클래스는 1970년 이후의 시간을 초 단위로 기록하는 데이터 클래스
# POSIXct는 date클래스와 같이 1970년 이후의 시간을 초 단위의 정수로 기록하는 클래스 
# POSIXlt는 연, 월, 일, 시, 분, 초의 정보를 리스트 형태로 기록하는 클래스
# POSIXlt는 1900년 이후로 계산되어 리스트가 만들어짐


# character를 POSIXct class로 변환
as.POSIXct('2021-01-31 12:34:56')

# POSIXct를 해체하면 정수 
unclass(as.POSIXct('2021-01-31 12:34:56'))

# character를 POSIXlt 클래스로 변환
as.POSIXlt('2021-01-31 12:34:56')

# POSIXlt를 해체하면 list 
unclass(as.POSIXlt('2021-01-31 12:34:56'))

# POSIXlt에서 1900년 이후의 연도를 추출
as.POSIXlt('2021-01-31 12:34:56')$year

##### 2-1-3 yearmon, yearqtr 클래스

# yearmon, yearqtr 클래스는 연, 월로 표현되거나 연, 분기로 표현된 시간 데이터가 있을 때 사용
# yearmon 클래스는 연, 월별 데이터를 표현하는 클래스
# yearqtr은 연, 분기 데이터를 표현하는 클래스
# yearmon클래스는 1월을 0으로, 2월을 1/12 = 0.083, 12월을 11/12 = 0.917로 표현하고,
# yearqtr클래스는 분기마다 0.25씩 더해서 저장되지만, 표현될 때는 우리가 쓰는 시간 형태로 표현된다.

if(!require(zoo)){
  install.package("zoo")
  library(zoo)
}

# character를 yearmon class로 변환
as.yearmon('2007-02')

# yearmon class를 해체하면 double
unclass(as.yearmon('2007-02'))

# 날짜가 있어도 yearmon은 연, 월까지만 인식
as.yearmon('2007-02-01')

# character를 yearqtr class로 변환(1분기)
as.yearqtr('2007-01')

# yearqtr class를 해체하면 double
unclass(as.yearqtr("2007-04"))

##### 2-1-4 날짜, 시간 포맷

as.Date('01/12/2010', format="%d/%m/%Y")

Sys.setlocale("LC_ALL", "English")

# %b는 축약형 월 이름, %B는 전체 월 이름
as.Date("01jan21", format='%d%b%y')

Sys.setlocale("LC_ALL", "Korean")

as.Date("011월21", format="%d%b%y")

