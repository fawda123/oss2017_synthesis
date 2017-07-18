# Exploratory plots of restoration activities in TB

Load libraries:


```r
library(tidyverse)
library(readxl)
library(ggmap)
library(lubridate)
library(geosphere)
library(stringi)
```

## Restoration data

Barplots of restoration projects by category, year:


```r
fl <- 'data-raw/TBEP_Restoration Database_11_21_07_JRH.csv'

# clean up habitat restoration data
habdat <- fl %>% 
  read_csv %>% 
  select(Latitude, Longitude, Project_Completion_Date, `Restoration Category`, `Activity-1`, `Acres-1`) %>% 
  rename(
    lat = Latitude, 
    lon = Longitude, 
    date = Project_Completion_Date, 
    tech = `Restoration Category`, 
    type = `Activity-1`, 
    acre = `Acres-1`
  ) %>% 
  mutate(
    lat = as.numeric(lat),
    lon = as.numeric(lon),
    date = as.numeric(date),
    tech = toupper(tech)
  ) %>% 
  filter(lat > 27.3 & lat < 28.2)  
head(habdat)
```

```
## # A tibble: 6 x 6
##        lat       lon  date                   tech          type  acre
##      <dbl>     <dbl> <dbl>                  <chr>         <chr> <dbl>
## 1 27.93133 -82.73820  2005       WETLAND CREATION Establishment  14.0
## 2 27.95087 -82.54180  1998       WETLAND CREATION Establishment   3.0
## 3 27.88977 -82.39888  2005 HYDROLOGIC RESTORATION   Enhancement  12.8
## 4 27.88994 -82.40340  2004         EXOTIC CONTROL   Enhancement 123.9
## 5 27.97370 -82.71504  2006             EXCAVATION Establishment  20.0
## 6 27.97370 -82.71504  2006             EXCAVATION Establishment  26.0
```

```r
save(habdat, file = 'data/habdat.RData', compress = 'xz')

ggplot(habdat, aes(tech, group = date, fill = factor(date))) + 
  geom_bar(position = 'dodge') + 
  theme_bw() + 
  coord_flip() + 
  theme(
    axis.title.x = element_blank(), 
    legend.title = element_blank()
    )
```

