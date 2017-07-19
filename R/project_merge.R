## ----warning = F, message = F, fig.width = 8, fig.height = 6-------------
wat_tr <- 'data-raw/apdb_completed_categorized.csv'

# clean up habitat restoration data
watdat <- wat_tr %>% 
  read_csv %>% 
  rename(
    lat = Latitude, 
    lon = Longitude, 
    date = Project_Completion_Date, 
    tech = `Restoration Category`, 
    type = `Activity-1`, 
    acre = `Acres-1`
  ) %>% 
  mutate(
    id = stri_rand_strings(nrow(.), length = 4),
    lat = as.numeric(lat),
    lon = as.numeric(lon),
    date = as.numeric(date),
    tech = toupper(tech)
  ) %>% 
  filter(lat > 27.3 & lat < 28.2) %>% 
  filter(!is.na(date))

# habitat restoration station locs
habstat <- habdat %>% 
  select(id, lat, lon) %>% 
  unique

# normalized habitat data
habdat <- habdat %>% 
  select(-lat, -lon)

save(habdat, file = 'data/habdat.RData', compress = 'xz')
save(habstat, file = 'data/habstat.RData', compress = 'xz')

## ------------------------------------------------------------------------
head(habdat)

## ------------------------------------------------------------------------
head(habstat)

