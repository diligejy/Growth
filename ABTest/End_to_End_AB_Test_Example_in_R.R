install.packages("pwr")
library(pwr)

control =0.101
uplift = .2
variant = (1 + uplift) * control
effect_size <- ES.h(control, variant)
sample_size_output <- pwr.p.test(h = effect_size,
                                 n = ,
                                 sig.level = 0.05,
                                 power = 0.8)

sample_size_output <- ceiling(sample_size_output$n)
sample_size_output #1896
