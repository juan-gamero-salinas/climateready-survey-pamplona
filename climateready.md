---
title: '**CLIMATEREADY**'
subtitle: '**Thermal Comfort Survey Amid Heatwaves**'
author: "Juan Gamero-Salinas - Postdoc Researcher @ DATAI University of Navarra"
date: '2024-05-27'
output:
  html_document:
    toc: true
    toc_float: true
    toc_depth: 4
    theme: united
    keep_md: true
    
---

This R Markdown file allows contains the code for answering the Research Objective 3 (RQ3): **Which factors contribute to an increased likelihood of occupants being clustered into distinct groups of thermal comfort?** of the case study on the research paper **Exploring indoor thermal comfort and its causes and consequences amid heatwaves in a Southern European city— An unsupervised learning approach** 





# **K-means**

## **Loading & Inspecting data**

### Set working directory
Set the folder location



### Set the seed for reproducibility

```r
set.seed(1)  # Replace 123 with your desired seed value 
```

### Read the csv

```r
df <- read.csv("R_logistic_kmeans.csv", sep=";")
head(df, 3)
```

```
##   meanTout Gender Age NatVent_night UsesCoolingAlternatives hw_True
## 1     27.5   True  39          True                   False   False
## 2     27.5   True  29          True                   False   False
## 3     18.1  False  55         False                   False   False
##   Hour_7_14h_True Hour_14_21h_True Hour_21_7h_True ShadingDevices_No
## 1            True            False           False             False
## 2           False             True           False             False
## 3            True            False           False              True
##   ShadingDevices_WhenDirectSun ShadingDevices_AllAfternoon
## 1                        False                       False
## 2                        False                       False
## 3                        False                       False
##   ShadingDevices_AllMorning ShadingDevices_AllDay NatVent_day_ToutCool
## 1                     False                  True                 True
## 2                     False                  True                 True
## 3                     False                 False                 True
##   NatVent_day_Anytime NatVent_day_No hasAC_No hasAC_DormOrLiving
## 1               False          False     True              False
## 2               False          False     True              False
## 3               False          False     True              False
##   hasAC_DormAndLiving hasAC_AllRooms HouseholdSize is_31001 is_31002 is_31003
## 1               False          False             2    False    False    False
## 2               False          False             3    False    False    False
## 3               False          False             4    False    False    False
##   is_31004 is_31005 is_31006 is_31007 is_31008 is_31009 is_31010 is_31011
## 1    False    False    False    False    False    False    False    False
## 2    False    False    False     True    False    False    False    False
## 3    False    False    False    False     True    False    False    False
##   is_31012 is_31013 is_31014 is_31015 is_31016 isNot_pamplona before_1980
## 1    False    False    False    False     True          False       False
## 2    False    False    False    False    False          False       False
## 3    False    False    False    False    False          False        True
##   between_1980_2006 after_2007 dwelling_OldTown dwelling_Block dwelling_Tower
## 1              True      False            False           True          False
## 2              True      False            False           True          False
## 3             False      False            False          False           True
##   dwelling_Detached dwelling_Other Rehab_No Rehab_Yes Income_below1500
## 1             False          False     True     False            False
## 2             False          False    False      True            False
## 3             False          False    False      True            False
##   Income_between_1500_3500 Income_above_3500 Occ_NormallyAtHome
## 1                    False              True               True
## 2                     True             False              False
## 3                    False              True              False
##   Occ_NotAlwaysAtHome SrfcArea_below90 Storey_UpperFloor Storey_NotApartment
## 1               False            False             False               False
## 2                True             True             False               False
## 3                True            False             False               False
##   numOrient_1 numOrient_above2 LivRoom_SrfcAreaWindow_below2
## 1       False             True                         False
## 2       False             True                         False
## 3       False             True                         False
##   LivRoom_SrfcAreaWindow_above2 Bedroom_SrfcAreaWindow_below2
## 1                          True                         False
## 2                          True                         False
## 3                          True                         False
##   Bedroom_SrfcAreaWindow_above2 AC_Installed_Yes WouldYouInstallAC_Yes
## 1                          True            False                 False
## 2                          True            False                  True
## 3                          True            False                 False
##   hasCoolRoom hasCoolingAlternatives cluster_kmeans
## 1        True                   True              0
## 2       False                   True              0
## 3       False                  False              0
```


## **Pre-processing data**

### Function to convert TRUE/FALSE to 1/0

```r
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 4.1.3
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
convert_to_binary <- function(x) {
  as.numeric(x)
}
```

###Apply the function to all columns except the first one (assuming it's the index)

```r
data_transformed <- df %>%
  mutate_all(~ ifelse(. == "True", 1, ifelse(. == "False", 0, .)))
```


### Print the transformed data

```r
head(data_transformed, 3)
```

```
##   meanTout Gender Age NatVent_night UsesCoolingAlternatives hw_True
## 1     27.5      1  39             1                       0       0
## 2     27.5      1  29             1                       0       0
## 3     18.1      0  55             0                       0       0
##   Hour_7_14h_True Hour_14_21h_True Hour_21_7h_True ShadingDevices_No
## 1               1                0               0                 0
## 2               0                1               0                 0
## 3               1                0               0                 1
##   ShadingDevices_WhenDirectSun ShadingDevices_AllAfternoon
## 1                            0                           0
## 2                            0                           0
## 3                            0                           0
##   ShadingDevices_AllMorning ShadingDevices_AllDay NatVent_day_ToutCool
## 1                         0                     1                    1
## 2                         0                     1                    1
## 3                         0                     0                    1
##   NatVent_day_Anytime NatVent_day_No hasAC_No hasAC_DormOrLiving
## 1                   0              0        1                  0
## 2                   0              0        1                  0
## 3                   0              0        1                  0
##   hasAC_DormAndLiving hasAC_AllRooms HouseholdSize is_31001 is_31002 is_31003
## 1                   0              0             2        0        0        0
## 2                   0              0             3        0        0        0
## 3                   0              0             4        0        0        0
##   is_31004 is_31005 is_31006 is_31007 is_31008 is_31009 is_31010 is_31011
## 1        0        0        0        0        0        0        0        0
## 2        0        0        0        1        0        0        0        0
## 3        0        0        0        0        1        0        0        0
##   is_31012 is_31013 is_31014 is_31015 is_31016 isNot_pamplona before_1980
## 1        0        0        0        0        1              0           0
## 2        0        0        0        0        0              0           0
## 3        0        0        0        0        0              0           1
##   between_1980_2006 after_2007 dwelling_OldTown dwelling_Block dwelling_Tower
## 1                 1          0                0              1              0
## 2                 1          0                0              1              0
## 3                 0          0                0              0              1
##   dwelling_Detached dwelling_Other Rehab_No Rehab_Yes Income_below1500
## 1                 0              0        1         0                0
## 2                 0              0        0         1                0
## 3                 0              0        0         1                0
##   Income_between_1500_3500 Income_above_3500 Occ_NormallyAtHome
## 1                        0                 1                  1
## 2                        1                 0                  0
## 3                        0                 1                  0
##   Occ_NotAlwaysAtHome SrfcArea_below90 Storey_UpperFloor Storey_NotApartment
## 1                   0                0                 0                   0
## 2                   1                1                 0                   0
## 3                   1                0                 0                   0
##   numOrient_1 numOrient_above2 LivRoom_SrfcAreaWindow_below2
## 1           0                1                             0
## 2           0                1                             0
## 3           0                1                             0
##   LivRoom_SrfcAreaWindow_above2 Bedroom_SrfcAreaWindow_below2
## 1                             1                             0
## 2                             1                             0
## 3                             1                             0
##   Bedroom_SrfcAreaWindow_above2 AC_Installed_Yes WouldYouInstallAC_Yes
## 1                             1                0                     0
## 2                             1                0                     1
## 3                             1                0                     0
##   hasCoolRoom hasCoolingAlternatives cluster_kmeans
## 1           1                      1              0
## 2           0                      1              0
## 3           0                      0              0
```

