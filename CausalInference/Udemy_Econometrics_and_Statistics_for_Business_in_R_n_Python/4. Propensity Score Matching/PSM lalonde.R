#loading dataset
#install.packages("MatchIt")
library(MatchIt)
dataset <- lalonde

#looking at the income average in 78
#install.packages("dplyr")
library(dplyr)
dataset %>%
  group_by(treat) %>%
  summarise(mean_income_78 = mean(re78))

#looking at averages of the confounders
confounders <- c("re74", "re75", "age", "educ", "black", "hispan", "married",
                 "nodegree")
dataset %>%
  group_by(treat) %>%
  select(one_of(confounders)) %>%
  summarise_all(list(~ mean(., na.rm = TRUE)))

#t test the continuous confounders
continuous_confounders <- c("re74", "re75", "age", "educ")
t.test(dataset$re74 ~ dataset$treat)
t.test(dataset[, 're74'] ~ dataset[, 'treat'])
lapply(continuous_confounders, function(variable){
  t.test(dataset[, variable] ~ dataset[, 'treat'])})

#create model to compute propensities
model_propensity <- glm(treat ~ re74 + re75 + age + educ +
                          black + hispan + married + nodegree,
                        family = "binomial",
                        data = dataset)
summary(model_propensity)

#create dataframe for common support region
propensity_scores <- predict(model_propensity, type = "response")
propensity_dataframe <- data.frame(propensity_score = propensity_scores,
                                   treat = model_propensity$model$treat)

#visualizing common support region
#install.packages("ggplot2")
library(ggplot2)
propensity_dataframe %>%
  ggplot(aes(x = propensity_score)) +
  facet_wrap(~ treat) + 
  geom_histogram() +
  xlab("Propensity score")

#matching
matching <- matchit(treat ~ re74 + re75 + age + educ +
                      black + hispan + married + nodegree,
                    data = dataset,
                    method = "nearest",
                    replace = TRUE,
                    discard = "both")
summary(matching)

#create dataframe with just matched data
matched_data <- match.data(matching)

#looking at averages of the confounders in the matched dataset
matched_data %>%
  group_by(treat) %>%
  select(one_of(confounders)) %>%
  summarise_all(list(~ mean(., na.rm = TRUE)))

#t test the continuous confounders in the matched dataset
lapply(continuous_confounders, function(variable){
  t.test(matched_data[, variable] ~ matched_data[, 'treat'])})

#checking impact of the training in the income of 78
impact_training <- lm(re78 ~ treat + re74 + re75 + age + educ +
                        black + hispan + married + nodegree, 
                      data = matched_data)
summary(impact_training)

























