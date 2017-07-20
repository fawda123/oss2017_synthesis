## ----message = F, warning = F, results = 'hide'--------------------------
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

## ----warning = F, message = F, fig.width = 8, fig.height = 6-------------
data(restdat)
data(reststat)

## ------------------------------------------------------------------------
head(restdat)

## ------------------------------------------------------------------------
head(reststat)

## ----warning = F, message = F--------------------------------------------
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

## ------------------------------------------------------------------------
head(wqstat)

## ------------------------------------------------------------------------
head(wqdat)

## ------------------------------------------------------------------------
# get this many closest to each station
mtch <- 10

# join restoration site data and locs, make top level grouping column
restall <- left_join(restdat, reststat, by = 'id') %>% 
  mutate(
    top = ifelse(grepl('HABITAT', type), 'hab', 'wtr')
  )

# restoration project grouping column
resgrp <- 'top'
names(restall)[names(restall) %in% resgrp] <- 'resgrp'

# match habitat restoration locations with wq stations by closest mtch locations
wqmtch <- wqstat %>% 
  group_by(stat) %>% 
  nest %>% 
  mutate(
    clo = map(data, function(sta){

      # get top mtch closest restoration projects to each station
      # grouped by resgrp column
      dists <- distm(rbind(sta, restall[, c('lat', 'lon')])) %>%
        .[-1, 1] %>%
        data.frame(
          restall[, c('id', 'resgrp')],
          dist = ., stringsAsFactors = F
          ) %>%
        group_by(resgrp) %>%
        arrange(dist) %>% 
        nest %>%
        mutate(
          data = map(data, function(x) x[1:mtch, ]),
          rnk = map(data, function(x) seq(1:nrow(x)))
          ) %>% 
        unnest
      
      return(dists)
      
    })
  ) %>% 
  select(-data) %>% 
  unnest

head(wqmtch)

## ----message = F, warning = F, fig.width = 7, fig.height = 8-------------
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
restall <- restall %>% 
  rename(
    `Restoration\ngroup` = resgrp
  )

# extent
ext <- make_bbox(wqstat$lon, wqstat$lat, f = 0.1)
map <- get_stamenmap(ext, zoom = 11, maptype = "toner-lite")

# base map
pbase <- ggmap(map) +
  theme_bw() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  ) +
  geom_point(data = restall, aes(x = lon, y = lat, fill = `Restoration\ngroup`), size = 3, pch = 21) +
  geom_point(data = wqstat, aes(x = lon, y = lat))

# closest
toplo1 <- filter(toplo, rnk %in% 1)

pbase + 
  geom_segment(data = toplo1, aes(x = lon.x, y = lat.x, xend = lon.y, yend = lat.y, alpha = `Distance (dd)`, linetype = `Restoration\ngroup`))

## ----message = F, warning = F, fig.width = 7, fig.height = 8-------------
# closest five
toplo2 <- filter(toplo, rnk %in% c(1:5))

pbase + 
  geom_segment(data = toplo2, aes(x = lon.x, y = lat.x, xend = lon.y, yend = lat.y, alpha = `Distance (dd)`, linetype = `Restoration\ngroup`))

## ----message = F, warning = F, fig.width = 7, fig.height = 8-------------
# closest twenty
toplo3 <- filter(toplo, rnk %in% c(1:10))

pbase + 
  geom_segment(data = toplo3, aes(x = lon.x, y = lat.x, xend = lon.y, yend = lat.y, alpha = `Distance (dd)`, linetype = `Restoration\ngroup`))

## ----eval = F------------------------------------------------------------
## 
## # diff to summarize wq data, in years before/after restoration projects
## yrdf <- 5
## 
## # get only chl dat
## chldat <- wqdat %>%
##   select(-sal, -do)
## 
## wqchng <- wqmtch %>%
##   left_join(habdat, by = 'id') %>%
##   mutate(
##     date = paste0(date, '-07-01'),
##     date = as.Date(date, format = '%Y-%m-%d')
##     ) %>%
##   split(.$stat) %>%
##   map(., function(x){
## 
##     # iterate through the restoration sites closest to each wq station
##     bysta <- x %>%
##       group_by(rnk) %>%
##       nest %>%
##       mutate(
##         wqchg = map(data, function(dt){
## 
##           # summarize before/after wq data based on restoration date
## 
##           # filter wq data by stat, get date bounds
##           statdat <- filter(chldat, stat %in% dt$stat)
##           orrng <- range(statdat$datetime)
## 
##           # get date range +/- restoratin proj defined by yrdf
##           dtrng <- with(dt, c(date - yrdf * 365, date + yrdf * 365))
## 
##           ## get values within window in dtrng, only if date available
##           bef <- NA; aft <- NA
## 
##           # before
##           if(dtrng[1] >= orrng[1]){
## 
##             # summarizes values before
##             bef <- filter(statdat, datetime >= dtrng[1] & datetime <= dt$date) %>%
##               .$chla %>%
##               mean(na.rm = TRUE)
## 
##           }
## 
##           # after
##           if(dtrng[2] <= orrng[2]){
## 
##             # summarize values after
##             aft <- filter(statdat, datetime <= dtrng[2] & datetime >= dt$date) %>%
##               .$chla %>%
##               mean(na.rm = TRUE)
## 
##           }
## 
##           # combine/return the wq station/restoration station summary
##           out <- data.frame(bef = bef, aft = aft)
##           return(out)
## 
##         })
## 
##       )
## 
##     # return the complete restoration summary
##     bysta <- unnest(bysta)
##     return(bysta)
## 
##   }) %>%
##   do.call('rbind', .) %>%
##   remove_rownames()
## 
## head(wqchng)

