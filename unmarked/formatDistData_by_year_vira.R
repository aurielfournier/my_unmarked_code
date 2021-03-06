########
# This code creates the input files (both veg and bird related) for input into gdistsamp
# This code specifically stacks all of the surveys from one year into one input file
####


###
# Needed Packages
###
library(unmarked)


####
# Functions
####

completeFun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}

format_dist_data_by_round <- function(data, year, dist.breaks){
  rounds <- unique(data$round)
  lis <- list()
  for(i in rounds){
    lis[[i]] <- as.data.frame(formatDistData(data[data$round==i,], "distance","impound",dist.breaks,"night"))
  }
  assign(paste("gd",year,sep=""),lis)
}

#####---------------------------

#the farthest bird has been seen at 12 meters, so this encompasses that
dist.breaks12 <- c(0,2,4,6,8,10,12,14) 
dist.breaks <- c(0,1,2,3,4,5,6,7,8,9,10,11,12,13) 

birds <- read.csv("all_birds.csv",header=T) 
birds <- birds[birds$species=="vira",] 
birds$jdate <- as.factor(birds$jdate)
birds$night <- as.factor(birds$night)
birds <- birds[!(birds$night==4.2|birds$night==4.1|birds$night==0),]

birds12 <- birds[birds$year==2012,]
birds12$night <- factor(birds12$night, labels=c(1,2,3))

birds13 <- birds[birds$year==2013,]
birds13$night <- factor(birds13$night, labels=c(1.1,1.2,2.1,2.2,3.1,3.2))

birds14 <- birds[birds$year==2014,]
birds14$night <- factor(birds14$night, labels=c(1.1,1.2,2.1,3.1,3.2))

gd2012 <- format_dist_data_by_round(birds12, 2012, dist.breaks12)
gd2013 <- format_dist_data_by_round(birds13, 2013, dist.breaks)
gd2014 <- format_dist_data_by_round(birds14, 2014, dist.breaks)

####------
# read in effort data
surv <- read.csv("all_surveys.csv",header=T)
surv <- surv[,c("year","night","round","impound","length","jdate")]
surv$jdate <- as.factor(surv$jdate)
#####

list2012 <- list()
for(i in 1:3){
    bird <- gd2012[[i]]
    list2012[[i]] <- bird[(rownames(bird) %in% surv[surv$round==i&surv$year==2012,]$impound),]
}

list2013 <- list()
for(i in 1:4){
  bird <- gd2013[[i]]
  list2013[[i]] <- bird[(rownames(bird) %in% surv[surv$round==i&surv$year==2013,]$impound),]
}

list2014 <- list()
for(i in 1:4){
  bird <- gd2013[[i]]
  list2014[[i]] <- bird[(rownames(bird) %in% surv[surv$round==i&surv$year==2014,]$impound),]
}

####-----------------------------------------------
# Input covariates
####----------------------------------------------
veg <- read.csv("all_veg.csv", header=T) 


## 2012 ##
veg12 <- veg[veg$year==2012,]
vegss <- veg12[,c(13:29,33:35)]
vegss <- scale(vegss)
colnames(vegss) <- paste("scale", colnames(vegss), sep = "_")
veg12 <- cbind(veg12[,c(6,9:15,18:23,29)],vegss[,c(1:3,6:17)])
#clipping it down to just Moist Soil plots 
veg12 <- veg12[!(veg12$impound=="boardwalk"|veg12$impound=="ditch"|veg12$impound=="n mallard"|veg12$impound=="nose"|veg12$impound=="r4/5"|veg12$impound=="redhead slough"|veg12$impound=="ts11a"|veg12$impound=="sg "),]

melt12 <- melt(veg12, id=c("impound","round","region","area"))
cast12 <- cast(melt12, impound + region + area + round ~ variable, mean, fill=NA_real_,na.rm=T)
castr1 <- cast12[cast12$round==2,]
castr1$round <- 1
cast12 <- rbind(cast12,castr1 )
cast12$ir <- paste(cast12$impound, cast12$round, sep="_")
mlen12 <- melt(surv[surv$year==2012,], id=c("impound","round","night","year"), na.rm=T)
clen12 <- cast(mlen12, impound + round ~ variable, max, fill=NA_real_,na.rm=T)
clen12$ir <- paste(clen12$impound, clen12$round, sep="_")

veg12 <- merge(clen12, cast12, by="ir", all=FALSE)
veg12 <- veg12[,c(1,4:ncol(veg12))]
colnames(veg12)[4]<- "impound"
colnames(veg12)[7]<- "round"

### 2013 ###
veg13 <- veg[veg$year==2013,]
vegss <- veg13[,c(13:29,33:35)]
vegss <- scale(vegss)
colnames(vegss) <- paste("scale", colnames(vegss), sep = "_")
veg13 <- cbind(veg13[,c(6,9:29)],vegss[,c(1:4,6:17)])

melt13 <- melt(veg13, id=c("impound","round","region","area"))
cast13 <- cast(melt13, impound + region + area + round ~ variable, mean, fill=NA_real_,na.rm=T)
cast13$ir <- paste(cast13$impound, cast13$round, sep="_")
mlen13 <- melt(surv[surv$year==2013,], id=c("impound","round","night","year"), na.rm=T)
clen13 <- cast(mlen13, impound + round ~ variable, max, fill=NA_real_,na.rm=T)
clen13$ir <- paste(clen13$impound, clen13$round, sep="_")

