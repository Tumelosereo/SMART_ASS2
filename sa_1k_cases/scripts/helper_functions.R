#' Desired standard deviation of log normal distribution
#'
#' @param mu #Input mean
#' @param sigma #Input standard deviation
#'
#' @return #the desired standard deviation
#' @export
#' @details 
#' Check the log normal distribution page on \href{shorturl.at/lxVZ4}{Wikipedia} 
#' for details on the transformation done here.
#' @examples
cal_desired_lognorm_sd <- function(mu, sigma){
  desired_sd <- sqrt(log(1 + (sigma/mu)^2)) 
  return(desired_sd)
}


#' Desired mean of log normal distribution
#'
#' @param mu #Input mean
#' @param sigma #Input standard deviation
#'
#' @return #the desired standard deviation
#' @export
#' @details 
#' Check the log normal distribution page on \href{shorturl.at/lxVZ4}{Wikipedia} 
#' for details on the transformation done here.
#' @examples
cal_desired_lognorm_mu <- function(mu, sigma){
  desired_mu <- log((mu^2)/(sqrt(sigma^2 + mu^2)))
  return(desired_mu)
}