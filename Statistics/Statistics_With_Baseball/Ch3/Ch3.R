library(Lahman)
a <- subset(Batting, yearID == 2014)
b <- subset(Batting, yearID == 2015)
c <- merge(a, b, by = "playerID")

d <- c[c$AB.x > 10 & c$AB.y > 10, ]
# d <- with(c, c[AB.x > 10 & AB.y > 10, ])


# 2014년 홈런과 2015년 홈런 간의 상관관계
with(d, cor(HR.x, HR.y))

# 2014년 타율과 15년 타율의 상관관계
with(d, cor(H.x/AB.x, H.y/AB.y))

# 2015, 2016 
library(Lahman)
library(dplyr)
library(plyr)

head(Batting)
data <- subset(Batting, yearID > 2014 & yearID < 2017)
data$teamID <- as.character(data$teamID)
data$playerID <- as.character(data$playerID)
a <- arrange(data, playerID, yearID)

head(a)

a$p_teamID <- as.character(sapply(1:nrow(a), function(x){a$teamID[x-1]}))
a$p_playerID <- as.character(sapply(1:nrow(a), function(x){a$playerID[x-1]}))
a$p_RBI <- as.numeric(sapply(1:nrow(a), function(x){a$RBI[x-1]}))
a$p_AB <- as.numeric(sapply(1:nrow(a), function(x){a$AB[x-1]}))
a$p_SF <- as.numeric(sapply(1:nrow(a), function(x){a$SF[x-1]}))
a$p_SH <- as.numeric(sapply(1:nrow(a), function(x){a$SH[x-1]}))
a$p_H <- as.numeric(sapply(1:nrow(a), function(x){a$H[x-1]}))
a$same_person <- ifelse(a$playerID == a$p_playerID, "same", "different")
b <- a[a$same_person == "same",]
b$moved <- ifelse(b$teamID==b$p_teamID, "no", "yes")

# 전년도 타율이 이적 후 새로운 팀에서 높은 성적으로 연결되는지 확인하는 데 목적이 있으므로 이직 사실 있는 선수만
c <- b[b$moved=="yes", ]
head(c)

c$p_avg <- with(c, p_H/p_AB)
# SF : Sacrifice Fly, SH : Sacrifice Hit
c$sac <- with(c, p_SF + p_SH)
# 2015, 2016 시즌 모두 400타수를 초과한 선수들의 데이터만 사용
# 타석 수가 적은 선수의 경우 기대를 받고 스카웃 되었다기보다는 그 반대일 가능성이 높아서 배제
d <- subset(c, AB > 400 & p_AB > 400)
d$change_rbi <- with(d, RBI/p_RBI)
d

with(d, cor(p_avg, change_rbi))

library(ggplot2)
ggplot(d, aes(p_avg, change_rbi, lgID)) + geom_point(size=2, aes(shape=lgID)) + 
    annotate("text", x = 0.3, y = 1.6, label="r=-0.49", size=5) + 
    stat_smooth(method="lm", col="black") + 
    labs(x="Batting Average of Prior Year", y = "Change in RBI")

# 아메리칸 리그, 내셔널 리그 각각에서 독립적으로 상관성 분석 시행
ggplot(d, aes(p_avg, change_rbi)) + geom_point(size=2) + 
    stat_smooth(method="lm", col="black") + facet_wrap(~d$lgID) + 
    labs(x="Batting Average of Prior Year", y="Change in RBI")

# 전년도에 희생번트와 희생타를 많이 친 선수들이 새 구단으로 이적 후 첫 연도에 만들어낸 타점 상관관계
with(d, cor(sac, change_rbi))

ggplot(d, aes(sac, change_rbi, lgID)) + geom_point(size=2, aes(shape=lgID)) + 
    annotate("text", x=4, y=1.6, label="r=0.50", size=5) + 
    stat_smooth(method="lm", col="black") + 
    labs(x="Sacrifice Flies & Hits", y="Change in RBI")

# 간단한 상관관계표
library(tableHTML)
e <- with(d, data.frame(change_rbi, sac, p_avg))
colnames(e) <- c("c_RBI", "Sacrifice", "AVG")
cor(e)
tableHTML(round(cor(e), 3))

# 연관성 분석
library(Lahman)
a <- subset(Batting, yearID > 2010 & yearID < 2016, select=c(playerID, teamID))
a$teamID <- factor(a$teamID)
a$teamID <- as.character(a$teamID)

library(data.table)
# 2개의 열로 준비된 데이터에서 동일한 playerID를 갖는 소속팀 정보를 동일한 하나의 행으로 변경하는 작업 -> dcast()로 함
move <- dcast(setDT(a)[, idx :=1:.N, by=playerID],
        playerID~idx, value.var=c("teamID"))

move[,1] <-NULL
move

write.csv(move, file="move.csv")

# transaction 데이터 형태로 읽을 때 필요한 명령어 read.transactions()
# association rule을 밝혀내는 데 필요한 형태로 인식
library(arules)
move <- read.transactions("move.csv", sep=",")
summary(move)

itemFrequencyPlot(move, support=0.01, cex.names=0.6)

# 선수들의 팀 간 이동 패턴
pattern <- apriori(move, list(support=0.0015, confidence=0.50, minlen=2))
summary(inspect(pattern))

# 네트워크 분석
library(Lahman)
library(stringr)

a <- subset(Pitching, yearID > 2014 & yearID < 2017 & G > 35, select=c("playerID", "yearID", "teamID"))
a$yearID <- str_remove(a$yearID, '20')
a$teamyear <- paste(a$teamID, a$yearID, sep="")
b <- subset(Managers, yearID > 2014 & yearID < 2017, select=c("playerID", "yearID", "teamID"))
b$yearID <- str_remove(b$yearID, '20')
b$teamyear <- paste(b$teamID, b$yearID, sep="")
c <- merge(a, b, by="teamyear")
d <- subset(c, select=c("playerID.x", "playerID.y"))
colnames(d) <- c("pitcher_ID", "manager_ID")

library(igraph)
mlb_network <- graph.data.frame(d, directed=FALSE)
V(mlb_network)$label <- ifelse(V(mlb_network)$name %in% c(b$playerID) > 0,
                                as.character(b$teamyear), NA)
manager <- V(mlb_network)$name %in% c(b$playerID) + 1
plot(mlb_network, vertex.shapes="none", vertex.label.cex=1.5, vertex.label.color="black",
        vertex.label.font=2, vertex.label.dist=1,
        vertex.size=c(3,0)[manager], vertex.color=c("gray", "white")[manager])

# 히스토그램은 막대그래프가 아니다
library(Lahman)
a <- subset(Teams, yearID==2015)
b <- barplot(a$HR)
text(b, par("usr")[3], labels=a$team, srt=60, adj=c(1, 0.5), xpd=TRUE)

# 데릭 지터(전설적 타자) 데이터
a <- subset(Batting, playerID=="jeterde01")
# hist(분석 대상 변수의 위치, x축 이름, 차트의 제목, 차트의 눈금 숫자에 대한 방향 조절)
hist(a$HR, xlab="Homerun", main="Histogram of Jeter's HR", las=1)
hist(a$HR, xlab="Homerun", main="Histogram of Jeter's HR", las=1, breaks=seq(from=0, to=27, by=3))
