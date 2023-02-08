name <- c("Marte", "Harrison", "Freese", "Jaso", 
          "Cervelli", "Polanco", "McCutchen", "Mercer", "Kang")
HR <- c(9, 4, 13, 8, 1, 22, 24, 11, 21)
AVG <- c(0.311, 0.283, 0.27, 0.268, 0.264, 0.258, 0.256, 0.256, 0.255)
pit <- cbind(name, HR, AVG)
pit

# 데이터 중심화 경향
mean(AVG)
median(AVG)

# 필리스 홈런 변수
HR <- c(23, 14, 13, 12, 12, 9, 8, 7, 7, 5, 5, 5, 2, 1, 1)
summary(HR)
var(HR)
sqrt(var(HR))
