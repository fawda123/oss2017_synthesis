## ----message = F, warning = F, results = 'hide'--------------------------
library(tidyverse)
library(readxl)
library(ggmap)
library(lubridate)
library(geosphere)
library(stringi)
library(tibble)

# diff to summarize wq data, in years before/after restoration projects
yrdf <- 5

# get only chl dat
chldat <- wqdat %>% 
  select(-sal, -do)

wqchng <- wqmtch %>% 
  left_join(habdat, by = 'id') %>% 
  mutate(
    date = paste0(date, '-07-01'),
    date = as.Date(date, format = '%Y-%m-%d')
    ) %>% 
  split(.$stat) %>% 
  map(., function(x){
    
    # iterate through the restoration sites closest to each wq station
    bysta <- x %>% 
      group_by(rnk) %>% 
      nest %>% 
      mutate(
        wqchg = map(data, function(dt){
          
          # summarize before/after wq data based on restoration date
          
          # filter wq data by stat, get date bounds
          statdat <- filter(chldat, stat %in% dt$stat)
          orrng <- range(statdat$datetime)
          
          # get date range +/- restoratin proj defined by yrdf
          dtrng <- with(dt, c(date - yrdf * 365, date + yrdf * 365))
          
          ## get values within window in dtrng, only if date available
          bef <- NA; aft <- NA
          
          # before
          if(dtrng[1] >= orrng[1]){
          
            # summarizes values before
            bef <- filter(statdat, datetime >= dtrng[1] & datetime <= dt$date) %>% 
              .$chla %>% 
              mean(na.rm = TRUE)
            
          }
          
          # after
          if(dtrng[2] <= orrng[2]){
            
            # summarize values after
            aft <- filter(statdat, datetime <= dtrng[2] & datetime >= dt$date) %>% 
              .$chla %>% 
              mean(na.rm = TRUE)
            
          }
          
          # combine/return the wq station/restoration station summary
          out <- data.frame(bef = bef, aft = aft)
          return(out)
          
        })
      
      )
    
    # return the complete restoration summary
    bysta <- unnest(bysta)
    return(bysta)

  }) %>% 
  do.call('rbind', .) %>% 
  remove_rownames() %>% 
  gather('var', 'val', bef:aft)

head(wqchng)

table(wqchng$type)

ggplot(wqchng, aes())