veg13 <- merge(clen13, cast13, by="ir", all=FALSE)
veg13 <- veg13[,c(1,4:ncol(veg13))]
colnames(veg13)[4]<- "impound"
colnames(veg13)[7]<- "round"

### 2014 ###
v14 <- veg[veg$year==2014&veg$averagewater<900,]
v14$treat[v14$impound=="sanctuary"|v14$impound=="scmsu2"|v14$impound=="pool2w"|v14$impound=="m10"|v14$impound=="ts2a"|v14$impound=="ts4a"|v14$impound=="ccmsu12"|v14$impound=="kt9"|v14$impound=="dc22"|v14$impound=="os23"|v14$impound=="pool i"|v14$impound=="pooli"|v14$impound=="ash"|v14$impound=="sgb"|v14$impound=="scmsu3"|v14$impound=="m11"|v14$impound=="kt2"|v14$impound=="kt6"|v14$impound=="r7"|v14$impound=="poolc"|v14$impound=="pool c"]<-"E"
v14$treat[v14$impound=="sgd"|v14$impound=="rail"|v14$impound=="pool2"|v14$impound=="m13"|v14$impound=="ts6a"|v14$impound=="kt5"|v14$impound=="dc14"|v14$impound=="os21"|v14$impound=="pool e"|v14$impound=="poole"|v14$impound=="r3"|v14$impound=="dc20"|v14$impound=="dc18"|v14$impound=="ccmsu2"|v14$impound=="ccmsu1"|v14$impound=="ts8a"|v14$impound=="pool3w"]<-"L"
v14$woodp = ifelse(v14$wood>0,1,0)
v14$waterp = ifelse(v14$averagewater>0,1,0)
meltv14v = melt(v14[,c( "region","round","impound", "area", "int", "treat", "short","pe", "wood")],id=c("impound","round","treat","region","area"), na.rm=T)
castveg14v = cast(meltv14v, impound + area+  treat + region ~ variable, mean, fill=NA_real_,na.rm=T)
castr <- rbind(castveg14v,castveg14v,castveg14v,castveg14v)
castr$round <- rep(c(1,2,3,4),each=35)
castr$ir <- paste(castr$impound, castr$round, sep="_")

meltv14w = melt(na.omit(v14[,c( "impound","round", "averagewater")]),id=c("impound","round"), na.rm=T)
castveg14w = cast(meltv14w, impound + round~ variable  ,na.rm=T, mean, fill=NA_real_)
castveg14w$ir <- paste(castveg14w$impound, castveg14w$round, sep="_")
castveg14_all <- merge(castr, castveg14w, by="ir")

castss <- scale(castveg14_all[,c(6:9,13)])
colnames(castss) <- paste("scale", colnames(castss), sep = "_")
castveg14 <- cbind(castveg14_all, castss)
castveg14 <- castveg14[,c(1:10,13:ncol(castveg14))]

mlen14 <- melt(surv[surv$year==2014,], id=c("impound","round","night","year"),na.rm=T)
clen14 <- cast(mlen14, impound + round ~ variable, max, fill=NA_real_)
clen14$ir <- paste(clen14$impound, clen14$round, sep="_")

veg14 <- merge(clen14, castveg14, by="ir", all=FALSE)
veg14 <- veg14[,c(1:5,7:13,15:ncol(veg14))]

######---------------------------
# Create the Sora Input Files 
######---------------------------

s12 <- list()
for(i in 1:3){
  bird <- list2012[[i]]
  s <- cbind(impound=rownames(bird),bird)
  df <- s[(s$impound %in% intersect(s$impound, veg12$impound)),]
  df$round <- i
  df$ir <- paste(df$impound, df$round, sep="_")
  s12[[i]] <- df[(df$ir %in% intersect(df$ir, veg12$ir)),]
}
sora12 <- do.call(rbind, s12)

s13 <- list()
for(i in 2:4){
  bird <- list2013[[i]]
  df <- cbind(impound=rownames(bird),bird)
  df$round <- i
  df$ir <- paste(df$impound, df$round, sep="_")
  s13[[i-1]] <- df[(df$ir %in% intersect(df$ir, veg13$ir)),]
}
sora13 <- do.call(rbind, s13)

s14 <- list()
for(i in 2:4){
  bird <- list2014[[i]]
  df <- cbind(impound=rownames(bird),bird)
  df$round <- i
  df$ir <- paste(df$impound, df$round, sep="_")
  s14[[i]] <- df[(df$ir %in% intersect(df$ir, veg14$ir)),]
}
sora14 <- do.call(rbind, s14)

## Cut down veg files

veg12 <- veg12[(veg12$ir %in% intersect(veg12$ir, sora12$ir)),]
veg13 <- veg13[(veg13$ir %in% intersect(veg13$ir, sora13$ir)),]
veg14 <- veg14[(veg14$ir %in% intersect(veg14$ir, sora14$ir)),]


### create bird input files

write.csv(sora12, "2012_vira.csv", row.names=F)
write.csv(sora13, "2013_vira.csv", row.names=F)
write.csv(sora14, "2014_vira.csv", row.names=F)

# Create Covariate Files ----------------------------------------------------------------------------------------

write.csv(veg12, "2012_cov_vira.csv", row.names=F)
write.csv(veg13, "2013_cov_vira.csv", row.names=F)
write.csv(veg14, "2014_cov_vira.csv", row.names=F)

