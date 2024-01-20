#importing libraries
import numpy as np
import pandas as pd

#pull the data
dataset = pd.read_stata("eitc.dta")

#preparing dummy variables
dataset['post93'] = np.where(dataset['year'] > 1993, 1, 0)
dataset['mom'] = np.where(dataset['children'] > 0, 1, 0)
dataset['mom_post93'] = dataset['mom'] * dataset['post93']

#Isolate X and Y variables
Y = dataset.loc[:, 'work'].values
X = dataset.loc[:, ['post93', 'mom', 'mom_post93']].values

#Do logistic regression
import statsmodels.api as sm
X = sm.add_constant(X)
model1 = sm.Logit(Y, X).fit()
model1.summary(yname = "Work",
               xname = ("intercept", "After 1993", "Is mom",
                        "Mom after 1993"),
               title = "Impact of tax credit on employment - model1")

#Isolate X and Y variables part 2
X = dataset.loc[:, ['post93', 'mom', 'mom_post93',
                    'nonwhite','ed']].values

#Do logistic regression
import statsmodels.api as sm
X = sm.add_constant(X)
model2 = sm.Logit(Y, X).fit()
model2.summary(yname = "Work",
               xname = ("intercept", "After 1993", "Is mom",
                        "Mom after 1993", "Hispanic or Black",
                        "Years of education"),
               title = "Impact of tax credit on employment - model2")

#preparing dummy variables for placebo experiment
dataset['post92'] = np.where(dataset['year'] > 1992, 1, 0)
dataset['mom_post92'] = dataset['mom'] * dataset['post92']

#prepare placebo dataset
dataset_placebo = dataset[dataset['year'] < 1994]

#Isolate X and Y variables for placebo experiment
Y_placebo = dataset_placebo.loc[:, 'work'].values
X_placebo = dataset_placebo.loc[:, ['post92', 'mom', 'mom_post92']].values

#Do logistic regression
import statsmodels.api as sm
X_placebo = sm.add_constant(X_placebo)
model_placebo = sm.Logit(Y_placebo, X_placebo).fit()
model_placebo.summary(yname = "Work",
               xname = ("intercept", "After 1992", "Is mom",
                        "Mom after 1992"),
               title = "Impact of tax credit on employment - model placebo")








































