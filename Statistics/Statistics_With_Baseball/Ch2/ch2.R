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
c
colnames(c) <- c("player", "avg")
c
age <- c(26, 23, 31, 27, 24)
d <- cbind(c, age)
d

# Rbind 
a <- c("A", "B", "C", "D", "E")
b <- c(0.280, 0.257, 0.312, 0.266, 0.295)
f <- rbind(a, b)
f

# 순서가 다른 테이블 합치기 : merge
d <- matrix(c("C", "D", "E", "B", "A", 26, 23, 31, 27, 24), ncol=2)
colnames(d) <- c("player", "age")


