#' Get conditional distribution estimates for change values
#'
#' @param wqchng 
#' @param grps Grouping variables
#'
get_cdt <- function(wqchg, ...){

  # fit conditional distributions
  wqcdt <- wqchg %>% 
    group_by_(...) %>% 
    nest %>% 
    mutate(
      crv = map(data, function(x){
        
        est <- x$cval %>% 
          na.omit %>% 
          MASS::fitdistr('normal') %>% 
          .$estimate
        
        return(est)
        
      }
      ), 
      prd = pmap(list(data, crv), function(data, crv){
        
        cval <- range(data$cval, na.rm = TRUE)  
        cval <- seq(cval[1], cval[2], length = 100)
        est <- dnorm(cval, crv[1], crv[2]) %>% 
          data.frame(cval = cval, est = .) %>% 
          mutate(
            cumest = cumsum(est),
            cumest = cumest / max(cumest)
          )
        
        return(est)
        
      }
      )
    )
  
  return(wqcdt)
  
}