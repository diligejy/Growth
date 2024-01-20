#load the data
#install.packages("modeldata")
library(modeldata)
data("attrition")


#look at data structure
str(attrition)

#summary statistics
summary(attrition)

#create data set with only factors
#install.packages("dplyr")
library(dplyr)
dataset1 <- attrition %>% select_if(is.factor)

#apply CHAID
#install.packages("CHAID", repos = "http://R-Forge.R-project.org")
library(CHAID)
control <- chaid_control(maxheight = 4,
                         minbucket = 30)
model1 <- chaid(Attrition ~ .,
                data = dataset1,
                control = control)

#plot the CHAID model
plot(model1,
     main = "First CHAID model",
     gp = gpar(fontsize = 9,
               color = "black"))

#chi-square test
chisq.test(dataset1$OverTime, dataset1$Attrition)

#checking accuracy
#install.packages("caret")
library(caret)
predictions <- predict(model1)
confusionMatrix(predictions, dataset1$Attrition)

#Ranking of the drivers
sort(varimp(model1), decreasing = TRUE)

#function to check variables with few unique values
attrition %>% 
  select_if(function(col) length(unique(col)) <= 5 & is.integer(col)) %>%
  ncol
attrition %>% 
  select_if(function(col) length(unique(col)) <= 10 & is.integer(col)) 

#transform into factors
attrition <- attrition %>% mutate_if(function(col) length(unique(col)) <= 10
                                     & is.integer(col), as.factor)
str(attrition)

#create data set with only factors
dataset2 <- attrition %>% select_if(is.factor)

#apply CHAID
model2 <- chaid(Attrition ~ .,
                data = dataset2,
                control = control)

#plot the CHAID model
plot(model2,
     main = "First CHAID model",
     gp = gpar(fontsize = 9,
               color = "black"))

#chi-square test
chisq.test(dataset2$StockOptionLevel, dataset1$Attrition)

#checking accuracy
predictions2 <- predict(model2)
confusionMatrix(predictions2, dataset2$Attrition)

#Ranking of the drivers
sort(varimp(model2), decreasing = TRUE)

#visualize numerical variables
#install.packages("ggplot2")
#install.packages("tidyr")
library(ggplot2)
library(tidyr)
attrition %>%
  select_if(is.numeric) %>%
  gather(metric, value) %>%
  ggplot(aes(value, fill = metric)) +
  geom_density(show.legend = FALSE) +
  facet_wrap(~ metric, scales = "free")

#transforming Years since last promo variables
attrition$YearsSinceLastPromotion <- cut(attrition$YearsSinceLastPromotion,
                                         breaks = c(-1, 0.9, 1.9, 2.9, 16),
                                         labels = c("less than 1 year", 
                                                    "1 year", "2years",
                                                    "more than 2 years"))

#transforming remaining variables into factors
attrition <- attrition %>% mutate_if(is.numeric, funs(cut_number(., n= 5)))
str(attrition)

########################################################

#apply CHAID
model3 <- chaid(Attrition ~ .,
                data = attrition,
                control = control)

#plot the CHAID model
plot(model3,
     main = "Third CHAID model",
     gp = gpar(fontsize = 9,
               color = "black"))

#chi-square test
chisq.test(attrition$YearsAtCompany, attrition$Attrition)

#checking accuracy
predictions3 <- predict(model3)
confusionMatrix(predictions3, attrition$Attrition)

#Ranking of the drivers
sort(varimp(model3), decreasing = TRUE)





