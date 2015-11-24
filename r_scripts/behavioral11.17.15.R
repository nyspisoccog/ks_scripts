
RU <- read.csv("/Volumes/LaCie/LaPrivate/soccog/RU.csv")
RU$type <- factor(RU$type, levels=c("S", "Y", "N"))
library(lme4)
RU$subject <- factor(RU$subject)
RU.edited <- subset(RU, RU$ans != 3.5)
RU.edited <- subset(RU.edited, RU.edited$subject != 7403)
RU.edited <- subset(RU.edited, RU.edited$subject != 7613)
RU.edited <- subset(RU.edited, RU.edited$subject != 7719)
RU.edited <- subset(RU.edited, RU.edited$subject != 7659)
RU.edited.model <- lmer(RU.edited$ans ~ RU.edited$type + (1|RU.edited$subject), REML=FALSE)
mySumm2 <- function(.) {
  c(beta=fixef(.),sigma=sigma(.), sig01=sqrt(unlist(VarCorr(.))))
}
t0 <- mySumm2(RU.edited.model)
t0
set.seed(101)
require("boot")
system.time( boo01 <- bootMer(RU.edited.model, mySumm2, nsim = 100) )
boo01
(bCI.2  <- boot.ci(boo01, index=2, type=c("norm", "basic", "perc")))

hist(residuals(RU.edited.model,type="deviance", scaled=TRUE))