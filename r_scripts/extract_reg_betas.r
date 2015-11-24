library(ggplot2)
cluster_list <- c(1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28)
reg_list <- c("LSRS", "LSRF", "LSIS", "LSIF", "LYRS", "LYRF", "LYIS", "LYIF", 
             "LNRS", "LNRF", "LNIS", "LNIF")

for (i in 1:length(cluster_list)){
  infile = paste("/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn/RUcovforreg", 
                      toString(cluster_list[i]), ".csv", sep='')
  RUcovforreg <- read.csv(infile, header=F)
  RUcovforreg$V1 <- factor(RUcovforreg$V1, levels = 
            c('7404', '7408', '7412', '7414', '7418', '7430', '7432',
              '7436', '7443', '7453', '7458', '7474', '7477', '7478', '7480',
              '7498', '7508', '7521', '7533', '7534', '7542', '7558', '7561',
              '7562', '7575', '7580', '7607', '7613', '7619', '7623', '7638',
              '7641', '7645', '7648', '7649', '7659', '7714', '7719', '7726'))
  reg = list()
  lm = list()
  b = list()
  for (j in 1:length(reg_list)){
    len <- length(subset(RUcovforreg, RUcovforreg$V2 == reg_list[j]))
    reg[[j]] <- subset(RUcovforreg, RUcovforreg$V2 == reg_list[j])
    lm[[j]] <-lm(reg[[j]]$V4 ~ reg[[j]]$V3 + reg[[j]]$V1)
    b[[j]] <- lm[[j]]$coefficients[2]
  }
  #what do I want?  I want a matrix with regressors as row names and a single column, b
  # that has 
  b_mat = cbind(reg_list, b)
  outfile = paste("/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn/clust",
                  toString(cluster_list[i]), ".csv", sep = '')
  write.csv(b_mat, outfile)
  df = data.frame(b_mat)
  df$reg_list <- factor(df$reg_list, levels=reg_list)
  df$b <- as.numeric(df$b)
  print(is.factor(df$reg_list))
  print(is.data.frame(df))
  print(df)
  plot <- ggplot(data=df, aes(x=reg_list, y=b)) + geom_bar(stat = "identity")
  outplot = paste("/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov/lrn/clust",
                  toString(cluster_list[i]), ".jpg", sep = '')
  ggsave(filename=outplot, plot=plot) 

  
}

