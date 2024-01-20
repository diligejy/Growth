#importing the libraries
import pandas as pd
from matplotlib import pyplot

#import the dataset
dataset = pd.read_csv("chicken_egg.csv")

#isolating eggs and chickens
eggs = dataset.loc[:, 'egg']
chickens = dataset.loc[:, 'chicken']

#visualize eggs
eggs.plot()
pyplot.show()

#visualize chickens
chickens.plot()
pyplot.show()

#check stationarity for eggs
from statsmodels.tsa.stattools import adfuller
stationarity_eggs = adfuller(eggs)
stationarity_eggs
print('Augment Dickez Fuller p-value: %F' % stationarity_eggs[1])

#check stationarity for chickens
stationarity_chickens = adfuller(chickens)
stationarity_chickens
print('Augment Dickez Fuller p-value: %F' % stationarity_chickens[1])

#making data stationary
deggs = eggs - eggs.shift(1)
deggs = deggs.dropna()
dchickens = chickens - chickens.shift(1)
dchickens = dchickens.dropna()

#check stationarity 
stationarity_deggs = adfuller(deggs)
print('p-value: %F' % stationarity_deggs[1])
stationarity_dchickens = adfuller(dchickens)
print('p-value: %F' % stationarity_dchickens[1])

#transforming series into dataframes
deggs = pd.DataFrame(deggs)
dchickens = pd.DataFrame(dchickens)

#creating two dataframes
dataset_chicken = pd.concat([dchickens, deggs], axis = 1)
dataset_eggs = pd.concat([deggs, dchickens], axis = 1)

#do granger causality test
from statsmodels.tsa.stattools import grangercausalitytests
grangertest_chickens = grangercausalitytests(dataset_chicken, 15)
grangertest_eggs = grangercausalitytests(dataset_eggs, 15)































































