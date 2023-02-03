
x <- c(70, 80, 72, 76, 76, 76, 72, 78, 82, 64, 74, 92, 74, 68, 84)
y <- c(68, 72, 62, 70, 58, 66, 68, 52, 64, 72, 74, 60, 74, 72, 74)

# Method I
t.test (x,y, paired=T, conf.level=0.95)

#Method II
d <- x-y
t.test(d)
