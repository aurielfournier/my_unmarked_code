# predictions from GDistsamp 2012

#read in the sora observations
sora13r3 <- read.csv('2013r3_sora.csv', header=T)
#read in the covariate data #organized by impoundment.
cov13r3 <- read.csv('2013r3_cov.csv', header=T)
#subset covaraites we need
cov13r3 <- cov13r3[,c("region","length_3","impound","jdate_3","hectares","area", "int","short","water")]
# #the distance bins

sora13r3 <- sora13r3[order(sora13r3$impound),]
cov13r3 <- cov13r3[order(cov13r3$impound),]

sora13r3 <- sora13r3[,2:40]
cutpt = as.numeric(c(0,1,2,3,4,5,6,7,8,9,10,11,12,13)) 
#Unmarked Data Frame
umf13r3 = unmarkedFrameGDS(y=sora13r3, 
                           numPrimary=3,
                           siteCovs = cov13r3,
                           survey="line", 
                           dist.breaks=cutpt,  
                           unitsIn="m", 
                           tlength=cov13r3$length_3,
)


null13r3 = gdistsamp(lambdaformula = ~1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf13r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

reg13r3 = gdistsamp(lambdaformula = ~region-1, 
                    phiformula = ~1, 
                    pformula = ~ 1,
                    data = umf13r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

area13r3 = gdistsamp(lambdaformula = ~area-1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf13r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

reg_w13r3 =gdistsamp(lambdaformula = ~region+water-1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf13r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

short13r3 =gdistsamp(lambdaformula = ~short-1, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf13r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

short_w13r3 =gdistsamp(lambdaformula = ~short+water-1, 
                       phiformula = ~1, 
                       pformula = ~ 1,
                       data = umf13r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")

global13r3 =gdistsamp(lambdaformula = ~region+water+area+short-1, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf13r3, keyfun = "hazard", mixture="NB",se = T, output="density",unitsOut="ha")


list13r3 = fitList(null13r3, global13r3, short_w13r3, short13r3,reg_w13r3,area13r3,reg13r3)
model13r3 =modSel(list13r3)
model13r3