```r
names(data_transformed)
```

```
##  [1] "meanTout"                      "Gender"                       
##  [3] "Age"                           "NatVent_night"                
##  [5] "UsesCoolingAlternatives"       "hw_True"                      
##  [7] "Hour_7_14h_True"               "Hour_14_21h_True"             
##  [9] "Hour_21_7h_True"               "ShadingDevices_No"            
## [11] "ShadingDevices_WhenDirectSun"  "ShadingDevices_AllAfternoon"  
## [13] "ShadingDevices_AllMorning"     "ShadingDevices_AllDay"        
## [15] "NatVent_day_ToutCool"          "NatVent_day_Anytime"          
## [17] "NatVent_day_No"                "hasAC_No"                     
## [19] "hasAC_DormOrLiving"            "hasAC_DormAndLiving"          
## [21] "hasAC_AllRooms"                "HouseholdSize"                
## [23] "is_31001"                      "is_31002"                     
## [25] "is_31003"                      "is_31004"                     
## [27] "is_31005"                      "is_31006"                     
## [29] "is_31007"                      "is_31008"                     
## [31] "is_31009"                      "is_31010"                     
## [33] "is_31011"                      "is_31012"                     
## [35] "is_31013"                      "is_31014"                     
## [37] "is_31015"                      "is_31016"                     
## [39] "isNot_pamplona"                "before_1980"                  
## [41] "between_1980_2006"             "after_2007"                   
## [43] "dwelling_OldTown"              "dwelling_Block"               
## [45] "dwelling_Tower"                "dwelling_Detached"            
## [47] "dwelling_Other"                "Rehab_No"                     
## [49] "Rehab_Yes"                     "Income_below1500"             
## [51] "Income_between_1500_3500"      "Income_above_3500"            
## [53] "Occ_NormallyAtHome"            "Occ_NotAlwaysAtHome"          
## [55] "SrfcArea_below90"              "Storey_UpperFloor"            
## [57] "Storey_NotApartment"           "numOrient_1"                  
## [59] "numOrient_above2"              "LivRoom_SrfcAreaWindow_below2"
## [61] "LivRoom_SrfcAreaWindow_above2" "Bedroom_SrfcAreaWindow_below2"
## [63] "Bedroom_SrfcAreaWindow_above2" "AC_Installed_Yes"             
## [65] "WouldYouInstallAC_Yes"         "hasCoolRoom"                  
## [67] "hasCoolingAlternatives"        "cluster_kmeans"
```

```r
length(data_transformed)
```

```
## [1] 68
```

```r
nrow(data_transformed)
```

```
## [1] 189
```

```r
n = nrow(data_transformed)
n
```

```
## [1] 189
```




### Define the response variables

```r
# Specify the variable to be used as Y response
Y_response <- "cluster_kmeans"

# Extract the Y response
Y <- data_transformed[, Y_response]

# Extract the X response (all other variables)
X <- data_transformed[, setdiff(names(data_transformed), Y_response)]
```


### Identify variables to exclude from conversion to integer

```r
exclude_variables <- c("Age", "meanTout")
```


### Convert all other variables to integer

```r
X[, setdiff(names(X), exclude_variables)] <- lapply(X[, setdiff(names(X), exclude_variables)], as.integer)
```


### Verify the changes

```r
str(X)
```

