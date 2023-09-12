## 1. The Bayesian Approach

- "Everything is random"
- More precisely, "Everything is a random variable"
- Ex. Suppose we want to model the height of students in our class as a Gaussian. We thus must find its mean and variance
- How?
- We don't solve for $\mu, \sigma^2$
- Instead, we find p($\mu, \sigma^2 | X$)
- We don't find a "number", we find a "distribution"

## 2. The Frequentist Approach

1. Collect data

    - $Data : X = \{x_1, x_2, ..., x_N\}$

2. Write down likelihood

    - $Likelihood : L =\prod f(x;\mu, \sigma^2) $

3. Maximize likelihood wrt params
    - $\mu, \sigma^2 = argmaxL$


## 3. Sampling

- If you go the statistics route, you will spend a lot of time on sampling methods
- Importance sampling, MCMC, Gibbs, etc.
- Main idea: numerical approximation of an integral