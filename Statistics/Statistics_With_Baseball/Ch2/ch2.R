# 선수들의 타율 기록
a <- c(0.280, 0.257, 0.312, 0.266, 0.295)
b <- c("Eric", "John", "Steven", "Keith", "Kim")
c <- c(a, b)

install.packages("Lahman")
library(Lahman)

data("Batting")
View(Batting)

# 라만 데이터에서 많이 사용되는 테이블
# People(선수들 신상정보)
# Batting(타격)
# Pitching(투수력)
# Fielding(수비력)
data(People)
View(People)
View(Pitching)

# LA 다저스 투수 클레이턴 커쇼 선수의 데이터
a <- subset(Pitching, playerID=="kershcl01")
a <- Pitching[Pitching$playerID == "kershcl01", ]
a

a <- c("A", "B", "C", "D", "E")
b <- c(0.280, 0.257, 0.312, 0.266, 0.295)
c <- cbind(a, b)
colnames(c) <- c("player", "avg")
age <- c(26, 23, 31, 27, 24)
d <- cbind(c, age)

# Rbind 
a <- c("A", "B", "C", "D", "E")
b <- c(0.280, 0.257, 0.312, 0.266, 0.295)
f <- rbind(a, b)

# 순서가 다른 테이블 합치기 : merge
d <- matrix(c("C", "D", "E", "B", "A", 26, 23, 31, 27, 24), ncol=2)
colnames(d) <- c("player", "age")
e <- merge(c, d, by="player")

# 양적 변수를 명목 변수로 바꾸기
# 테이블 구조 확인 - str
str(e)

e$age <- as.numeric(as.character(e$age))
g <- ifelse(e$age > 25, 1, 0)
g

i <- ifelse(e$age>25, "blue", "black")
i

h <- cbind(e, g)
h

# 괄호 사용법
help("merge")

# 타율 구하기
a <- function(H, AB){H/AB}
a(10, 35)
a(17, 55)
a(14, 57)

# 결측값 제거
b <- na.omit(a)

## 조건문 사용하기

library(Lahman)
View(People)

# 2017년 메이저 리그 우승팀 휴스턴 애스트로스 주역 호세 알투베(Jose Altuve)
# 2016년 시즌 우승팀인 시카고 컵스의 주역인 벤 조브리스트(Ben Zobrist)의 공격력 비교
a <- subset(Batting, playerID=="altuvjo01"|playerID=="zobribe01")

b <- subset(a, yearID > 2011 & yearID < 2017)
c <- subset(b, !(yearID == 2014 | yearID == 2015))

# 홈런(HR), 3루타(X3B) 비교
d <- subset(c, select = c("playerID", "HR", "X3B"))

# 계속 사용할 테이블 고정하기
attach(Batting)
detach(Batting)

with(Batting, head(H/AB))
