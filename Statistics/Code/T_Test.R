# 1. 단일표본 T-Test (1-Sample T-Test)
sleep

x <- sleep[sleep$group == 1, c(3, 1)]
x

# 단측검정
test1 <- t.test(x$extra, alternative = 'greater')
test1

# 양측검정
test2 <- t.test(x$extra, alternative = 'two.side')
test2

# 정규성 테스트
shapiro.test(x$extra)
hist(x$extra)

# 2. 독립표본 T-Test

A <- sleep[1:10, 1]
B <- sleep[11:20, 1]
x <- data.frame(n=1:10, A, B)
x

# 등분산성
var.test(A, B)
test3 <- t.test(x$A, x$B, paired=F, alternative = "less"
                , var.equal = T)
test3
