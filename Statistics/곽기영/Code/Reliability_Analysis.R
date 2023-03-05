library(psych)
str(sat.act)

ability <- sat.act[c("ACT", "SATV", "SATQ")]
head(ability)

alpha(ability)

alpha(ability[c(2, 3)])
