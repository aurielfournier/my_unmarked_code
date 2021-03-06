# vector of models we are going to consider
models <- c("~1", 
            "~scale_averagewater",
            "~scale_averagewater+scale_averagewater2",
            "~scale_short",
            "~scale_int",
            "~scale_short+scale_int")

###########
# Needed Packages
###########

library(unmarked)
library(ggplot2)
library(unmarked)
library(AICcmodavg)

############
# Reading in the Data
############

sora <- read.csv('./2012_sora.csv', header=T)
cov <- read.csv('./2012_cov.csv', header=T)

# the input files should have the rows ordered so they match already, but this makes sure that is true
sora <- sora[order(sora$impound),]
cov <- cov[order(cov$impound),]

# creates the squared average water covariate
cov$scale_averagewater2 <- cov$scale_averagewater^2

# trims the sora input file so it only has the columns of distance bins, nothing else
sora <- sora[,2:16]

# define's the distances of the bins
cutpt = as.numeric(c(0,1,2,3,4,5)) 

# brings the two files together into the ummarkedFrameGDS
umf = unmarkedFrameGDS(y=sora, 
                       numPrimary=3,
                       siteCovs = cov,
                       survey="line", 
                       dist.breaks=cutpt,  
                       unitsIn="m", 
                       tlength=cov$length
)


# create list to dump all the models into
model <- list()


for(i in 1:length(models)){
  print(i)
  model[[models[[i]]]] = gdistsamp(lambdaformula = as.formula(models[i]), 
                                   phiformula = ~1, 
                                   pformula = ~1,
                                   data = umf, keyfun = "hazard", mixture="NB",se = T, output="density")
}

# I have this one seperate so it will be named 'global' 
model[["global"]] <- gdistsamp(lambdaformula = ~scale_short+scale_averagewater+scale_averagewater2+scale_int, 
                          phiformula = ~1, 
                          pformula = ~ 1,
                          data = umf, keyfun = "hazard", mixture="NB",se = T, output="density")

# save(model, file="C:/Users/avanderlaar/Documents/unmarked/2012_models.Rdata")
list  = fitList(model)
mlist = modSel(list)
mlist


# model averages the three covariates to see 
modavg12s <- modavg(model, parm="scale_short", parm.type="lambda")
modavg12i <- modavg(model, parm="scale_int", parm.type="lambda") #NOT
modavg12w <- modavg(model, parm="scale_averagewater", parm.type="lambda", exclude=list("~scale_averagewater+scale_averagewater2")) #NOT


## short

scale_short12 <- data.frame(scale_short=seq(min(cov$scale_short), max(cov$scale_short), length.out=50),scale_averagewater=mean(cov$scale_averagewater), scale_averagewater2=mean(cov$averagewater)^2, scale_int=mean(cov$scale_int), short=seq(min(cov$short), max(cov$short), length.out=50))

Modnames <- names(model)

pred_short_12 <- modavgPred(cand.set=model, modnames=Modnames,newdata=scale_short12, parm.type="lambda",type="response", uncond.se="old")

short12 <- cbind(scale_short12, pred_short_12)

short12$sd <- short12$uncond.se * sqrt(nrow(cov))

short12$ci <- qnorm(0.975)*short12$sd/sqrt(nrow(cov))

short12$upper <- short12$mod.avg.pred + short12$ci
short12$lower <- short12$mod.avg.pred - short12$ci

(s12 <- ggplot()+ylab("Sora per hectare")+xlab("Percent Cover Non Presistent \nMoist Soil Vegetation")+
  geom_ribbon(data=short12, aes(x=short, ymax=upper, ymin=lower), fill="gray", color="black")+
  geom_line(data=short12, aes(x=short, y=mod.avg.pred))+ggtitle("2012")+
  theme(axis.text.x = element_text(size = 12, color = "black"), 
        axis.text.y = element_text(size = 12, color = "black"), 
        axis.title.y = element_text(size = 20), plot.background = element_blank(), 
        panel.border = element_blank(), panel.grid.major = element_line(colour = NA), 
        panel.grid.minor = element_line(colour = NA), title = element_text(size = 20), 
        panel.background = element_rect(fill = "white"), axis.line = element_line(colour = "black"), 
        strip.background = element_rect(fill = "white", color = "black"), 
        strip.text = element_text(size = 15)))

