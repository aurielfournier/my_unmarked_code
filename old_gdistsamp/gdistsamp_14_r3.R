# predictions from GDistsamp 2012

#read in the sora observations
sora14r3 <- read.csv('2014r3_sora.csv', header=T)
#read in the covariate data #organized by impoundment.
cov14r3 <- read.csv('2014r3_cov.csv', header=T)
#subset covaraites we need
cov14r3 <- cov14r3[,c("region","length_3","impound","jdate_3","hectares","area", "treat","int","short","averagewater_3")]
# #the distance bins

sora14r3 <- sora14r3[order(sora14r3$impound),]
cov14r3 <- cov14r3[order(cov14r3$impound),]

sora14r3 <- sora14r3[,2:40]
cutpt = as.numeric(c(0,1,2,3,4,5,6,7,8,9,10,11,12,13)) 
#Unmarked Data Frame
umf14r3 = unmarkedFrameGDS(y=sora14r3, 
                           numPrimary=3,
                           siteCovs = cov14r3,
                           survey="line", 
                           dist.breaks=cutpt,  
                           unitsIn="m", 
                           tlength=cov14r3$length_3,
)


null14r3 = gdistsamp(lambdaformula = ~1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

reg14r3 = gdistsamp(lambdaformula = ~region-1, 
                    phiformula = ~1, 
                    pformula = ~ 1,
                    data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

reg_treat14r3 = gdistsamp(lambdaformula = ~region+treat-1, 
                          phiformula = ~1, 
                          pformula = ~ 1,
                          data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

area14r3 = gdistsamp(lambdaformula = ~area-1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

reg_w14r3 =gdistsamp(lambdaformula = ~region+averagewater_3-1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

short14r3 =gdistsamp(lambdaformula = ~short-1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

short_w14r3 =gdistsamp(lambdaformula = ~short+averagewater_3-1, 
                       phiformula = ~1, 
                       pformula = ~ 1,
                       data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

treat14r3 =gdistsamp(lambdaformula = ~treat-1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")


global14r3 =gdistsamp(lambdaformula = ~region+averagewater_3+area+short+treat-1, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf14r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")


list14r3 = fitList(null14r3, global14r3, reg_treat14r3, treat14r3, short_w14r3, short14r3,reg_w14r3,area14r3,reg14r3)
model14r3 =modSel(list14r3)
model14r3