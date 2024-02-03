# 2011년부터 2016년까지 시즌 50게임을 초과해서 뛴 선수들의 체중과 장타율 회귀분석

library(Lahman)
a<-subset(Batting,yearID>2010&yearID<2017&G>150)
b<-subset(People,sel=c("playerID","weight"))
c<-merge(a,b,by="playerID")
c$slg<-with(c,((H-X2B-X3B-HR)+2*X2B+3*X3B+4*HR)/AB)
with(c,plot(weight,slg,type="n"))
abline(lm(slg~weight,c))
fit<-lm(slg~weight,c)
fit_res<-resid(fit)
plot(c$weight,fit_res)
abline(0,0)
qqnorm(fit_res)
qqline(fit_res)

# 베르누이 분포 만 번 시뮬레이션
a <- rbinom(10000, 5, 0.46)
table(a) / 10000

# Maximum Likelihood Method
# 로그 확률함수에 미분한 상태인 그래프
curve(log(10*x^2*(1-x)^3), 0.1, ylab="Log Probability", xlab="OBP")

# 출루율이 0.4일 때 다섯 번의 타석에서 두 번 출루할 확률
OBP <- 0.4
base <- 0:5
P <- OBP^base * (1 - OBP)^(5 - base)
case <- choose(5, base)
EV <- P * case
EV
barplot(EV)

# 4개의 막대그래프를 한 화면에 제시하는 코드
par(mfrow = c(2, 2))

# 출루율 2할 타자의 막대그래프
OBP <- 0.2
base <- 0:5
P <- OBP^base * (1 - OBP)^(5 - base)
case <- choose(5, base)
EV <-P*case
barplot(EV, main="OBP=0.2 (20.48%)", ylab = "possibility")

# 출루율 3할 타자의 막대그래프
OBP <- 0.3
base <- 0:5
P <- OBP^base * (1 - OBP)^(5 - base)
case <- choose(5, base)
EV <-P*case
barplot(EV, main="OBP=0.3 (30.87%)", ylab = "possibility")

# 출루율 4할 타자의 막대그래프
OBP <- 0.4
base <- 0:5
P <- OBP^base * (1 - OBP)^(5 - base)
case <- choose(5, base)
EV <-P*case
barplot(EV, main="OBP=0.4 (34.56%)", ylab = "possibility")

# 출루율 5할 타자의 막대그래프
OBP <- 0.5
base <- 0:5
P <- OBP^base * (1 - OBP)^(5 - base)
case <- choose(5, base)
EV <-P*case
barplot(EV, main="OBP=0.5 (31.25%)", ylab = "possibility")

# 정규분포

### 중심극한정리

library(sand)
library(igraph)
g <- graph.formula(1-5, 1-7, 2-9, 2-4, 3-5, 4-5, 4-6, 4-7)
V(g)
E(g)
plot(g)


# 관측자료가 많은 경우 
# 2012 - 2015 시즌까지 
# 4년간 메이저리그에서 시즌 중 300타석 이상 들어섰던 
# 949명이 만들어낸 안타를 이용해 만든 히스토그램 
par(mfrow = c(1, 1))
a <- subset(Batting, yearID > 2011 & yearID < 2016 & AB >=300)
hist(a$H, main="949 players", breaks = seq(from=0, to=300, by=30))

# 관측자료가 적은 경우 
# 2012 - 2015 시즌까지 4년간
# 뉴욕 양키스를 대상으로 시즌 중 300타석 이상 들어섰던
# 선수 32명이 만들어낸 안타를 이용해 만든 히스토그램
a <- subset(Batting, yearID > 2011 & yearID < 2016 & AB >=300 & teamID == "NYA")
hist(a$H, main="32 players", breaks = seq(from=0, to=300, by=30))
