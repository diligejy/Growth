version$version.string


# Variables that fully define the A/B test results
t = 20 # Total number of subjects (A + B)
a = 10 # Number of subjects in group A 
b = 10 # Number of subjects in group B 
a_yes = 7 # Yes count in group A 
b_yes = 4 # Yes count in group B 

# Compute remaining A/B test results
t_yes = a_yes + b_yes # Total Yes count
t_no = t - t_yes # Total No count 
a_yes_pc = 100 * a_yes / a # Yes percentage in A 
b_yes_pc = 100 * b_yes / b # Yes percentage in B

# A/B Test statistic: Yes percentage difference (A - B)
ab_yes_pc = a_yes_pc - b_yes_pc

cat("Observed Yes Rate (%): A:", a_yes_pc,
    ', B:', b_yes_pc, ', A-B:', ab_yes_pc,
    '\nTotal counts: Yes:', t_yes, ', No:', t_no)

set.seed(0) # for reproducible results
bag1 = c(rep(1, t_yes), rep(0, t_no)) # S1: All results bag
bag2 = sample(bag1)                   # S2: Shuffle bag
a_rs = bag2[1:a]                      # S3: Random sample A
b_rs = bag2[(a+1):(a+b)]              # S4: Random sample B 

# Step 5 : Compute the test statistic
a_yes_pc_rs = 100 * sum(a_rs) / a 
b_yes_pc_rs = 100 * sum(b_rs) / b 

cat('(1) Bag               :', bag1,
    '\n(2) Bag Shuffled    :', bag2,
    '\n(3) A resample      :', a_rs,
    '\n(4) B resample      :', rep(' ', a), b_rs,
    '\n(5) Resample Yes Rate(%): A:', a_yes_pc_rs, ', B:', b_yes_pc_rs, ', A-B:', a_yes_pc_rs - b_yes_pc_rs, 
    '\n(0) Observed Yes Rate(%): A:', a_yes_pc, ', B:', b_yes_pc, ', A-B:', a_yes_pc - b_yes_pc)

set.seed(1) # for reproducible results 
bag = c(rep(1, t_yes), rep(0, t_no)) # S1: All results bag 

# Step 6: Repeat steps 2 to 5 a "Large" number of times (p)
p = 100 # number of permutations 
perm_res = rep(0, p) # Vector for permutation results 

for (i in 1:p){
  bag = sample(bag)       # S2: Shuffle the bag 
  a_rs = bag[1:a]         # S3: Random sample A
  b_rs = bag[(a+1):(a+b)] # S4: Random Sample B 
  # Step 5 : Compute the test statistic
  perm_res[i] = 100 * sum(a_rs) / a - 100 * sum(b_rs) / b 
}

# Print results 
options(width = 60);
print(perm_res)

table(perm_res)

# Two-way hypothesis test (Null : A = B, Alternative: A != B)
extreme_count = sum(abs(perm_res) >= abs(ab_yes_pc))

# One-way hypothesis test (Null : A <= B, Alternative : A > B)
pos_extreme_count = sum(perm_res >= ab_yes_pc)

cat("Number of permutations:", p,
    '\nTwo-way: Extreme count             :', extreme_count,
    '\nTwo-way: Extreme ratio (p--value)  :', extreme_count / p,
    '\nOne-way: Extreme count             :', pos_extreme_count,
    '\nOne-way: Extreme ratio (p-value)   :', pos_extreme_count / p)



# -- ab_permutation_test function 만들기
ab_permutation_test <- function(p, a_all, b_all, a_yes, b_yes, n_p){
  t = a_all + b_all
  t_yes = a_yes + b_yes # Total Yes count
  t_no = t - t_yes # Total No count 
  a_yes_pc = 100 * a_yes / a_all # Yes percentage in A 
  b_yes_pc = 100 * b_yes / b_all # Yes percentage in B
  # A/B Test statistic: Yes percentage difference (A - B)
  ab_yes_pc = a_yes_pc - b_yes_pc

  cat('## Observed Yes Rate(%): A:',  a_yes_pc, ', B:', b_yes_pc, ', A-B:', a_yes_pc - b_yes_pc)

  set.seed(0) # for reproducible results
  bag1 = c(rep(1, t_yes), rep(0, t_no)) # S1: All results bag
  bag2 = sample(bag1)                   # S2: Shuffle bag
  a_rs = bag2[1:a_all]                      # S3: Random sample A
  b_rs = bag2[(a_all+1):(a_all+b_all)]              # S4: Random sample B 
  
  # Step 5 : Compute the test statistic
  a_yes_pc_rs = 100 * sum(a_rs) / a_all
  b_yes_pc_rs = 100 * sum(b_rs) / b_all
  
  set.seed(1) # for reproducible results 
  bag = c(rep(1, t_yes), rep(0, t_no)) # S1: All results bag 
  
  # Step 6: Repeat steps 2 to 5 a "Large" number of times (p)
  perm_res = rep(0, p) # Vector for permutation results 
  
  for (i in 1:p){
    bag = sample(bag)       # S2: Shuffle the bag 
    a_rs = bag[1:a_all]         # S3: Random sample A
    b_rs = bag[(a_all+1):(a_all+b_all)] # S4: Random Sample B 
    # Step 5 : Compute the test statistic
    perm_res[i] = 100 * sum(a_rs) / a_all - 100 * sum(b_rs) / b_all 
  }
  
  
  perm_res
  table(perm_res)
  
  # Two-way hypothesis test (Null : A = B, Alternative: A != B)
  extreme_count = sum(abs(perm_res) >= abs(ab_yes_pc))
  
  # One-way hypothesis test (Null : A <= B, Alternative : A > B)
  pos_extreme_count = sum(perm_res >= ab_yes_pc)

  x=seq(-4,4,length=200)
  x
  y=dnorm(x)
  plot(x,y,type="l", lwd=2
       , xlab=paste('A/B Test Statistic : A - B (%)', '\n (observed :', ab_yes_pc, '%)')
       , main=paste('Perm =', p, ', Extreme count =', extreme_count, 'P-value = ', extreme_count / p), col="blue")
  if (ab_yes_pc < 0){
    abline(v=c(ab_yes_pc, abs(ab_yes_pc)), col=c("red", "red"), lty=c(1, 2), lwd=c(3,3))
  } else {
    abline(v=c(-ab_yes_pc, ab_yes_pc), col=c("red", "red"), lty=c(1, 2), lwd=c(3,3))
  }
}



p = 10000
a_all = 1000
b_all = 2000
a_yes = 30
b_yes = 100
n_p = 1000

ab_permutation_test(p, a_all, b_all, a_yes, b_yes, n_p)




