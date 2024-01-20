#pull the data
#install.packages("haven")
library(haven)
dataset <- read_dta("eitc.dta")

#Create dummy variables
dataset$post93 <- ifelse(dataset$year > 1993, 1, 0)
dataset$mom <- ifelse(dataset$children > 0, 1, 0)
dataset$mom_post93 <- dataset$post93 * dataset$mom

#Creating first logistic regression model
model1 <- glm(work ~ post93 + mom + mom_post93,
              family = 'binomial',
              data = dataset)
summary(model1)

#Second logistic regression model
model2 <- glm(work ~ post93 + mom + mom_post93
              + nonwhite + ed,
              family = 'binomial',
              data = dataset)
summary(model2)

#visualize regression results
#install.packages("stargazer")
library(stargazer)
stargazer(model1, model2,
          type = "text",
          align = TRUE,
          covariate.labels = c("After 1993", "Is mom", "Is mom after 1993",
                               "Hispanic or white", "Years of education"
                               ),
          digits = 2,
          no.space = TRUE)

#create placebo variables
dataset$post92 <- ifelse(dataset$year > 1992, 1, 0)
dataset$mom_post92 <- dataset$post92 * dataset$mom

#create placebo dataset
dataset_placebo <- subset(dataset, dataset$year < 1994)

#Create logistic regression for placebo experiment
#Creating first logistic regression model
model_placebo <- glm(work ~ post92 + mom + mom_post92,
              family = 'binomial',
              data = dataset_placebo)
summary(model_placebo)











