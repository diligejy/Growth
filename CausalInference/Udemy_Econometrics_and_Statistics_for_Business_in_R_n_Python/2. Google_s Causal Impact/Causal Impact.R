#define pre and post period dates
start = "2016-01-01"
treatment = "2018-03-17"
end = "2018-07-17"

#retrieve data
#install.packages("tseries")
library(tseries)
Facebook <- get.hist.quote(instrument = "FB",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
Walmart <- get.hist.quote(instrument = "WMT",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
Disney <- get.hist.quote(instrument = "DIS",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
BMW <- get.hist.quote(instrument = "BMW.DE",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
Novartis <- get.hist.quote(instrument = "NVS",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
Goldman_sachs <- get.hist.quote(instrument = "GS",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
GE <- get.hist.quote(instrument = "GE",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
Heinz <- get.hist.quote(instrument = "KHC",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
McDonalds <- get.hist.quote(instrument = "MCD",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")
Carlsberg <- get.hist.quote(instrument = "CARL-B.CO",
                           start = start,
                           end = end,
                           quote = "Close",
                           compression = "w")


#plotting data
series <- cbind(Facebook, Walmart, Disney, BMW, Novartis, Goldman_sachs,
                GE, Heinz, McDonalds, Carlsberg)
series <- na.omit(series)
#install.packages("ggplot2")
library(ggplot2)
autoplot(series, facet = NULL) + xlab("time") + ylab("Price Close")

#correlation check
dataset_cor <- window(series, start = start, end = treatment)
dataset_cor <- as.data.frame(dataset_cor)
cor(dataset_cor)

#selecting the final dataset
final_series <- cbind(Facebook, Walmart, Goldman_sachs, McDonalds, Carlsberg)
final_series <- na.omit(final_series)

#Create pre and post period objects
pre.period <- as.Date(c(start, treatment))
post.period <- as.Date(c(treatment, end))

#Running Causal Impact
#install.packages("CausalImpact")
library(CausalImpact)
impact <- CausalImpact(data = final_series,
                       pre.period = pre.period,
                       post.period = post.period,
                       model.args = list(niter = 2000,
                                         nseasons = 52))

#Visualize results
plot(impact)
summary(impact)
summary(impact, "report")



























