## Regression

- Predicting House Price
- Determining a Credit Card Score
- Predicting my Subscriber count by 2020

1. Input Variables: Covariates, Features, Independent Variables, Predictors

2. Output Variables: Response

## 2. Linear Regression

1. What is Parametric?
    - Fixed equation forms to relate y and X
    - y = f(X) + e
    - f(X) = $\beta_{0}$ + $\beta_{1}$ * X

2. Linear Regression Estimate
    - $\hat{y}$ = $\hat{f(X)}$
    - $\hat{y}$ = $\hat{\beta_0}$ + $\hat{\beta_1}$ * X

3. Linear Regression Actual Response
    - y = f(X) + e (Irreducible Error)

4. Residual Error
    - e = y - $\hat{y}$
    - Don't confuse residual error with irreducible error
    - e = $\beta_0$ + $\beta_1$ * X + 	$\epsilon$ - ($\hat{\beta_0}$ + $\hat{\beta_1}$ * X)
    - e = ($\beta_0$ - $\hat{\beta_0}$) + ($\beta_1$ - $\hat{\beta_1}$) * X + 	$\epsilon$

5. RSS (Sum of Squared Residuals)

    - {(${X_1}$, ${y_1}$), (${X_2}$, ${y_2}$), ... , (${X_n}$, ${y_n}$)}
    - Residual Error of Sample i:
        - ${e_i}$ = ${y_i}$ - $\hat{y_i}$
    - Sum of Squared Residuals
        - RSS = $\sum_{i=1}^{n} e_i^2$

