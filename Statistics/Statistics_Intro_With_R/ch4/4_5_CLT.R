# 0부터 9까지 정수를 균일분포로 2,500개 생성
x <- floor(runif(2500, 0, 10));
x
hist(x)
mean(x)
sd(x)

# 2,500개의 정수를 크기가 5인 배열 생성성
y <- array(x, c(500, 5))

# 크기 5인 표본에서 표본 평균 구해서 500개의 표본평균 생성
xbar <- apply(y, 1, mean)
hist(xbar)
mean(xbar)
sd(xbar)
