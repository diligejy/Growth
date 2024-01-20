#pull the data
#install.packages("lmtest")
library(lmtest)
dataset <- as.data.frame(ChickEgg)

#tranform data into time series
eggs <- ts(dataset$egg)
chickens <- ts(dataset$chicken)

#plotting time series
#install.packages("ggplot2")
library(ggplot2)
plot.ts(eggs)
plot.ts(chickens)

#Stationarity check
#install.packages("forecast")
library(forecast)
ndiffs(eggs, alpha = 0.05, test = c("kpss"))
ndiffs(chickens, alpha = 0.05, test = c("kpss"))

#make data stationary
deggs <- diff(eggs)
dchickens <- diff(chickens)

#plotting time series
plot.ts(deggs)
plot.ts(dchickens)

#Do granger causality
grangertest(deggs, dchickens, 4)
grangertest(dchickens, deggs, 4)

#start looping process
lags <- 1:15
results <- matrix(ncol = 2, nrow = length(lags))

#start looping
for (i in 1:length(lags)){
  test1 <- grangertest(deggs, dchickens, i)
  result1 <- test1$`Pr(>F)`[2]
  test2 <- grangertest(dchickens, deggs, i)
  result2 <- test2$`Pr(>F)`[2]  
  
  results[i,1] <- result1
  results[i,2] <- result2
  
}














