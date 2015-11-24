outlier_test <- function(num, thresh) { 
  b <- (num>thresh)
  return(b)
}

z_score <- function(num, mn, sd) {
  z <- (num - mn)/sd
  return(z)
}

cluster_list <- c(1, 3, 6, 12, 15, 16, 20, 21, 23, 24, 26, 28)

clust_dat = list()

for (i in 1:length(cluster_list)){
  infile = paste("/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov_new/lrn/con5/cov_con_clustno", 
                 toString(cluster_list[i]), ".csv", sep='')
  cov_con <- read.csv(infile, header=T)

  if (cluster_list[i] == 28){
      cov_con <- cov_con[complete.cases(cov_con),]
  }
  twovars <- data.frame(cov_con$RelxHalf, cov_con$cov)
  
  means <- apply(twovars, 2, mean)
  sds <- apply(twovars, 2, sd)
  z_con <- z_score(twovars$cov_con.RelxHalf, means[1], sds[1])
  z_cov <- z_score(twovars$cov_con.cov, means[2], sds[2])
  cov_con$zRelxHalf <- z_con
  cov_con$zcov <-z_cov

  Md = mahalanobis(twovars, colMeans(twovars), cov(twovars))
  cov_con$mah_d <- Md
  
  qc <- qchisq(.999, df=2)
  is.outlier <- outlier_test(Md, qc)
  cov_con$is.outlier <- is.outlier
  clust_dat[[i]] <- cov_con
  write.table(cov_con, paste("/media/truecrypt1/SocCog/results/noMV_noval_1stvs2nd_wbp_cov_new/lrn/con5/MDclust",
                             toString(cluster_list[i]), ".csv", sep = ''), sep=',', row.names=FALSE)
  
  
}