![](tbrest_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

```r
ggplot(habdat, aes(acre, group = tech, fill = tech)) + 
  geom_histogram() + 
  scale_x_log10('Acres') + 
  facet_wrap(~tech) + 
  theme_bw() + 
  theme(
    legend.position = 'none'
  )
```

![](tbrest_files/figure-html/unnamed-chunk-2-2.png)<!-- -->

Map of restoration sites and acreage reported:


```r
toplo <- habdat

# extent
ext <- make_bbox(toplo$lon, toplo$lat)
map <- get_stamenmap(ext, zoom = 11, maptype = "toner-lite")

# base map
pbase <- ggmap(map) +
  theme_bw() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  ) +
  geom_point(data = toplo, aes(size = acre, fill = tech), pch = 21, colour = 'black', alpha = 0.8) + 
  scale_size(range = c(2, 11))
pbase
```

![](tbrest_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

## Load data


```r
loads <- read_excel('data-raw/loads.xlsx')

lddat <- loads %>% 
  filter(!`Bay Segment` %in% c(5, 6, 7)) %>% 
  rename(
    seg = `Bay Segment`,
    h2o = `H2O Load (m3/month)`,
    tn = `TN Load (kg/month)`,
    tp = `TP Load (kg/month)`, 
    tss = `TSS Load (kg/month)`,
    bod = `BOD Load (kg/month)`, 
    yr = Year, 
    mo = Month
    ) %>% 
  gather('var', 'val', h2o:bod) %>% 
  mutate(
    val = as.numeric(val),
    seg = factor(seg, levels = c('1', '2', '3', '4'), labels = c('OTB', 'HB', 'MTB', 'LTB'))
    ) %>% 
  group_by(seg, yr, mo, var) %>% 
  summarise(val = sum(val, na.rm = TRUE))

ggplot(lddat, aes(x = yr, y = val, group = yr)) + 
  geom_boxplot() + 
  facet_grid(var~seg, scales = 'free_y') + 
  scale_y_log10('kg or m3 per month')
```

![](tbrest_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

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
  gather('var', 'val', chla:do) %>% 
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
## # A tibble: 6 x 4
##    stat   datetime   var   val
##   <int>     <date> <chr> <dbl>
## 1    47 1974-01-01  chla    NA
## 2    60 1974-01-01  chla    NA
## 3    46 1974-01-01  chla     3
## 4    64 1974-01-01  chla     2
## 5    66 1974-01-01  chla    NA
## 6    40 1974-01-01  chla    NA
```

### Plot of ten-year medians {.tabset}

#### DO


```r
# take ten-year averages
wqdat_ten <- wqdat %>%
  left_join(wqstat, by = 'stat') %>% 
  mutate(
    yr = year(datetime)
  ) %>% 
  group_by(stat, yr, var, lat, lon) %>% 
  summarise(val = median(val, na.rm = TRUE)) %>% 
  ungroup %>% 
  mutate(
    yrcat = cut(yr, 
      breaks = c(-Inf, 1985, 1995, 2005, Inf), 
      labels = c('1974-1985', '1986-1995', '1996-2005', '2005-2016')
    )
  ) %>% 
  group_by(stat, yrcat, lat, lon, var) %>% 
  summarise(val = median(val, na.rm = TRUE)) %>% 
  ungroup

# extent
ext <- make_bbox(wqdat_ten$lon, wqdat_ten$lat)
map <- get_stamenmap(ext, zoom = 11, maptype = "toner-lite")

# base map
pbase <- ggmap(map) +
  theme_bw() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  ) +
  guides(fill=guide_legend(''), size = guide_legend('')) 
colpal <- 'Set2'

# do map
doplo <- filter(wqdat_ten, var %in% 'do')
pbase + 
  geom_point(data = doplo, aes(x = lon, y = lat, size = val, fill = val), pch = 21, colour = 'black', alpha = 0.8) + 
  scale_size('', range = c(2, 11)) + 
  scale_fill_distiller(palette = colpal) +
  facet_wrap(~yrcat) + 
  guides(fill=guide_legend(''), size = guide_legend('')) +
  ggtitle('DO mg/L') 
```

![](tbrest_files/figure-html/unnamed-chunk-8-1.png)<!-- -->

#### Salinity

```r
# sal map
salplo <- filter(wqdat_ten, var %in% 'sal')
pbase + 
  geom_point(data = salplo, aes(x = lon, y = lat, size = val, fill = val), pch = 21, colour = 'black', alpha = 0.8) + 
  scale_size('', range = c(2, 11)) + 
  scale_fill_distiller(palette = colpal) +
  facet_wrap(~yrcat) + 
  guides(fill=guide_legend(''), size = guide_legend('')) +
  ggtitle('Sal ppt') 
```

![](tbrest_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

#### Chlorophyll

```r
# chl map
chlplo <- filter(wqdat_ten, var %in% 'chla')
pbase + 
  geom_point(data = chlplo, aes(x = lon, y = lat, size = val, fill = val), pch = 21, colour = 'black', alpha = 0.8) + 
  scale_size('', range = c(2, 11)) + 
  scale_fill_distiller(palette = colpal) +
  facet_wrap(~yrcat) +
  ggtitle('Chl-a ug/L') 
```

![](tbrest_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

## Distance to restoration sites {.tabset}


```r
# load restoration and wq data 
data(habdat)
data(wqstat)

# assign unique id to hab projs
habdat <- habdat %>% 
  mutate(id = stri_rand_strings(nrow(habdat), length = 4))

# hab project locations and id
tomtch <- habdat %>% 
  select(id, lon, lat)

# get this many closest to each station
mtch <- 20

# match habitat restoration locations with wq stations by closest mtch locations
wqmtch <- wqstat %>% 
  group_by(stat) %>% 
  nest %>% 
  mutate(
    clo = map(data, function(sta){

      # get top mtch closest restoration projects to each station
      dists <- distm(rbind(sta, tomtch[, -1])) %>%
        .[-1, 1] %>% 
        data.frame(tomtch, dist = .) %>% 
        arrange(dist) %>% 
        .[1:mtch, ] %>% 
        data.frame(sta, ., rnk = 1:mtch)
      
      return(dists)
      
    })
  ) %>% 
  select(-data) %>% 
  unnest

head(wqmtch)
```

```
## # A tibble: 6 x 8
##    stat      lon     lat    id     lon.1    lat.1     dist   rnk
##   <int>    <dbl>   <dbl> <chr>     <dbl>    <dbl>    <dbl> <int>
## 1    47 -82.6202 27.9726  VvLL -82.61724 27.99817 2861.746     1
## 2    47 -82.6202 27.9726  DaYf -82.61671 27.99911 2971.000     2
## 3    47 -82.6202 27.9726  R9Hz -82.57360 27.97310 4581.869     3
## 4    47 -82.6202 27.9726  L2M0 -82.58379 27.99967 4678.879     4
## 5    47 -82.6202 27.9726  oSq9 -82.63240 28.01691 5075.789     5
## 6    47 -82.6202 27.9726  1epg -82.58063 28.01178 5843.654     6
```

### Closest 

```r
## 
# plots

# extent
ext <- make_bbox(habdat$lon, habdat$lat)
map <- get_stamenmap(ext, zoom = 11, maptype = "toner-lite")

# base map
pbase <- ggmap(map) +
  theme_bw() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  ) +
  geom_point(data = habdat, aes(x = lon, y = lat), fill  = 'green', size = 3, pch = 21) +
  geom_point(data = wqstat, aes(x = lon, y = lat))

# closest
toplo1 <- filter(wqmtch, rnk %in% 1)

pbase + 
  geom_segment(data = toplo1, aes(x = lon, y = lat, xend = lon.1, yend = lat.1))
```

![](tbrest_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

### Closest five

```r
# closest five
toplo2 <- filter(wqmtch, rnk %in% c(1:5))

pbase + 
  geom_segment(data = toplo2, aes(x = lon, y = lat, xend = lon.1, yend = lat.1))
```

![](tbrest_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

### Closest twenty

```r
# closest twenty
toplo3 <- filter(wqmtch, rnk %in% c(1:20))

pbase + 
  geom_segment(data = toplo3, aes(x = lon, y = lat, xend = lon.1, yend = lat.1))
```

![](tbrest_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

         