6. Solve the Problem wrt ${\beta_0}$
    - $\underset{\beta_0, \beta_1}{\operatorname{argmin}}$  $\sum_{i=1}^{n} (y_i - \hat{y_i})^2$

    - $\underset{\beta_0, \beta_1}{\operatorname{argmin}}$  $\sum_{i=1}^{n} (y_i - (\hat{\beta_0} + \hat{\beta_1}X_i))^2$

    - $\underset{\beta_0, \beta_1}{\operatorname{argmin}}$  $\sum_{i=1}^{n} (y_i - \hat{\beta_0} - \hat{\beta_1}X_i))^2$

    - Differentiating wrt ${\beta_0}$

    - 2 $\sum_{i=1}^{n} (y_i - \hat{\beta_0} - \hat{\beta_1} X_i)(-1) = 0 $

    - $\hat{\beta_0}$ = ($\sum_{i=1}^{n} (y_i - \hat{\beta_1}X_i$) / n
    
    - $\hat{\beta_0}$ = ($\sum_{i=1}^{n} (y_i/n -  \hat{\beta_1}X_i/ n$) / n

    - $\hat{\beta_0}$ = $\sum_{i=1}^{n} (y_i/n)$ - ${\beta_1}$ $\sum_{i=1}^{n} (X_i / n)$

    - $\hat{\beta_0}$ = $\bar{y}$ - $\hat{\beta_1}$ $\bar{X}$

7. Solve the Problem wrt ${\beta_1}$

    - $\underset{\beta_0, \beta_1}{\operatorname{argmin}}$  $\sum_{i=1}^{n} (y_i - \hat{\beta_0} - \hat{\beta_1}X_i))^2$

    - Differentiating wrt ${\beta_1}$

    - 2 $\sum_{i=1}^{n} (y_i - \hat{\beta_0} - \hat{\beta_1} X_i)(-X_i) = 0 $

    - $\sum_{i=1}^{n} (y_i - \hat{\beta_0} - \hat{\beta_1} X_i)(X_i) = 0 $

    - $\sum_{i=1}^{n}X_iy_i - \hat{\beta_0} \sum_{i=1}^{n} X_i - \hat{\beta_1} \sum_{i=1}^{n} X_i^2 = 0$

    - $\sum_{i=1}^{n}X_iy_i - (\sum_{i=1}^{n}y_i / n - \hat{\beta_1} \sum_{i=1}^{n} X_i / n) \sum_{i=1}^{n}X_i - \hat{\beta_1} \sum_{i=1}^{n}X_i^2 = 0$

    -  $\sum_{i=1}^{n}X_iy_i - \sum_{i=1}^{n}y_i / n \sum_{i=1}^{n}X_i + \hat{\beta_1}\sum_{i=1}^{n} X_i / n \sum_{i=1}^{n}X_i - \hat{\beta_1}\sum_{i=1}^{n} X_i^2 = 0 $

    - $\hat{\beta_1} = (\sum_{i=1}^{n}X_i y_i - 1/n \sum_{i=1}^{n} y_i \sum{i=1}^{n}X_i) / (\sum_{i=1}^{n} X_i^2 - 1/n (\sum_{i=1}^{n} X_i)^2) $

    - $\hat{\beta_1} = (\sum_{i=1}^{n} X_i y_i - n \bar{X}\bar{y}) / (\sum_{i=1}^{n} X_i^2 - n \bar{X}^2)$

8. Least Squares Criteria

    - {($(X_1, y_1), (X_2, y_2), ..., (X_n, y_n)$)}
    - Least Squares Criteria
    - $\hat{\beta_0}$ = $\bar{y}$ - $\hat{\beta_1}$ $\bar{X}$
    - $\hat{\beta_1} = (\sum_{i=1}^{n} X_i y_i - n \bar{X}\bar{y}) / (\sum_{i=1}^{n} X_i^2 - n \bar{X}^2)$
    - $\hat{y} = \hat{\beta_0} + \hat{\beta_1} X$

## 3. Multiple Regression

1. General Parametric Equation
    - y = f(X) + $\epsilon$
    - ${f(X) = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + ... + \beta_p X_p}$

    - $\hat{y} = \hat{\beta_0} + \hat{\beta_1}X_1 + ... + \hat{\beta_p} X_p$

    - For n samples, number of operations = n * (p - 1)^2

2. Matrix Form

    - $y = \begin{bmatrix}y_1 \\
y_2 \\
.\\
.\\
.\\
y_n
\end{bmatrix}, X = \begin{bmatrix} 
1 & X_1,_1 & X_1,_2 &  . & . & X_1,_p \\
1 & X_2,_1 & X_2,_2 & . & . & . \\
1 & X_3,_1 & X_3,_2 & . & . & . \\
1 & . & . & . & . & . \\
1 & . & . & . & . & . \\
1 & X_n,_1 & X_n,_2 & . & . & X_n,_p\\
\end{bmatrix}, 
\beta = \begin{bmatrix}
\beta_0 \\
\beta_1 \\
\beta_2 \\
. \\
. \\
. \\
\beta_p \\
\end{bmatrix}$, $\epsilon = \begin{bmatrix}
\epsilon_0 \\
\epsilon_1 \\
\epsilon_2 \\
. \\
. \\
. \\
\epsilon_n \\
\end{bmatrix}$   

    - $y = X\beta + \epsilon$
    - $\hat{y} = X\hat{\beta}$ 

3. $y = X\beta + \epsilon$

    - $\begin{bmatrix}
y_1 \\ y_2 \\ y_3 \\ . \\ . \\ . \\ y_n
\end{bmatrix}  = \begin{bmatrix} 
    \beta_0 + \beta_1 X_1,_1 + \beta_2 X_1,_2 + ... + \beta_p X_1,_p + \epsilon_1
 \\
    \beta_0 + \beta_1 X_2,_1 + \beta_2 X_2,_2 + ... + \beta_p X_2,_p + \epsilon_2
 \\
    \beta_0 + \beta_1 X_3,_1 + \beta_2 X_3,_2 + ... + \beta_p X_3,_p + \epsilon_3
\\ .
\\ . 
\\
    \beta_0 + \beta_1 X_n,_1 + \beta_2 X_n,_2 + ... + \beta_p X_n,_p + \epsilon_n
\end{bmatrix}$

4. Residual Errors

    - $ e = \begin{bmatrix} 
    e_1 \\
    e_2 \\
    e_3 \\
    . \\
    . \\
    . \\
    e_n
\end{bmatrix} = 
\begin{bmatrix} 
y_1 - \hat{y_1} \\
y_2 - \hat{y_2} \\
y_3 - \hat{y_3} \\
. \\
. \\
. \\
y_n - \hat{y_n} \\
\end{bmatrix} = 
\begin{bmatrix}
y_1 \\
y_2 \\
y_3 \\
. \\
. \\
. \\
y_n \end{bmatrix} - 
\begin{bmatrix}
\hat{y_1} \\
\hat{y_2} \\
\hat{y_3} \\
. \\
. \\
. \\
\hat{y_n} \\
\end{bmatrix} = y - \hat{y}$
    - RSS = ${\sum_{i=1}^{n}e_i^2} = e^Te$
    - RSS = $(y - \hat{y})^T (y - \hat{y}) = (y - X\hat{\beta})^T(y-X\hat{\beta})$
    - RSS = ${(y^T - \hat{\beta}^TX^T)(y - X\hat{\beta})} = y^Ty - y^T X \beta - \beta X^T y + \hat{\beta}^T X^TX\hat{\beta}$ 

5. Matrix Differentiation

    - x = m * 1 matrix
    - A = n * m matrix; A ㅗ x

    - $ y = A \\-> \delta y / \delta x = 0 $
    - $ y = Ax \\-> \delta y / \delta x = A $
    - $ y = xA \\-> \delta y / \delta x = A^T $
    - $ y = x^TAx \\-> \delta y / \delta x = 2x^TA$

    - RSS = y^Ty - y^T X \beta - \beta X^T y + \hat{\beta}^T X^TX\hat{\beta}$ 

    - $\delta(RSS) \over \delta \hat{\beta}) $ = $\delta (y^Ty - y^T X \hat{\beta} - \hat{\beta}X^T y + \hat{\beta^T} X \hat{\beta}) \over \delta \hat{\beta}  $ $= 0$

    - $0 - y^T - (X^T y)^T + 2\hat{\beta}^T X^T X = 0 $

    - $ 2\hat{\beta}^T X^T X = 2 y^T X$
    - $ \hat{\beta}^T X^T X =  y^T X$
    - $ \hat{\beta}^T = y^TX(X^TX)^{-1}$
    - $ \hat{\beta} = (X^TX)^{-1}X^Ty$