# Exploratory plots of restoration activities in TB


```r
library(tidyverse)
library(readxl)
library(ggmap)
library(lubridate)
library(geosphere)
library(stringi)
library(tibble)
knitr::knit('tbrest.Rmd', tangle = TRUE)
file.copy('tbrest.R', 'R/tbrest.R', overwrite = TRUE)
file.remove('tbrest.R')

# source R files
source('R/get_chg.R')
source('R/get_clo.R')
source('R/get_cdt.R')
source('R/get_brk.R')
```

## Restoration data


```r
data(restdat)
data(reststat)
```

Habitat restoration projects:

```r
head(restdat)
```

```
## # A tibble: 6 x 6
##    date                   tech                type   top  acre    id
##   <dbl>                  <chr>               <chr> <chr> <chr> <chr>
## 1  2005 HYDROLOGIC_RESTORATION HABITAT_ENHANCEMENT   hab  12.8  3F3S
## 2  2004         EXOTIC_CONTROL HABITAT_ENHANCEMENT   hab 123.9  6COa
## 3  2005         EXOTIC_CONTROL HABITAT_ENHANCEMENT   hab 123.9  F6iK
## 4  2006 HYDROLOGIC_RESTORATION HABITAT_ENHANCEMENT   hab    45  YqTO
## 5  2000         EXOTIC_CONTROL HABITAT_ENHANCEMENT   hab  0.25  OSr2
## 6  1989 HYDROLOGIC_RESTORATION HABITAT_ENHANCEMENT   hab    50  dLmu
```
Locations of habitat restoration projects:

```r
head(reststat)
```

```
## # A tibble: 6 x 3
##      id      lat       lon
##   <chr>    <dbl>     <dbl>
## 1  3F3S 27.88977 -82.39888
## 2  6COa 27.88994 -82.40340
## 3  F6iK 27.88181 -82.39783
## 4  YqTO 27.97370 -82.71504
## 5  OSr2 27.81921 -82.28548
## 6  dLmu 27.99817 -82.61724
```

## WQ data


```r
wqdat_raw <- read_csv('data-raw/epchc_clean_data_07162017.csv')

# rename, select relevant columns, integrate variables across depths
# annual averages by site, variable
wqdat <- wqdat_raw %>% 
  rename(
    yr = YEAR,
    mo = month,
    dttm = SampleTime,
    stat = epchc_station, 
    lat = Latitude, 
    lon = Longitude,
    sallo = Sal_Bottom_ppth, 
    salmd = Sal_Mid_ppth,
    salhi = Sal_Top_ppth, 
    dolo = DO_Bottom_mg_L,
    domd = DO_Mid_mg_L, 
    dohi = DO_Top_mg_L,
    chla = chl_a
  ) %>% 
  select(stat, yr, mo, dttm, lat, lon, sallo, salmd, salhi, dolo, domd, dohi, chla) %>% 
  gather('var', 'val', sallo:chla) %>% 
  mutate(val = as.numeric(val)) %>% 
  spread('var', 'val') %>% 
  rowwise() %>%
  mutate(
    sal = mean(c(sallo, salmd, salhi), na.rm = TRUE),
    do = mean(c(dolo, domd, dohi), na.rm = TRUE)
  ) %>%
  select(-sallo, -salmd, -salhi, -dolo, -domd, -dohi, -dttm) %>% 
  mutate(
    dy = 1
  ) %>% 
  unite('datetime', yr, mo, dy, sep = '-') %>% 
  mutate(
    datetime = as.Date(datetime, format = '%Y-%m-%d')
  )

# get station locations
wqstat <- wqdat %>% 
  select(stat, lon, lat) %>% 
  unique

# remove denormalized rows
wqdat <- wqdat %>% 
  select(-lon, -lat)
  
save(wqstat, file= 'data/wqstat.RData', compress = 'xz')
save(wqdat, file = 'data/wqdat.RData', compress = 'xz')
```

Water quality station lat/lon:

```r
head(wqstat)
```

```
## # A tibble: 6 x 3
##    stat      lon     lat
##   <int>    <dbl>   <dbl>
## 1    47 -82.6202 27.9726
## 2    60 -82.6316 27.9899
## 3    46 -82.6593 27.9904
## 4    64 -82.6833 27.9794
## 5    66 -82.6397 27.9278
## 6    40 -82.5873 27.9291
```

Water quality data:

```r
head(wqdat)
```

```
## # A tibble: 6 x 5
##    stat   datetime  chla   sal    do
##   <int>     <date> <dbl> <dbl> <dbl>
## 1    47 1974-01-01    NA  21.1   7.9
## 2    60 1974-01-01    NA  21.3   8.2
## 3    46 1974-01-01     3  17.4   8.3
## 4    64 1974-01-01     2  19.1   8.2
## 5    66 1974-01-01    NA  21.3   8.1
## 6    40 1974-01-01    NA  22.0   8.4
```

## Distance to restoration sites {.tabset}


```r
wqmtch <- get_clo(restdat, reststat, wqstat, resgrp = 'top', mtch = 10)
head(wqmtch)
```

```
## # A tibble: 6 x 5
##    stat resgrp   rnk    id     dist
##   <int>  <chr> <int> <chr>    <dbl>
## 1    47    hab     1  dLmu 2861.746
## 2    47    hab     2  DyAP 2971.000
## 3    47    hab     3  P2gv 4526.348
## 4    47    hab     4  Wxg6 4526.348
## 5    47    hab     5  ruky 4526.348
## 6    47    hab     6  cTzf 4526.348
```

