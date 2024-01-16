library(Lahman)
a <- subset(Batting, yearID == 2014)
b <- subset(Batting, yearID == 2015)
c <- merge(a, b, by = "playerID")

d <- c[c$AB.x > 10 & c$AB.y > 10, ]
# d <- with(c, c[AB.x > 10 & AB.y > 10, ])
d

# 2014년 홈런과 2015년 홈런 간의 상관관계
with(d, cor(HR.x, HR.y))

# 2014년 타율과 15년 타율의 상관관계
with(d, cor(H.x/AB.x, H.y/AB.y))
