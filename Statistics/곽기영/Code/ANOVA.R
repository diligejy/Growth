str(InsectSprays)

sprays.aov <- aov(count ~ spray, data=InsectSprays)
summary(sprays.aov)

# 정규성 검정1 - 정규 QQPlot
library(car)
qqPlot(sprays.aov$residuals, distribution="norm", 
       pch=20, col="tomato", id=FALSE, 
       main="Q-Q Plot",
       xlab="Theoretical Quantiles", ylab="Residual")

# 정규성 검정2 - 샤피로 윌크 검정
shapiro.test(residuals(sprays.aov))

# 이상점 존재 여부 - Bonferroni p가 유의수준 0.05보다 크므로 우려할 만한 점이 없다고 판단
outlierTest(sprays.aov)

# 등분산성 검정 - Levene, bartlett Test - 집단간의 분산이 동일하다는 귀무가설 검정 
leveneTest(count ~spray, data=InsectSprays)
bartlett.test(count ~ spray, data=InsectSprays)

# 등분산성 충족하지 않을 경우 AOV 대신 oneway test
oneway.test(count ~ spray, data=InsectSprays)

# 등분산성 충족할 경우 
oneway.test(count ~ spray, data=InsectSprays, var.equal = TRUE)
