#import libraries
import pandas as pd
import numpy as np
import seaborn as sns
import scipy

#retrieving the data
dataset = pd.read_csv("lalonde.csv")
dataset.groupby('treat').mean()    
pd.set_option('display.max_columns', None)

# get a list of all contrinuous variables' names
continuous_confounders = ["age", "educ", "re74", "re75"]
  
# create an empty dictionary
t_test_results = {}

# loop over column_list and execute code explained above
for variable in continuous_confounders:
    group1 = dataset.where(dataset.treat== 0).dropna()[variable]
    group2 = dataset.where(dataset.treat== 1).dropna()[variable]
    t_test_results[variable] = scipy.stats.ttest_ind(group1,group2)
results = pd.DataFrame.from_dict(t_test_results,orient='Index')
results.columns = ['statistic','pvalue']

#isolating treatment and confounders
treat = dataset.iloc[:, 0]
confounders= dataset.iloc[:, 1:-1]

#logistic regression
import statsmodels.api as sm
confounders = sm.add_constant(confounders)
propensity_model = sm.Logit(treat, confounders).fit()
propensity_model.summary()

#predicting the propensity of being treated
propensity_score = propensity_model.predict(confounders)

#create dataframe with treated and propensities
propensity_dataframe = np.vstack([treat, propensity_score])
propensity_dataframe = np.transpose(propensity_dataframe)

#finish preparations for common support region
non_treated = propensity_dataframe[:,0] == 0
non_treated = propensity_dataframe[non_treated]
non_treated = non_treated[:, 1]
treated = propensity_dataframe[:,0] == 1
treated = propensity_dataframe[treated]
treated = treated[:, 1]

#Common support region
plot_non_treated = sns.kdeplot(non_treated, shade = True, color = "r")
plot_treated = sns.kdeplot(treated, shade = True, color = "b")

#isolating Y, treat and confounders
treat = dataset.iloc[:, 0].values
confounders= dataset.iloc[:, 1:-1].values
Y = dataset.iloc[:, -1].values

#import causal inference library
#pip install CausalInference
from causalinference import CausalModel
propensity_model = CausalModel(Y, treat, confounders)
propensity_model.est_propensity_s()
propensity_model.est_via_matching(bias_adj = True)
print(propensity_model.estimates)
print(propensity_model.propensity)




























