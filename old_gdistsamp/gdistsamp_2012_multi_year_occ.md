
```r
# predictions from GDistsamp 2012

library(unmarked)
```

```
## Loading required package: methods
## Loading required package: reshape
```

```
## Warning: package 'reshape' was built under R version 3.1.2
```

```
## Loading required package: lattice
## Loading required package: Rcpp
```

```r
#read in the sora observations
sora <- read.csv('C:/Users/avanderlaar/Documents/GitHub/data/2012_sora_multi_year_occ.csv', header=T)
```

```
## Warning: cannot open file
## 'C:/Users/avanderlaar/Documents/GitHub/data/2012_sora_multi_year_occ.csv':
## No such file or directory
```

```
## Error: cannot open the connection
```

```r
#read in the covariate data #organized by impoundment.
cov <- read.csv('C:/Users/avanderlaar/Documents/GitHub/data/2012_cov_multi_year_occ.csv', header=T)
```

```
## Warning: cannot open file
## 'C:/Users/avanderlaar/Documents/GitHub/data/2012_cov_multi_year_occ.csv':
## No such file or directory
```

```
## Error: cannot open the connection
```

```r
rounds <- cov[,grepl("averagewater_",colnames(cov))]
```

```
## Error: object of type 'closure' is not subsettable
```

```r
rounds <- rounds[,c(1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6)]
```

```
## Error: object 'rounds' not found
```

```r
length <- cov[,grepl("length",colnames(cov))]
```

```
## Error: object of type 'closure' is not subsettable
```

```r
cov <- cov[,!grepl("averagewater_",colnames(cov))]
```

```
## Error: object of type 'closure' is not subsettable
```

```r
cov <- cov[,!grepl("length",colnames(cov))]
```

```
## Error: object of type 'closure' is not subsettable
```

```r
#subset covaraites we need
#cov <- cov[,c("region","length","impound","jdate","area", "scale_int","scale_short","scale_averagewater")]
# #the distance bins

sora <- sora[order(sora$impound),]
```

```
## Error: object 'sora' not found
```

```r
cov <- cov[order(cov$impound),]
```

```
## Error: object of type 'closure' is not subsettable
```

```r
sora <- sora[,2:ncol(sora)]
```

```
## Error: object 'sora' not found
```

```r
cutpt = as.numeric(c(0,1,2,3,4,5,6)) 

#Unmarked Data Frame

umf = unmarkedFrameGDS(y=sora, 
                           numPrimary=9,
                           siteCovs = cov,
                           yearlySiteCovs=list(scale_w=rounds[,grepl("scale",colnames(rounds))],w=rounds[,grepl("^averagewater",colnames(rounds))]),
                           survey="line", 
                           dist.breaks=cutpt,  
                           unitsIn="m", 
                           tlength=rowMeans(length,na.rm=TRUE)
)
```

```
## Error: object 'sora' not found
```



```r
model <- list()

model$null = gdistsamp(lambdaformula = ~1, 
                     phiformula = ~1, 
                     pformula = ~1,
                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```