```
## 'data.frame':	189 obs. of  67 variables:
##  $ meanTout                     : num  27.5 27.5 18.1 29.2 20.7 26.8 16.8 29.1 26.8 15.8 ...
##  $ Gender                       : int  1 1 0 1 0 0 1 1 1 0 ...
##  $ Age                          : int  39 29 55 44 43 43 54 40 26 44 ...
##  $ NatVent_night                : int  1 1 0 0 1 1 1 1 1 1 ...
##  $ UsesCoolingAlternatives      : int  0 0 0 0 1 1 0 0 1 0 ...
##  $ hw_True                      : int  0 0 0 1 0 1 0 1 1 0 ...
##  $ Hour_7_14h_True              : int  1 0 1 0 0 1 0 0 0 0 ...
##  $ Hour_14_21h_True             : int  0 1 0 1 1 0 0 0 1 0 ...
##  $ Hour_21_7h_True              : int  0 0 0 0 0 0 1 1 0 1 ...
##  $ ShadingDevices_No            : int  0 0 1 0 0 0 0 0 0 0 ...
##  $ ShadingDevices_WhenDirectSun : int  0 0 0 0 0 0 0 0 1 1 ...
##  $ ShadingDevices_AllAfternoon  : int  0 0 0 0 0 1 0 0 0 0 ...
##  $ ShadingDevices_AllMorning    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ ShadingDevices_AllDay        : int  1 1 0 1 1 0 1 1 0 0 ...
##  $ NatVent_day_ToutCool         : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ NatVent_day_Anytime          : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ NatVent_day_No               : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ hasAC_No                     : int  1 1 1 0 1 1 1 0 1 1 ...
##  $ hasAC_DormOrLiving           : int  0 0 0 1 0 0 0 1 0 0 ...
##  $ hasAC_DormAndLiving          : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ hasAC_AllRooms               : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ HouseholdSize                : int  2 3 4 4 2 3 2 2 5 6 ...
##  $ is_31001                     : int  0 0 0 0 0 0 1 0 0 0 ...
##  $ is_31002                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31003                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31004                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31005                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31006                     : int  0 0 0 0 0 0 0 0 1 0 ...
##  $ is_31007                     : int  0 1 0 0 0 0 0 0 0 0 ...
##  $ is_31008                     : int  0 0 1 0 0 0 0 0 0 0 ...
##  $ is_31009                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31010                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31011                     : int  0 0 0 0 0 0 0 1 0 0 ...
##  $ is_31012                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31013                     : int  0 0 0 0 1 0 0 0 0 0 ...
##  $ is_31014                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31015                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31016                     : int  1 0 0 0 0 0 0 0 0 0 ...
##  $ isNot_pamplona               : int  0 0 0 1 0 1 0 0 0 1 ...
##  $ before_1980                  : int  0 0 1 0 0 0 1 1 0 0 ...
##  $ between_1980_2006            : int  1 1 0 1 1 0 0 0 0 1 ...
##  $ after_2007                   : int  0 0 0 0 0 1 0 0 1 0 ...
##  $ dwelling_OldTown             : int  0 0 0 0 0 0 1 0 0 0 ...
##  $ dwelling_Block               : int  1 1 0 1 0 0 0 1 1 0 ...
##  $ dwelling_Tower               : int  0 0 1 0 1 1 0 0 0 0 ...
##  $ dwelling_Detached            : int  0 0 0 0 0 0 0 0 0 1 ...
##  $ dwelling_Other               : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ Rehab_No                     : int  1 0 0 0 0 0 0 1 1 1 ...
##  $ Rehab_Yes                    : int  0 1 1 1 1 1 1 0 0 0 ...
##  $ Income_below1500             : int  0 0 0 1 1 1 0 0 0 0 ...
##  $ Income_between_1500_3500     : int  0 1 0 0 0 0 1 0 0 0 ...
##  $ Income_above_3500            : int  1 0 1 0 0 0 0 1 1 1 ...
##  $ Occ_NormallyAtHome           : int  1 0 0 0 0 0 1 0 0 1 ...
##  $ Occ_NotAlwaysAtHome          : int  0 1 1 1 1 1 1 1 1 1 ...
##  $ SrfcArea_below90             : int  0 1 0 1 1 0 1 0 0 0 ...
##  $ Storey_UpperFloor            : int  0 0 0 0 1 0 0 0 0 0 ...
##  $ Storey_NotApartment          : int  0 0 0 0 0 0 0 0 0 1 ...
##  $ numOrient_1                  : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ numOrient_above2             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ LivRoom_SrfcAreaWindow_below2: int  0 0 0 0 0 1 0 0 0 0 ...
##  $ LivRoom_SrfcAreaWindow_above2: int  1 1 1 1 1 0 1 1 1 1 ...
##  $ Bedroom_SrfcAreaWindow_below2: int  0 0 0 0 1 1 1 0 0 1 ...
##  $ Bedroom_SrfcAreaWindow_above2: int  1 1 1 1 0 0 0 1 1 0 ...
##  $ AC_Installed_Yes             : int  0 0 0 0 0 0 0 1 0 0 ...
##  $ WouldYouInstallAC_Yes        : int  0 1 0 0 0 0 1 0 1 1 ...
##  $ hasCoolRoom                  : int  1 0 0 1 0 0 0 1 0 1 ...
##  $ hasCoolingAlternatives       : int  1 1 0 1 1 1 1 1 1 1 ...
```

```r
X_matrix <- as.matrix(X)
sum(Y)
```

```
## [1] 98
```

```r
head(cor(X_matrix),3)
```

```
## Warning in cor(X_matrix): the standard deviation is zero
```

```
##            meanTout     Gender        Age NatVent_night UsesCoolingAlternatives
## meanTout  1.0000000  0.1307767 -0.1101982   -0.04064627              0.06632550
## Gender    0.1307767  1.0000000 -0.1423769    0.03327403             -0.02237790
## Age      -0.1101982 -0.1423769  1.0000000   -0.01101263             -0.06230988
##              hw_True Hour_7_14h_True Hour_14_21h_True Hour_21_7h_True
## meanTout  0.64636441     -0.10655178       0.18071676     -0.10548001
## Gender    0.13105838     -0.06065691      -0.01231625      0.11106030
## Age      -0.04154947      0.04883595      -0.03796215     -0.01829873
##          ShadingDevices_No ShadingDevices_WhenDirectSun
## meanTout       -0.02250576                 -0.072160114
## Gender          0.01119659                 -0.079213768
## Age            -0.18236903                  0.009446952
##          ShadingDevices_AllAfternoon ShadingDevices_AllMorning
## meanTout                  0.01048686              -0.042545055
## Gender                   -0.10825968              -0.005800514
## Age                      -0.02431157               0.046055713
##          ShadingDevices_AllDay NatVent_day_ToutCool NatVent_day_Anytime
## meanTout            0.08698008         -0.122249775         0.072688735
## Gender              0.08865921          0.014818372         0.006207313
## Age                 0.05592127         -0.006389317        -0.001543991
##          NatVent_day_No    hasAC_No hasAC_DormOrLiving hasAC_DormAndLiving
## meanTout     0.09741886 -0.03281046        0.060098794         -0.01822256
## Gender      -0.02850635 -0.02710528        0.002625832          0.08555758
## Age          0.01103213 -0.07684401        0.102986999          0.01915430
##          hasAC_AllRooms HouseholdSize    is_31001     is_31002    is_31003
## meanTout   -0.008530845   -0.14867237 -0.09489291  0.051096534 -0.09636606
## Gender     -0.010212858    0.04247325 -0.01021286 -0.005800514  0.04913324
## Age        -0.011384744    0.12336614 -0.04521677  0.199778091  0.05513891
##             is_31004     is_31005    is_31006    is_31007     is_31008 is_31009
## meanTout -0.03016554  0.051096534  0.07067259  0.09732405  0.118293314       NA
## Gender   -0.02850635 -0.005800514  0.03089417 -0.09789402 -0.120300727       NA
## Age       0.09214483 -0.103823607 -0.20485991 -0.02857215  0.008472426       NA
##             is_31010    is_31011      is_31012     is_31013    is_31014
## meanTout -0.19012245 -0.09273633  4.015141e-02  0.005229221  0.07663515
## Gender   -0.04192035  0.02883180 -5.800514e-03 -0.008270131  0.08555758
## Age       0.05471559  0.05316732 -6.100094e-05  0.005392302 -0.03464854
##             is_31015    is_31016 isNot_pamplona before_1980 between_1980_2006
## meanTout -0.08237367  0.08156518    -0.08957000 -0.04364346        0.04018246
## Gender   -0.03124543  0.08491892     0.08158191 -0.05416186       -0.01231625
## Age       0.02585977 -0.07008056     0.08321341  0.06668020        0.12622650
##             after_2007 dwelling_OldTown dwelling_Block dwelling_Tower
## meanTout  0.0004299108      -0.08371100     0.19635348    -0.10222558
## Gender    0.0645917881      -0.02761085     0.01971012    -0.06356862
## Age      -0.1939338014      -0.05209269    -0.14112419     0.07572906
##          dwelling_Detached dwelling_Other    Rehab_No  Rehab_Yes
## meanTout       -0.10603402             NA -0.04049546 0.04049546
## Gender          0.04461155             NA -0.03470942 0.03470942
## Age             0.14058671             NA -0.02336132 0.02336132
##          Income_below1500 Income_between_1500_3500 Income_above_3500
## meanTout       0.06066255              -0.11024342        0.03213456
## Gender         0.09010932              -0.05123298       -0.04078845
## Age           -0.12362216              -0.14090091        0.22209714
##          Occ_NormallyAtHome Occ_NotAlwaysAtHome SrfcArea_below90
## meanTout        -0.14143557          0.07888693      -0.01742477
## Gender          -0.01791303         -0.04378727       0.08630280
## Age              0.11047324         -0.08848730      -0.18775747
##          Storey_UpperFloor Storey_NotApartment numOrient_1 numOrient_above2
## meanTout       -0.01502230         -0.14237088 -0.07956716       0.07956716
## Gender         -0.10938933          0.03600155  0.03089417      -0.03089417
## Age            -0.03937537          0.14410453  0.03477198      -0.03477198
##          LivRoom_SrfcAreaWindow_below2 LivRoom_SrfcAreaWindow_above2
## meanTout                    0.08393268                   -0.08393268
## Gender                      0.06297808                   -0.06297808
## Age                        -0.18178387                    0.18178387
##          Bedroom_SrfcAreaWindow_below2 Bedroom_SrfcAreaWindow_above2
## meanTout                   -0.16374220                    0.16374220
## Gender                     -0.01941129                    0.01941129
## Age                        -0.09087218                    0.09087218
##          AC_Installed_Yes WouldYouInstallAC_Yes  hasCoolRoom
## meanTout       0.06000455           -0.11085214  0.120666791
## Gender         0.04661511            0.01688017  0.079648752
## Age            0.08765250           -0.13133360 -0.004316685
##          hasCoolingAlternatives
## meanTout            -0.09345654
## Gender               0.04218148
## Age                 -0.06412320
```


