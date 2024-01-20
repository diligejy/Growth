#pull the data
dataset <- read.csv("njmin3.csv")
summary(dataset)

#taking care of missing data
dataset$fte <- ifelse(is.na(dataset$fte),
                      mean(dataset$fte, na.rm = TRUE),
                      dataset$fte)
dataset$demp <- ifelse(is.na(dataset$demp),
                       mean(dataset$demp, na.rm = TRUE),
                      dataset$demp)
summary(dataset)

#create the first regression model
model1 <- lm(fte ~ NJ + POST_APRIL92 + NJ_POST_APRIL92,
             data = dataset)
summary(model1)

#create 2nd regression model
model2 <- lm(fte ~ NJ + POST_APRIL92 + NJ_POST_APRIL92 +
               bk + kfc + wendys,
             data = dataset)
summary(model2)

#Create third regression model
model3 <- lm(fte ~ NJ + POST_APRIL92 + NJ_POST_APRIL92 +
               bk + kfc + wendys +
               co_owned + centralj + southj,
             data = dataset)
summary(model3)

#visualize results
#install.packages("stargazer")
library(stargazer)
stargazer(model1, model2, model3,
          type = "text",
          title = "Impact of minimum wage on employment",
          no.space = TRUE,
          keep.stat = "n",
          digits = 2)









