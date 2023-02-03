A <- c(79.98, 80.04, 80.02, 80.04, 80.03, 80.03, 80.04, 79.97,
       80.05, 80.03, 80.02, 80.00, 80.02) ;A

B <- c(80.02, 79.94, 79.98, 79.97, 79.97, 80.03, 79.95, 79.97);B

boxplot(A,B) 

# usual two-sample t-test
t.test(A,B, var.equal=T) 


#Welch's two sample t-test (assuming unequal variances)
t.test(A,B) 

#Welch's two sample t-test (assuming unequal variances)
t.test(A,B, var.equal=F) 