### Columns to be removed
For preventing linear dependencies in the input matrix. We modify x so and remove similar columns.

```r
columns_to_remove <- c("is_31009", "dwelling_Other")
```


### Index of columns to keep

```r
columns_to_keep <- !(colnames(X_matrix) %in% columns_to_remove)
```


### Remove columns

```r
X_matrix <- X_matrix[, columns_to_keep]
```


### Scale predictors

```r
X_matrix <- scale(X_matrix)
```


## **Analizing data**


### Penalized logistic regression

```r
library(glmnet) # Install and load glmnet package
```

```
## Warning: package 'glmnet' was built under R version 4.1.3
```

```
## Loading required package: Matrix
```

```
## Loaded glmnet 4.1-4
```



```r
# Example using cross-validation to find the best lambda with cv = 5
cv_model <- cv.glmnet(X_matrix, Y, alpha = 1, family = "binomial", nfolds = 10, type.measure = "class")
plot(cv_model)
```

![](climateready_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

```r
# Find the alpha and lambda with the minimum mean cross-validated error
best_lambda <- cv_model$lambda.min
best_lambda
```

```
## [1] 0.05083275
```

```r
best_model <- glmnet(X_matrix, Y, alpha = 1, lambda = best_lambda, family = "binomial")
coef(best_model, s = best_lambda)
```

```
## 66 x 1 sparse Matrix of class "dgCMatrix"
##                                        s1
## (Intercept)                    0.07716766
## meanTout                       .         
## Gender                         0.09947133
## Age                            .         
## NatVent_night                 -0.13096036
## UsesCoolingAlternatives        0.13501635
## hw_True                        0.43121346
## Hour_7_14h_True                .         
## Hour_14_21h_True               .         
## Hour_21_7h_True                .         
## ShadingDevices_No             -0.09223641
## ShadingDevices_WhenDirectSun   .         
## ShadingDevices_AllAfternoon    .         
## ShadingDevices_AllMorning     -0.04685511
## ShadingDevices_AllDay          .         
## NatVent_day_ToutCool           .         
## NatVent_day_Anytime            .         
## NatVent_day_No                 .         
## hasAC_No                       .         
## hasAC_DormOrLiving             .         
## hasAC_DormAndLiving            0.03115462
## hasAC_AllRooms                -0.14677095
## HouseholdSize                  .         
## is_31001                       .         
## is_31002                       .         
## is_31003                       .         
## is_31004                       .         
## is_31005                       .         
## is_31006                       .         
## is_31007                       .         
## is_31008                       .         
## is_31010                       .         
## is_31011                       .         
## is_31012                       .         
## is_31013                       0.12480410
## is_31014                       .         
## is_31015                       .         
## is_31016                       .         
## isNot_pamplona                 .         
## before_1980                    .         
## between_1980_2006              .         
## after_2007                     .         
## dwelling_OldTown               .         
## dwelling_Block                 .         
## dwelling_Tower                 .         
## dwelling_Detached              .         
## Rehab_No                       .         
## Rehab_Yes                      .         
## Income_below1500               .         
## Income_between_1500_3500       .         
## Income_above_3500             -0.02392146
## Occ_NormallyAtHome             .         
## Occ_NotAlwaysAtHome            .         
## SrfcArea_below90               .         
## Storey_UpperFloor              .         
## Storey_NotApartment            .         
## numOrient_1                    .         
## numOrient_above2               .         
## LivRoom_SrfcAreaWindow_below2  .         
## LivRoom_SrfcAreaWindow_above2  .         
## Bedroom_SrfcAreaWindow_below2  .         
## Bedroom_SrfcAreaWindow_above2  .         
## AC_Installed_Yes               .         
## WouldYouInstallAC_Yes          .         
## hasCoolRoom                    .         
## hasCoolingAlternatives         .
```



### Selective inference


```r
library(selectiveInference)
```

```
## Warning: package 'selectiveInference' was built under R version 4.1.3
```

```
## Loading required package: intervals
```

```
## Warning: package 'intervals' was built under R version 4.1.3
```

```
## 
## Attaching package: 'intervals'
```

```
## The following object is masked from 'package:Matrix':
## 
##     expand
```

```
## Loading required package: survival
```

```
## Loading required package: adaptMCMC
```

```
## Loading required package: parallel
```

```
## Loading required package: coda
```

```
## Warning: package 'coda' was built under R version 4.1.3
```

```
## Loading required package: MASS
```

```
## 
## Attaching package: 'MASS'
```

```
## The following object is masked from 'package:dplyr':
## 
##     select
```




```r
# extract coef for a given lambda; note the 1/n factor!
# (and here  we DO  include the intercept term)
beta = coef(best_model, x=X_matrix, y=Y, s = best_lambda/n)
```



```r
# compute fixed lambda p-values and selection intervals
model = fixedLassoInf(X_matrix,Y,beta,best_lambda,family="binomial")
```

```
## Warning in fixedLogitLassoInf(x, y, beta, lambda, alpha = alpha, type =
## type, : Solution beta does not satisfy the KKT conditions (to within specified
## tolerances)
```

```r
model
```

```
## 
## Call:
## fixedLassoInf(x = X_matrix, y = Y, beta = beta, lambda = best_lambda, 
##     family = "binomial")
## 
## Testing results at lambda = 0.051, with alpha = 0.100
## 
##  Var   Coef Z-score P-value LowConfPt UpConfPt LowTailArea UpTailArea
##    2  0.294   1.923   0.268    -0.429    0.551       0.050      0.049
##    4 -0.474  -2.983   0.092    -0.728    0.128       0.049      0.050
##    5  0.324   2.062   0.171    -0.251    0.575       0.049      0.048
##    6  0.674   4.360   0.000     0.405    0.929       0.048      0.050
##   10 -0.391  -2.454   0.233    -0.629    0.451       0.050      0.050
##   13 -0.252  -1.663   0.538    -0.576    1.222       0.049      0.050
##   20  0.227   1.494   0.685    -2.009    0.381       0.050      0.050
##   21 -0.352  -2.201   0.139    -0.677    0.201       0.050      0.049
##   34  0.349   2.076   0.208    -0.355    0.616       0.049      0.050
##   50 -0.217  -1.409   0.756    -0.350    2.758       0.050      0.050
## 
## Note: coefficients shown are full regression coefficients
```





# **Hierarchical Clustering**

## **Loading & Inspecting data**

### Set working directory
Set the folder location


### Set the seed for reproducibility

```r
set.seed(1)  # Replace 123 with your desired seed value 
```

### Read the csv

```r
df <- read.csv("R_logistic_hclust.csv", sep=";")
head(df, 3)
```

```
##   meanTout Gender Age NatVent_night UsesCoolingAlternatives hw_True
## 1     27.5   True  39          True                   False   False
## 2     27.5   True  29          True                   False   False
## 3     18.1  False  55         False                   False   False
##   Hour_7_14h_True Hour_14_21h_True Hour_21_7h_True ShadingDevices_No
## 1            True            False           False             False
## 2           False             True           False             False
## 3            True            False           False              True
##   ShadingDevices_WhenDirectSun ShadingDevices_AllAfternoon
## 1                        False                       False
## 2                        False                       False
## 3                        False                       False
##   ShadingDevices_AllMorning ShadingDevices_AllDay NatVent_day_ToutCool
## 1                     False                  True                 True
## 2                     False                  True                 True
## 3                     False                 False                 True
##   NatVent_day_Anytime NatVent_day_No hasAC_No hasAC_DormOrLiving
## 1               False          False     True              False
## 2               False          False     True              False
## 3               False          False     True              False
##   hasAC_DormAndLiving hasAC_AllRooms HouseholdSize is_31001 is_31002 is_31003
## 1               False          False             2    False    False    False
## 2               False          False             3    False    False    False
## 3               False          False             4    False    False    False
##   is_31004 is_31005 is_31006 is_31007 is_31008 is_31009 is_31010 is_31011
## 1    False    False    False    False    False    False    False    False
## 2    False    False    False     True    False    False    False    False
## 3    False    False    False    False     True    False    False    False
##   is_31012 is_31013 is_31014 is_31015 is_31016 isNot_pamplona before_1980
## 1    False    False    False    False     True          False       False
## 2    False    False    False    False    False          False       False
## 3    False    False    False    False    False          False        True
##   between_1980_2006 after_2007 dwelling_OldTown dwelling_Block dwelling_Tower
## 1              True      False            False           True          False
## 2              True      False            False           True          False
## 3             False      False            False          False           True
##   dwelling_Detached dwelling_Other Rehab_No Rehab_Yes Income_below1500
## 1             False          False     True     False            False
## 2             False          False    False      True            False
## 3             False          False    False      True            False
##   Income_between_1500_3500 Income_above_3500 Occ_NormallyAtHome
## 1                    False              True               True
## 2                     True             False              False
## 3                    False              True              False
##   Occ_NotAlwaysAtHome SrfcArea_below90 Storey_UpperFloor Storey_NotApartment
## 1               False            False             False               False
## 2                True             True             False               False
## 3                True            False             False               False
##   numOrient_1 numOrient_above2 LivRoom_SrfcAreaWindow_below2
## 1       False             True                         False
## 2       False             True                         False
## 3       False             True                         False
##   LivRoom_SrfcAreaWindow_above2 Bedroom_SrfcAreaWindow_below2
## 1                          True                         False
## 2                          True                         False
## 3                          True                         False
##   Bedroom_SrfcAreaWindow_above2 AC_Installed_Yes WouldYouInstallAC_Yes
## 1                          True            False                 False
## 2                          True            False                  True
## 3                          True            False                 False
##   hasCoolRoom hasCoolingAlternatives cluster_hierarchical
## 1        True                   True                    0
## 2       False                   True                    0
## 3       False                  False                    0
```


## **Pre-processing data**

### Function to convert TRUE/FALSE to 1/0

```r
library(dplyr)

convert_to_binary <- function(x) {
  as.numeric(x)
}
```

###Apply the function to all columns except the first one (assuming it's the index)

```r
data_transformed <- df %>%
  mutate_all(~ ifelse(. == "True", 1, ifelse(. == "False", 0, .)))
```


### Print the transformed data

```r
head(data_transformed,3)
```

```
##   meanTout Gender Age NatVent_night UsesCoolingAlternatives hw_True
## 1     27.5      1  39             1                       0       0
## 2     27.5      1  29             1                       0       0
## 3     18.1      0  55             0                       0       0
##   Hour_7_14h_True Hour_14_21h_True Hour_21_7h_True ShadingDevices_No
## 1               1                0               0                 0
## 2               0                1               0                 0
## 3               1                0               0                 1
##   ShadingDevices_WhenDirectSun ShadingDevices_AllAfternoon
## 1                            0                           0
## 2                            0                           0
## 3                            0                           0
##   ShadingDevices_AllMorning ShadingDevices_AllDay NatVent_day_ToutCool
## 1                         0                     1                    1
## 2                         0                     1                    1
## 3                         0                     0                    1
##   NatVent_day_Anytime NatVent_day_No hasAC_No hasAC_DormOrLiving
## 1                   0              0        1                  0
## 2                   0              0        1                  0
## 3                   0              0        1                  0
##   hasAC_DormAndLiving hasAC_AllRooms HouseholdSize is_31001 is_31002 is_31003
## 1                   0              0             2        0        0        0
## 2                   0              0             3        0        0        0
## 3                   0              0             4        0        0        0
##   is_31004 is_31005 is_31006 is_31007 is_31008 is_31009 is_31010 is_31011
## 1        0        0        0        0        0        0        0        0
## 2        0        0        0        1        0        0        0        0
## 3        0        0        0        0        1        0        0        0
##   is_31012 is_31013 is_31014 is_31015 is_31016 isNot_pamplona before_1980
## 1        0        0        0        0        1              0           0
## 2        0        0        0        0        0              0           0
## 3        0        0        0        0        0              0           1
##   between_1980_2006 after_2007 dwelling_OldTown dwelling_Block dwelling_Tower
## 1                 1          0                0              1              0
## 2                 1          0                0              1              0
## 3                 0          0                0              0              1
##   dwelling_Detached dwelling_Other Rehab_No Rehab_Yes Income_below1500
## 1                 0              0        1         0                0
## 2                 0              0        0         1                0
## 3                 0              0        0         1                0
##   Income_between_1500_3500 Income_above_3500 Occ_NormallyAtHome
## 1                        0                 1                  1
## 2                        1                 0                  0
## 3                        0                 1                  0
##   Occ_NotAlwaysAtHome SrfcArea_below90 Storey_UpperFloor Storey_NotApartment
## 1                   0                0                 0                   0
## 2                   1                1                 0                   0
## 3                   1                0                 0                   0
##   numOrient_1 numOrient_above2 LivRoom_SrfcAreaWindow_below2
## 1           0                1                             0
## 2           0                1                             0
## 3           0                1                             0
##   LivRoom_SrfcAreaWindow_above2 Bedroom_SrfcAreaWindow_below2
## 1                             1                             0
## 2                             1                             0
## 3                             1                             0
##   Bedroom_SrfcAreaWindow_above2 AC_Installed_Yes WouldYouInstallAC_Yes
## 1                             1                0                     0
## 2                             1                0                     1
## 3                             1                0                     0
##   hasCoolRoom hasCoolingAlternatives cluster_hierarchical
## 1           1                      1                    0
## 2           0                      1                    0
## 3           0                      0                    0
```

```r
names(data_transformed)
```

```
##  [1] "meanTout"                      "Gender"                       
##  [3] "Age"                           "NatVent_night"                
##  [5] "UsesCoolingAlternatives"       "hw_True"                      
##  [7] "Hour_7_14h_True"               "Hour_14_21h_True"             
##  [9] "Hour_21_7h_True"               "ShadingDevices_No"            
## [11] "ShadingDevices_WhenDirectSun"  "ShadingDevices_AllAfternoon"  
## [13] "ShadingDevices_AllMorning"     "ShadingDevices_AllDay"        
## [15] "NatVent_day_ToutCool"          "NatVent_day_Anytime"          
## [17] "NatVent_day_No"                "hasAC_No"                     
## [19] "hasAC_DormOrLiving"            "hasAC_DormAndLiving"          
## [21] "hasAC_AllRooms"                "HouseholdSize"                
## [23] "is_31001"                      "is_31002"                     
## [25] "is_31003"                      "is_31004"                     
## [27] "is_31005"                      "is_31006"                     
## [29] "is_31007"                      "is_31008"                     
## [31] "is_31009"                      "is_31010"                     
## [33] "is_31011"                      "is_31012"                     
## [35] "is_31013"                      "is_31014"                     
## [37] "is_31015"                      "is_31016"                     
## [39] "isNot_pamplona"                "before_1980"                  
## [41] "between_1980_2006"             "after_2007"                   
## [43] "dwelling_OldTown"              "dwelling_Block"               
## [45] "dwelling_Tower"                "dwelling_Detached"            
## [47] "dwelling_Other"                "Rehab_No"                     
## [49] "Rehab_Yes"                     "Income_below1500"             
## [51] "Income_between_1500_3500"      "Income_above_3500"            
## [53] "Occ_NormallyAtHome"            "Occ_NotAlwaysAtHome"          
## [55] "SrfcArea_below90"              "Storey_UpperFloor"            
## [57] "Storey_NotApartment"           "numOrient_1"                  
## [59] "numOrient_above2"              "LivRoom_SrfcAreaWindow_below2"
## [61] "LivRoom_SrfcAreaWindow_above2" "Bedroom_SrfcAreaWindow_below2"
## [63] "Bedroom_SrfcAreaWindow_above2" "AC_Installed_Yes"             
## [65] "WouldYouInstallAC_Yes"         "hasCoolRoom"                  
## [67] "hasCoolingAlternatives"        "cluster_hierarchical"
```

```r
length(data_transformed)
```

```
## [1] 68
```

```r
nrow(data_transformed)
```

```
## [1] 189
```

```r
n = nrow(data_transformed)
n
```

```
## [1] 189
```




### Define the response variables

```r
# Specify the variable to be used as Y response
Y_response <- "cluster_hierarchical"

# Extract the Y response
Y <- data_transformed[, Y_response]

# Extract the X response (all other variables)
X <- data_transformed[, setdiff(names(data_transformed), Y_response)]
```


### Identify variables to exclude from conversion to integer

```r
exclude_variables <- c("Age", "meanTout")
```


### Convert all other variables to integer

```r
X[, setdiff(names(X), exclude_variables)] <- lapply(X[, setdiff(names(X), exclude_variables)], as.integer)
```


### Verify the changes

```r
str(X)
```

```
## 'data.frame':	189 obs. of  67 variables:
##  $ meanTout                     : num  27.5 27.5 18.1 29.2 20.7 26.8 16.8 29.1 26.8 15.8 ...
##  $ Gender                       : int  1 1 0 1 0 0 1 1 1 0 ...
##  $ Age                          : int  39 29 55 44 43 43 54 40 26 44 ...
##  $ NatVent_night                : int  1 1 0 0 1 1 1 1 1 1 ...
##  $ UsesCoolingAlternatives      : int  0 0 0 0 1 1 0 0 1 0 ...
##  $ hw_True                      : int  0 0 0 1 0 1 0 1 1 0 ...
##  $ Hour_7_14h_True              : int  1 0 1 0 0 1 0 0 0 0 ...
##  $ Hour_14_21h_True             : int  0 1 0 1 1 0 0 0 1 0 ...
##  $ Hour_21_7h_True              : int  0 0 0 0 0 0 1 1 0 1 ...
##  $ ShadingDevices_No            : int  0 0 1 0 0 0 0 0 0 0 ...
##  $ ShadingDevices_WhenDirectSun : int  0 0 0 0 0 0 0 0 1 1 ...
##  $ ShadingDevices_AllAfternoon  : int  0 0 0 0 0 1 0 0 0 0 ...
##  $ ShadingDevices_AllMorning    : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ ShadingDevices_AllDay        : int  1 1 0 1 1 0 1 1 0 0 ...
##  $ NatVent_day_ToutCool         : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ NatVent_day_Anytime          : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ NatVent_day_No               : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ hasAC_No                     : int  1 1 1 0 1 1 1 0 1 1 ...
##  $ hasAC_DormOrLiving           : int  0 0 0 1 0 0 0 1 0 0 ...
##  $ hasAC_DormAndLiving          : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ hasAC_AllRooms               : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ HouseholdSize                : int  2 3 4 4 2 3 2 2 5 6 ...
##  $ is_31001                     : int  0 0 0 0 0 0 1 0 0 0 ...
##  $ is_31002                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31003                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31004                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31005                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31006                     : int  0 0 0 0 0 0 0 0 1 0 ...
##  $ is_31007                     : int  0 1 0 0 0 0 0 0 0 0 ...
##  $ is_31008                     : int  0 0 1 0 0 0 0 0 0 0 ...
##  $ is_31009                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31010                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31011                     : int  0 0 0 0 0 0 0 1 0 0 ...
##  $ is_31012                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31013                     : int  0 0 0 0 1 0 0 0 0 0 ...
##  $ is_31014                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31015                     : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ is_31016                     : int  1 0 0 0 0 0 0 0 0 0 ...
##  $ isNot_pamplona               : int  0 0 0 1 0 1 0 0 0 1 ...
##  $ before_1980                  : int  0 0 1 0 0 0 1 1 0 0 ...
##  $ between_1980_2006            : int  1 1 0 1 1 0 0 0 0 1 ...
##  $ after_2007                   : int  0 0 0 0 0 1 0 0 1 0 ...
##  $ dwelling_OldTown             : int  0 0 0 0 0 0 1 0 0 0 ...
##  $ dwelling_Block               : int  1 1 0 1 0 0 0 1 1 0 ...
##  $ dwelling_Tower               : int  0 0 1 0 1 1 0 0 0 0 ...
##  $ dwelling_Detached            : int  0 0 0 0 0 0 0 0 0 1 ...
##  $ dwelling_Other               : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ Rehab_No                     : int  1 0 0 0 0 0 0 1 1 1 ...
##  $ Rehab_Yes                    : int  0 1 1 1 1 1 1 0 0 0 ...
##  $ Income_below1500             : int  0 0 0 1 1 1 0 0 0 0 ...
##  $ Income_between_1500_3500     : int  0 1 0 0 0 0 1 0 0 0 ...
##  $ Income_above_3500            : int  1 0 1 0 0 0 0 1 1 1 ...
##  $ Occ_NormallyAtHome           : int  1 0 0 0 0 0 1 0 0 1 ...
##  $ Occ_NotAlwaysAtHome          : int  0 1 1 1 1 1 1 1 1 1 ...
##  $ SrfcArea_below90             : int  0 1 0 1 1 0 1 0 0 0 ...
##  $ Storey_UpperFloor            : int  0 0 0 0 1 0 0 0 0 0 ...
##  $ Storey_NotApartment          : int  0 0 0 0 0 0 0 0 0 1 ...
##  $ numOrient_1                  : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ numOrient_above2             : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ LivRoom_SrfcAreaWindow_below2: int  0 0 0 0 0 1 0 0 0 0 ...
##  $ LivRoom_SrfcAreaWindow_above2: int  1 1 1 1 1 0 1 1 1 1 ...
##  $ Bedroom_SrfcAreaWindow_below2: int  0 0 0 0 1 1 1 0 0 1 ...
##  $ Bedroom_SrfcAreaWindow_above2: int  1 1 1 1 0 0 0 1 1 0 ...
##  $ AC_Installed_Yes             : int  0 0 0 0 0 0 0 1 0 0 ...
##  $ WouldYouInstallAC_Yes        : int  0 1 0 0 0 0 1 0 1 1 ...
##  $ hasCoolRoom                  : int  1 0 0 1 0 0 0 1 0 1 ...
##  $ hasCoolingAlternatives       : int  1 1 0 1 1 1 1 1 1 1 ...
```

```r
X_matrix <- as.matrix(X)
sum(Y) 
```

```
## [1] 113
```

```r
head(cor(X_matrix),3)
```

```
## Warning in cor(X_matrix): the standard deviation is zero
```

```
##            meanTout     Gender        Age NatVent_night UsesCoolingAlternatives
## meanTout  1.0000000  0.1307767 -0.1101982   -0.04064627              0.06632550
## Gender    0.1307767  1.0000000 -0.1423769    0.03327403             -0.02237790
## Age      -0.1101982 -0.1423769  1.0000000   -0.01101263             -0.06230988
##              hw_True Hour_7_14h_True Hour_14_21h_True Hour_21_7h_True
## meanTout  0.64636441     -0.10655178       0.18071676     -0.10548001
## Gender    0.13105838     -0.06065691      -0.01231625      0.11106030
## Age      -0.04154947      0.04883595      -0.03796215     -0.01829873
##          ShadingDevices_No ShadingDevices_WhenDirectSun
## meanTout       -0.02250576                 -0.072160114
## Gender          0.01119659                 -0.079213768
## Age            -0.18236903                  0.009446952
##          ShadingDevices_AllAfternoon ShadingDevices_AllMorning
## meanTout                  0.01048686              -0.042545055
## Gender                   -0.10825968              -0.005800514
## Age                      -0.02431157               0.046055713
##          ShadingDevices_AllDay NatVent_day_ToutCool NatVent_day_Anytime
## meanTout            0.08698008         -0.122249775         0.072688735
## Gender              0.08865921          0.014818372         0.006207313
## Age                 0.05592127         -0.006389317        -0.001543991
##          NatVent_day_No    hasAC_No hasAC_DormOrLiving hasAC_DormAndLiving
## meanTout     0.09741886 -0.03281046        0.060098794         -0.01822256
## Gender      -0.02850635 -0.02710528        0.002625832          0.08555758
## Age          0.01103213 -0.07684401        0.102986999          0.01915430
##          hasAC_AllRooms HouseholdSize    is_31001     is_31002    is_31003
## meanTout   -0.008530845   -0.14867237 -0.09489291  0.051096534 -0.09636606
## Gender     -0.010212858    0.04247325 -0.01021286 -0.005800514  0.04913324
## Age        -0.011384744    0.12336614 -0.04521677  0.199778091  0.05513891
##             is_31004     is_31005    is_31006    is_31007     is_31008 is_31009
## meanTout -0.03016554  0.051096534  0.07067259  0.09732405  0.118293314       NA
## Gender   -0.02850635 -0.005800514  0.03089417 -0.09789402 -0.120300727       NA
## Age       0.09214483 -0.103823607 -0.20485991 -0.02857215  0.008472426       NA
##             is_31010    is_31011      is_31012     is_31013    is_31014
## meanTout -0.19012245 -0.09273633  4.015141e-02  0.005229221  0.07663515
## Gender   -0.04192035  0.02883180 -5.800514e-03 -0.008270131  0.08555758
## Age       0.05471559  0.05316732 -6.100094e-05  0.005392302 -0.03464854
##             is_31015    is_31016 isNot_pamplona before_1980 between_1980_2006
## meanTout -0.08237367  0.08156518    -0.08957000 -0.04364346        0.04018246
## Gender   -0.03124543  0.08491892     0.08158191 -0.05416186       -0.01231625
## Age       0.02585977 -0.07008056     0.08321341  0.06668020        0.12622650
##             after_2007 dwelling_OldTown dwelling_Block dwelling_Tower
## meanTout  0.0004299108      -0.08371100     0.19635348    -0.10222558
## Gender    0.0645917881      -0.02761085     0.01971012    -0.06356862
## Age      -0.1939338014      -0.05209269    -0.14112419     0.07572906
##          dwelling_Detached dwelling_Other    Rehab_No  Rehab_Yes
## meanTout       -0.10603402             NA -0.04049546 0.04049546
## Gender          0.04461155             NA -0.03470942 0.03470942
## Age             0.14058671             NA -0.02336132 0.02336132
##          Income_below1500 Income_between_1500_3500 Income_above_3500
## meanTout       0.06066255              -0.11024342        0.03213456
## Gender         0.09010932              -0.05123298       -0.04078845
## Age           -0.12362216              -0.14090091        0.22209714
##          Occ_NormallyAtHome Occ_NotAlwaysAtHome SrfcArea_below90
## meanTout        -0.14143557          0.07888693      -0.01742477
## Gender          -0.01791303         -0.04378727       0.08630280
## Age              0.11047324         -0.08848730      -0.18775747
##          Storey_UpperFloor Storey_NotApartment numOrient_1 numOrient_above2
## meanTout       -0.01502230         -0.14237088 -0.07956716       0.07956716
## Gender         -0.10938933          0.03600155  0.03089417      -0.03089417
## Age            -0.03937537          0.14410453  0.03477198      -0.03477198
##          LivRoom_SrfcAreaWindow_below2 LivRoom_SrfcAreaWindow_above2
## meanTout                    0.08393268                   -0.08393268
## Gender                      0.06297808                   -0.06297808
## Age                        -0.18178387                    0.18178387
##          Bedroom_SrfcAreaWindow_below2 Bedroom_SrfcAreaWindow_above2
## meanTout                   -0.16374220                    0.16374220
## Gender                     -0.01941129                    0.01941129
## Age                        -0.09087218                    0.09087218
##          AC_Installed_Yes WouldYouInstallAC_Yes  hasCoolRoom
## meanTout       0.06000455           -0.11085214  0.120666791
## Gender         0.04661511            0.01688017  0.079648752
## Age            0.08765250           -0.13133360 -0.004316685
##          hasCoolingAlternatives
## meanTout            -0.09345654
## Gender               0.04218148
## Age                 -0.06412320
```


### Columns to be removed
For preventing linear dependencies in the input matrix. We modify x so and remove similar columns.

```r
columns_to_remove <- c("is_31009", "dwelling_Other")
```


### Index of columns to keep

```r
columns_to_keep <- !(colnames(X_matrix) %in% columns_to_remove)
```


### Remove columns

```r
X_matrix <- X_matrix[, columns_to_keep]
```


### Scale predictors

```r
X_matrix <- scale(X_matrix)
```


## **Analizing data**


### Penalized logistic regression

```r
library(glmnet) # Install and load glmnet package
```



```r
# Example using cross-validation to find the best lambda with cv = 5
cv_model <- cv.glmnet(X_matrix, Y, alpha = 1, family = "binomial", nfolds = 10, type.measure = "class")
plot(cv_model)
```

![](climateready_files/figure-html/unnamed-chunk-35-1.png)<!-- -->

```r
# Find the alpha and lambda with the minimum mean cross-validated error
best_lambda <- cv_model$lambda.min
best_lambda
```

```
## [1] 0.05266225
```

```r
best_model <- glmnet(X_matrix, Y, alpha = 1, lambda = best_lambda, family = "binomial")
coef(best_model, s = best_lambda)
```

```
## 66 x 1 sparse Matrix of class "dgCMatrix"
##                                        s1
## (Intercept)                    0.41614486
## meanTout                       .         
## Gender                         0.02864172
## Age                            .         
## NatVent_night                  .         
## UsesCoolingAlternatives        0.17456155
## hw_True                        0.40843268
## Hour_7_14h_True                .         
## Hour_14_21h_True               .         
## Hour_21_7h_True                .         
## ShadingDevices_No              .         
## ShadingDevices_WhenDirectSun   .         
## ShadingDevices_AllAfternoon    .         
## ShadingDevices_AllMorning      .         
## ShadingDevices_AllDay          .         
## NatVent_day_ToutCool           .         
## NatVent_day_Anytime            .         
## NatVent_day_No                 .         
## hasAC_No                       .         
## hasAC_DormOrLiving             .         
## hasAC_DormAndLiving            .         
## hasAC_AllRooms                -0.21428389
## HouseholdSize                  0.06018011
## is_31001                       .         
## is_31002                       .         
## is_31003                       .         
## is_31004                       .         
## is_31005                       .         
## is_31006                       .         
## is_31007                       .         
## is_31008                       .         
## is_31010                       .         
## is_31011                       .         
## is_31012                       .         
## is_31013                       0.04436435
## is_31014                       .         
## is_31015                       .         
## is_31016                       .         
## isNot_pamplona                 .         
## before_1980                    .         
## between_1980_2006              .         
## after_2007                     .         
## dwelling_OldTown               .         
## dwelling_Block                 .         
## dwelling_Tower                 .         
## dwelling_Detached              .         
## Rehab_No                       .         
## Rehab_Yes                      .         
## Income_below1500               .         
## Income_between_1500_3500       .         
## Income_above_3500              .         
## Occ_NormallyAtHome             .         
## Occ_NotAlwaysAtHome            .         
## SrfcArea_below90               .         
## Storey_UpperFloor              .         
## Storey_NotApartment            .         
## numOrient_1                    .         
## numOrient_above2               .         
## LivRoom_SrfcAreaWindow_below2  .         
## LivRoom_SrfcAreaWindow_above2  .         
## Bedroom_SrfcAreaWindow_below2  .         
## Bedroom_SrfcAreaWindow_above2  .         
## AC_Installed_Yes               .         
## WouldYouInstallAC_Yes          .         
## hasCoolRoom                   -0.02924841
## hasCoolingAlternatives         .
```



### Selective inference


```r
library(selectiveInference)
```




```r
# extract coef for a given lambda; note the 1/n factor!
# (and here  we DO  include the intercept term)
beta = coef(best_model, x=X_matrix, y=Y, s = best_lambda/n)
```



```r
# compute fixed lambda p-values and selection intervals
model = fixedLassoInf(X_matrix,Y,beta,best_lambda,family="binomial")
```

```
## Warning in fixedLogitLassoInf(x, y, beta, lambda, alpha = alpha, type =
## type, : Solution beta does not satisfy the KKT conditions (to within specified
## tolerances)
```

```r
model
```

```
## 
## Call:
## fixedLassoInf(x = X_matrix, y = Y, beta = beta, lambda = best_lambda, 
##     family = "binomial")
## 
## Testing results at lambda = 0.053, with alpha = 0.100
## 
##  Var   Coef Z-score P-value LowConfPt UpConfPt LowTailArea UpTailArea
##    2  0.240   1.552   0.703    -2.267    0.386       0.050      0.049
##    5  0.342   2.156   0.107    -0.125    0.659       0.050      0.049
##    6  0.685   4.413   0.002     0.341    1.047       0.049      0.049
##   21 -0.458  -2.913   0.030    -0.717   -0.066       0.048      0.049
##   22  0.389   2.458   0.371    -0.926    0.603       0.000      0.049
##   34  0.259   1.568   0.603    -1.598    0.461       0.050      0.050
##   64 -0.322  -2.037   0.650    -0.472    2.238       0.049      0.050
## 
## Note: coefficients shown are full regression coefficients
```











