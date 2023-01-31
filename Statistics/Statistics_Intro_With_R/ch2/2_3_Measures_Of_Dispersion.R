data()
hist(faithful$waiting)

x <- stackloss$stack.loss
mean(x)
var(x)
sd(x)
s <- sort(x);s
length(x)
quantile(x, c(0.1, 0.25, 0.5, 0.95))
fivenum(x)
summary(x)
boxplot(x)
boxplot(x, range=0)
boxplot(x, range=1.5)
boxplot(x, range=1)
