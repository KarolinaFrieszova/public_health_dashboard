birth_weight %>%
  group_by(simd_code) %>%
  summarise(percentage_lbw = round((100*(sum(low_weight_births) / sum(all_births))), 2)) %>%
  ggscatter(x = "simd_code", y = "percentage_lbw", 
            add = "reg.line", conf.int = TRUE, 
            cor.coef = TRUE, cor.method = "pearson",
            xlab = "SIMD", ylab = "Low Weight Births")