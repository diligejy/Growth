## xlsx 파일 자료를 읽을 수 있는 readxl 패키지 로딩
library(readxl)
library(dplyr)
install.packages("ggplot2")
library(ggplot2) 

## 원자료 다운로드
# download.file("http://gapm.io/dl_pop", destfile="pop1800_2100.xlsx")

## 다운로드된 xlsx 파일의 두 번째 시트 불러오기
world_pop = read_xlsx("pop1800_2100.xlsx", sheet=2)

## 객체 클래스 확인
class(world_pop)

## 데이터 프레임의 첫 6줄만 보여주기
head(world_pop)

## 0. 2020년 이전 자료만 따로 저장
world_pop %>% 
  
  filter(year < 2020) %>% 
  
  ## 1. 자료의 x축과 y축 변수를 정의
  ggplot(aes(x = year, y = Population)) + 
  
  ## 2. 라인 그리기
  geom_line(size=2, alpha=0.6, color = "forestgreen") + 
  
  ## 3. 레이블 입력
  labs(caption = "원자료: Gapminder") + 
  
  ## 4. 그래프의 형식 지정
  # theme_jhp(base_size=10, base_family = "sans") + 
  
  ## 5. 축 이름 지정
  xlab("연도") + ylab("인구")

## 인구자료 로그 변환하여 데이터 프레임에 새 변수로 지정
sub <-subset(world_pop, year < 2020)
sub$log.pop <- log(sub$Population)

ggplot(sub, aes(x=year, y=log.pop)) + 
  geom_line(size=2, alpha=0.8, color="forestgreen") + 
  geom_smooth(method='lm', color='firebrick2') + 
  labs(caption = "원자료: Gapminder") + 
  xlab("연도") + ylab("인구 (log)")

## 1950년을 기점으로 구분하는 더미변수 생성
sub$period <- ifelse(sub$year < 1951, "Before-1950", "Post-1950")

## x축과 y축 자료 지정, 그룹 정보와 색 정보도 지정
ggplot(sub, aes(x=year, y=log.pop, group=period, color=period)) + 
  geom_line(size=2, alpha=0.8, color="forestgreen") + 
  geom_smooth(method="lm", color="firebrick2") + 
  labs(caption="원자료: Gapminder") +
  xlab("연도") + ylab("인구 (log)")

## 곡물 생산 자료 ourworldindata.org/crop-yields

## 자료 불러오기 
crop = read.csv("long-term-cereal-yields-in-the-united-kingdom.csv")

uk_crop <- subset(crop, country == "United Kingdom")

## 1800년대 이후 자료만 따로 저장
sub_crop <- subset(uk_crop, year > 1799)

## 새로 저장된 자료 살펴보기
head(sub_crop)

## 1. x축과 y축 자료 지정
ggplot(sub_crop, aes(x = year, y = wheat_yield)) + 
  
  ## 2. 선 그리기 
  geom_line(size=0.5, color="forestgreen") + 
  
  ## 3. 점 그리기
  geom_point(size=1.5, alpha=0.2, color="forestgreen") + 
  
  ## 4. 레이블 달기
  labs(caption = "자료출처: Our World In Data") + 
  
  ## 5. 축 이름 달기
  xlab('연도') + ylab("헥타르 당 톤")

## 1950년 이전과 이후를 구분하는 더미변수 생성
sub_crop$period <- ifelse(sub_crop$year < 1951, "Before-1950", "Post-1950")

## x축과 y축 자료 지정, 그룹 정보와 색 정보도 지정
ggplot(sub_crop, aes(x = year, y = wheat_yield, group = period, color=period)) + 
  geom_line(size=0.5, color="forestgreen") + 
  geom_point(size=1.5, alpha=0.2, color="forestgreen") + 
  geom_smooth(method="lm", color="firebrick2") + 
  labs(caption = "자료출처: Our World In Data") + 
  xlab("연도") + ylab("헥타르당 톤")

## 정규화 함수 작성
center <- function(x=NULL){
  out <- (x - mean(x, na.rm=TRUE)) / sd(x, na.rm=TRUE)
  return(out)
}

## 1. 인구자료와 밀생산 자료를 연도와 분절점 기준으로 결합
malthus <- sub %>% left_join(sub_crop, by = c("year" = "year", "period" = "period"))

## 2. 인구와 밀생산 자료를 표준화
malthus$center.pop <- center(malthus$Population) 
malthus$center.wheat <- cneter(malthus$wheat_yield)

## 3. ggplot을 이용한 시각화
ggplot(malthus, aes(x=year, y=center.pop)) + 
  geom_line(size=2, alpha=0.6, color="firebrick2") + 
  geom_line(aes(x=year, y = center.wheat), size=0.5, color="forestgreen") + 
  geom_point(size=1, alpha=0.6, color="firebrick2") + 
  geom_point(aes(x = year, y = center.wheat), size=1.5, alpha=0.2, color="forestgreen") + 
  labs(caption="자료출처: Gapminder와 Our World In Data") + 
  xlab("연도") + ylab("표준화 지수")
