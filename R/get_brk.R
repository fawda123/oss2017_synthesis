#' Get CDF breaks for restoration type, treatment combos
#'
#' @param wqcdt
#' @param qts quantile levels to split variable
#'
get_brk <- function(wqcdt, qts = c(0.25, 0.5, 0.75), ...){
  
  # get quantile levels, interpolate to cdf values, relabel
  brk <- wqcdt %>% 
    select(-data, -crv) %>% 
    unnest %>% 
    group_by_(...) %>% 
    nest %>% 
    mutate(
      qts = map(data, function(x){
        
        out<- quantile(x$cval, qts)
        return(out)
        
      }),
      brk = pmap(list(data, qts), function(data, qts){
        
        out <- approx(x = data$cval, y = data$cumest, xout = qts)
        out <- out$y
        return(out)
        
      }),
      clev = map(brk, function(x){
        
        out <- rank(x)
        return(out)
        
      })
    ) %>% 
    select(-data) %>% 
    unnest
  
  return(brk)
  
  }