```r
model$region = gdistsamp(lambdaformula = ~region, 
                    phiformula = ~1, 
                    pformula = ~ 1,
                    data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$averagewater = gdistsamp(lambdaformula = ~scale_averagewater, 
                    phiformula = ~1, 
                    pformula = ~1,
                    data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$int = gdistsamp(lambdaformula = ~scale_int, 
                    phiformula = ~1, 
                    pformula = ~ 1,
                    data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
# model$fedstate = gdistsamp(lambdaformula = ~fs, 
#                     phiformula = ~1, 
#                     pformula = ~ 1,
#                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$perenialemerg = gdistsamp(lambdaformula = ~scale_pe, 
#                     phiformula = ~1, 
#                     pformula = ~ 1,
#                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
model$short = gdistsamp(lambdaformula = ~scale_short, 
                    phiformula = ~1, 
                    pformula = ~ 1,
                    data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$openwater = gdistsamp(lambdaformula = ~scale_water, 
                    phiformula = ~1, 
                    pformula = ~ 1,
                    data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
# model$openwater = gdistsamp(lambdaformula = ~scale_millet_, 
#                     phiformula = ~1, 
#                     pformula = ~ 1,
#                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
# ```
# ```{r}
# model$openwater = gdistsamp(lambdaformula = ~scale_smartweed_, 
#                     phiformula = ~1, 
#                     pformula = ~ 1,
#                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
model$region_averagewater =gdistsamp(lambdaformula = ~region+scale_averagewater, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$region_int =gdistsamp(lambdaformula = ~region+scale_int, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
# model$region_fedstate =gdistsamp(lambdaformula = ~region+fs-1, 
#                      phiformula = ~1, 
#                      pformula = ~ 1,
#                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$region_perennialemerg =gdistsamp(lambdaformula = ~region+scale_pe, 
#                      phiformula = ~1, 
#                      pformula = ~ 1,
#                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
model$region_short =gdistsamp(lambdaformula = ~region+scale_short, 
                     phiformula = ~1, 
                     pformula = ~ 1,
                     data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$region_openwater =gdistsamp(lambdaformula = ~region+scale_water, 
                       phiformula = ~1, 
                       pformula = ~ 1,
                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$averagewater_int =gdistsamp(lambdaformula = ~scale_averagewater+scale_int, 
                       phiformula = ~1, 
                       pformula = ~ 1,
                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
# model$averagewater_fedstate =gdistsamp(lambdaformula = ~scale_averagewater+fs, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$averagewater_perennialemerg =gdistsamp(lambdaformula = ~scale_averagewater+scale_pe, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
model$averagewater_short =gdistsamp(lambdaformula = ~scale_averagewater+scale_short, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$averagewater_openwater =gdistsamp(lambdaformula = ~scale_averagewater+scale_water, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$int_fedstate =gdistsamp(lambdaformula = ~scale_int+fs, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
# model$int_perennialemerg =gdistsamp(lambdaformula = ~scale_int+scale_pe, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
model$int_short =gdistsamp(lambdaformula = ~scale_int+scale_short, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
model$int_openwater =gdistsamp(lambdaformula = ~scale_int+scale_water, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
# model$fedstate_perrenialemerg=gdistsamp(lambdaformula = ~fs+scale_pe, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$fedstate_short =gdistsamp(lambdaformula = ~fs+scale_short, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$fedstate_openwater =gdistsamp(lambdaformula = ~fs+scale_water, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$perennialemerg_short =gdistsamp(lambdaformula = ~scale_pe+scale_short, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$perennialemerg_openwater =gdistsamp(lambdaformula = ~scale_pe+scale_water, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
model$short_openwater =gdistsamp(lambdaformula = ~scale_short+scale_water, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
# model$region_millet =gdistsamp(lambdaformula = ~region+scale_millet_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$region_smart =gdistsamp(lambdaformula = ~region+scale_smartweed_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$int_millet =gdistsamp(lambdaformula = ~scale_int+scale_millet_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$int_smart =gdistsamp(lambdaformula = ~scale_int+scale_smartweed_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$openwater_millet =gdistsamp(lambdaformula = ~scale_water+scale_millet_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$openwater_smart =gdistsamp(lambdaformula = ~scale_water+scale_smartweed_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$averagewater_millet =gdistsamp(lambdaformula = ~scale_averagewater+scale_millet_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$averagewater_smart =gdistsamp(lambdaformula = ~scale_averagewater+scale_smart_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$short_millet =gdistsamp(lambdaformula = ~scale_short+scale_millet_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$short_smart =gdistsamp(lambdaformula = ~scale_short+scale_smartweed_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$pe_millet =gdistsamp(lambdaformula = ~scale_pe+scale_millet_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$pe_millet =gdistsamp(lambdaformula = ~scale_pe+scale_smartweed_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$fs_millet =gdistsamp(lambdaformula = ~fs+scale_millet_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$fs_smart =gdistsamp(lambdaformula = ~fs+scale_smartweed_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
# model$millet_smart =gdistsamp(lambdaformula = ~scale_millet_+scale_smartweed_, 
#                       phiformula = ~1, 
#                       pformula = ~ 1,
#                       data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```r
model$global <- gdistsamp(lambdaformula = ~scale_short+scale_water+scale_averagewater+region+scale_int, 
                      phiformula = ~1, 
                      pformula = ~ 1,
                      data = umf, keyfun = "hazard", mixture="NB",se = T, output="abund")
```

```
## Error: object 'umf' not found
```

```r
save(model, file="2012_models.Rdata")
list  = fitList(model)
```

```
## Warning: If supplying a list of fits, use fits = 'mylist'
```

```
## Error: 'names' attribute [1] must be the same length as the vector [0]
```

```r
model = modSel(list)
```

```
## Error: unable to find an inherited method for function 'modSel' for
## signature '"function"'
```

```r
model
```

```
## list()
```
