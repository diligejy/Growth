library(autoReg)
library(survival)
library(survminer)
library(howto)
library(flextable)
library(ftExtra)
library(tidyverse)


install.packages("installr")
libary(installr)
check.for.updates.R()

.libPaths() 
data=subset(anderson, rx==0)

data$time
with(data, Surv(time, status))

# 평균 생존시간, 평균 위험률
# 중도절단된 자료들은 정확한 생존시간을 알 수 없으므로 실제 생존시간은 평균생존시간보다 김김
# 치료군(rx=0)에서 평균생존시간이 더 길고 평균위험률이 더 낮음
anderson %>% 
  group_by(rx) %>% 
  dplyr::summarise(T=mean(time), h=sum(status)/ sum(time))

# 치료군 대상으로 생존율 계산 
fit=survfit(Surv(time, status) ~1, data=data)
fit

summary(fit)

howto(fit) %>% 
  highlight(i=1, j=6, color="yellow") %>%
  highlight(i=2, j=c(2, 3, 5), color="yellow")


# 생존율 그래프
plot(fit)
median=fit$time[min(which(fit$surv<0.5))]
arrows(0, 0.5, median, 0.5, angle=15, col="red")
arrows(median, 0.5, median, 0, angle=15, col="red")
text(median, 0, median, pos=1, offset=0.1)

# survminer 패키지의 ggsruvplot
library(survminer)
ggsurvplot(fit, data=data)