### Closest 

```r
## 
# plots

# combine lat/lon for the plot
toplo <- wqmtch %>% 
  left_join(wqstat, by = 'stat') %>% 
  left_join(reststat, by = 'id') %>% 
  rename(
    `Restoration\ngroup` = resgrp,
    `Distance (dd)` = dist
  )
    
# restoration project grouping column
resgrp <- 'top'
restall <- left_join(restdat, reststat, by = 'id')
names(restall)[names(restall) %in% resgrp] <- 'Restoration\ngroup'

# extent
ext <- make_bbox(wqstat$lon, wqstat$lat, f = 0.1)
map <- get_stamenmap(ext, zoom = 12, maptype = "toner-lite")

# base map
pbase <- ggmap(map) +
  theme_bw() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  ) +
  geom_point(data = restall, aes(x = lon, y = lat, fill = `Restoration\ngroup`), size = 4, pch = 21) +
  geom_point(data = wqstat, aes(x = lon, y = lat), size = 2)

# closest
toplo1 <- filter(toplo, rnk %in% 1)

pbase + 
  geom_segment(data = toplo1, aes(x = lon.x, y = lat.x, xend = lon.y, yend = lat.y, alpha = -`Distance (dd)`, linetype = `Restoration\ngroup`), size = 1)
```

![](tbrest_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

### Closest five

```r
# closest five
toplo2 <- filter(toplo, rnk %in% c(1:5))

pbase + 
  geom_segment(data = toplo2, aes(x = lon.x, y = lat.x, xend = lon.y, yend = lat.y, alpha = -`Distance (dd)`, linetype = `Restoration\ngroup`), size = 1)
```

![](tbrest_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

### Closest ten

```r
# closest twenty
toplo3 <- filter(toplo, rnk %in% c(1:10))

pbase + 
  geom_segment(data = toplo3, aes(x = lon.x, y = lat.x, xend = lon.y, yend = lat.y, alpha = -`Distance (dd)`, linetype = `Restoration\ngroup`), size = 1)
```

![](tbrest_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

## Summarizing effects of restoration projects

Get weighted average of project type, treatment (before, after) of salinity for all wq station, restoration site combinations.

```r
salchg <- get_chg(wqdat, wqmtch, statdat, restdat, wqvar = 'sal', yrdf = 5)
save(salchg, file = 'data/salchg.RData', compress = 'xz')

head(salchg)
```

```
## # A tibble: 6 x 4
## # Groups:   stat, resgrp [3]
##    stat resgrp   trt     cval
##   <int>  <chr> <chr>    <dbl>
## 1     6    hab   aft 24.67069
## 2     6    hab   bef 24.90016
## 3     6    wtr   aft 25.27052
## 4     6    wtr   bef 24.92134
## 5     7    hab   aft 25.92751
## 6     7    hab   bef 25.25877
```

Get conditional probability distributions for the restoration type, treatment effects, salinity as first child node in network. 

```r
wqcdt <- get_cdt(salchg)
head(wqcdt)
```

```
## # A tibble: 4 x 5
##   resgrp   trt              data       crv                    prd
##    <chr> <chr>            <list>    <list>                 <list>
## 1    hab   aft <tibble [45 x 2]> <dbl [2]> <data.frame [100 x 3]>
## 2    hab   bef <tibble [45 x 2]> <dbl [2]> <data.frame [100 x 3]>
## 3    wtr   aft <tibble [45 x 2]> <dbl [2]> <data.frame [100 x 3]>
## 4    wtr   bef <tibble [45 x 2]> <dbl [2]> <data.frame [100 x 3]>
```

Empirical and estimated distributions.  

```r
salbrk <- get_brk(wqcdt)

salbrk
```

```
## # A tibble: 12 x 5
##    resgrp   trt      qts       brk  clev
##     <chr> <chr>    <dbl>     <dbl> <dbl>
##  1    hab   aft 25.94608 0.2986726     1
##  2    hab   aft 28.65820 0.6919804     2
##  3    hab   aft 31.37031 0.9330526     3
##  4    hab   bef 24.64153 0.2252350     1
##  5    hab   bef 27.66066 0.6466346     2
##  6    hab   bef 30.67979 0.9317494     3
##  7    wtr   aft 25.27537 0.2543405     1
##  8    wtr   aft 28.08864 0.6547678     2
##  9    wtr   aft 30.90190 0.9242771     3
## 10    wtr   bef 25.83250 0.2989815     1
## 11    wtr   bef 28.37717 0.7051529     2
## 12    wtr   bef 30.92185 0.9421645     3
```

A plot showing the breaks:

```r
toplo <- select(wqcdt, -data, -crv) %>% 
  unnest
ggplot(toplo, aes(x = cval, y = cumest, group = trt)) + 
  geom_line(aes(colour = trt)) + 
  geom_segment(data = salbrk, aes(x = qts, y = 0, xend = qts, yend = brk, linetype = factor(clev), colour = trt)) +
  geom_segment(data = salbrk, aes(x = min(toplo$cval), y = brk, xend = qts, yend = brk, linetype = factor(clev), colour = trt)) +
  facet_grid(~ resgrp) +
  theme_bw()
```

![](tbrest_files/figure-html/unnamed-chunk-15-1.png)<!-- -->



