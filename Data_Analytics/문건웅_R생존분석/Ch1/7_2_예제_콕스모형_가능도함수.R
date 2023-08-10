# 콕스 모형의 로그 가능도 함수 (가능도 함수를 로그 취한 것 )
pl <- function(beta){
  psi <- exp(beta)
  result <- log(psi) - log(2*psi + 2)- log(psi + 2)
  result
}

beta=seq(-2, 2, length.out=100)
plot(pl(beta) ~ beta, 
     type="l", 
     xlab="beta",
     ylab="log partial likelihood",
     cex.axis=1.5,
     cex.lab=1.5,
     lwd=2,
     col="black")

# 스코어 함수 (로그가능도 함수 미분)
scoref=function(beta){
  psi <- exp(beta)
  result = 1- psi/(psi+1)- psi/(psi+2)
  result
}

plot(scoref(beta) ~ beta,
     type="l",
     xlab="beta",
     ylab="score function",
     cex.axis=1.5,
     cex.lab=1.5,
     lwd=2,
     col="black")

result1 <- uniroot(f=scoref, interval=c(-5, 5), tol=.Machine$double.eps)
result1$root
