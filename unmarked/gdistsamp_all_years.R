#all years together with year covariate


library(unmarked)



sora <- read.csv('C:/Users/avand/Documents/data/2012_sora.csv', header=T)
cov <- read.csv('C:/Users/avand/Documents/data/2012_cov.csv', header=T)

sora <- sora[order(sora$impound),]
cov <- cov[order(cov$impound),]

cov$scale_short2 <- cov$scale_short^2
cov$scale_int2 <- cov$scale_int^2
cov$scale_averagewater2 <- cov$scale_averagewater^2
sora <- sora[,2:16]

##

sora <- read.csv('C:/Users/avand/Documents/data/2013_sora.csv', header=T)
cov <- read.csv('C:/Users/avand/Documents/data/2013_cov.csv', header=T)

sora <- sora[order(sora$impound),]
cov <- cov[order(cov$impound),]

cov$scale_short2 <- cov$scale_short^2
cov$scale_int2 <- cov$scale_int^2
cov$scale_averagewater2 <- cov$scale_averagewater^2

sora <- sora[,2:31]


##

sora <- read.csv('C:/Users/avand/Documents/data/2014_sora.csv', header=T)
cov <- read.csv('C:/Users/avand/Documents/data/2014_cov.csv', header=T)
sora <- sora[order(sora$impound),]
cov <- cov[order(cov$impound),]

cov$scale_short2 <- cov$scale_short^2
cov$scale_int2 <- cov$scale_int^2
cov$scale_averagewater2 <- cov$scale_averagewater^2

sora <- sora[,2:11]
cutpt = as.numeric(c(0,1,2,3,4,5)) 

##

sora <- read.csv('C:/Users/avand/Documents/data/2015_sora.csv', header=T)

cov <- read.csv('C:/Users/avand/Documents/data/2015_cov.csv', header=T)

sora <- sora[order(sora$impound),]
cov <- cov[order(cov$impound),]

cov$scale_short2 <- cov$scale_short^2
cov$scale_int2 <- cov$scale_int^2
cov$scale_averagewater2 <- cov$scale_averagewater^2

sora <- sora[,2:11]

##








cutpt = as.numeric(c(0,1,2,3,4,5)) 

umf = unmarkedFrameGDS(y=sora, 
                       numPrimary=2,
                       siteCovs = cov,
                       survey="line", 
                       dist.breaks=cutpt,  
                       unitsIn="m", 
                       tlength=cov$length
)

model <- list()



models <- c("~1",
            "~scale_averagewater",
            "~scale_averagewater+scale_averagewater2",
            "~scale_short",
            "~scale_int",
            "~scale_short+scale_int",
            "~scale_pe")



for(i in 1:length(models)){
  print(i)
  model[[models[[i]]]] = gdistsamp(lambdaformula = as.formula(models[i]), 
                                   phiformula = ~1, 
                                   pformula = ~1,
                                   data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
}

model$global <- gdistsamp(lambdaformula = ~scale_short+scale_averagewater+scale_averagewater2+scale_int+scale_pe, 
                          phiformula = ~1, 
                          pformula = ~ 1,
                          data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")

save(model, file="C:/Users/avand/Documents/unmarked/2015_models.Rdata")
list  = fitList(model)
m15 = modSel(list)
m15
