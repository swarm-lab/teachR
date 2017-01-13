#### LOAD LIBRARIES #### 
pacman::p_load(shiny, shinythemes, ggvis)


#### DEFINE CUSTOM FUNCTIONS ####
#' @title Random Walk
#' 
#' @description This function computes the next step of a random walk. 
#' 
#' @param df A data frame containing at least the following columns: x (x 
#'  coordinates of each individual), y (y coordinates of each individual), h 
#'  (heading in radians of each individual), s (the speed of each individual).
#' 
#' @return A data frame of the same dimensions as \code{df}.
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, 
#'  \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#' 
rw <- function(df) {
  n <- nrow(df)
  
  within(df, {
    h <- h + rnorm(n, sd = pi / 6)
    x <- x + s * cos(h)
    y <- y + s * sin(h)
    
    h[x < -1] <- 0
    h[x > 1] <- pi
    h[y < -1] <- pi / 2
    h[y > 1] <- -pi / 2
  })
}


#' @title Sigmoid Curve
#' 
#' @description This function computes a fully customizable sigmoid function. 
#' 
#' @param x The x coordinates at which to compute the sigmoid values.
#' @param a The sigmoid minimum value.
#' @param k The sigmoid maximum value. 
#' @param b The growth rate of the sigmoid. 
#' @param m The position of the inflection point of the sigmoid. 
#' 
#' @return A vector of the same length as \code{x}.
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, 
#'  \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#'
sigmoid <- function(x, a = 0, k = 1, b = 0.1, m = 100) {
  a + (k - a) / ((1 + exp(-b * (x - m))))
}


#' @title Pairwise Distances
#' 
#' @description This function computes the pairwise distances between two series
#'  of points. 
#' 
#' @param A A matrix for which the number of rows corresponds to the number of 
#'  points and the number of colums corresponds to the number of dimensions in 
#'  which these points are defined.
#' @param B Same as \code{A}. In addition \code{B} must have the same number of 
#'  columns as \code{A}.
#' 
#' @return A matrix of the pairwise distances between the points in A (along the 
#'  rows) and B (along the columns).
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, 
#'  \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#'
pdist <- function(A, B) {
  if (ncol(A) != ncol(B)) {
    stop("A and B should have the same number of columns.")
  }
  
  an = apply(A, 1, function(rvec) crossprod(rvec,rvec))
  bn = apply(B, 1, function(rvec) crossprod(rvec,rvec))
  
  m = nrow(A)
  n = nrow(B)
  
  tmp = matrix(rep(an, n), nrow = m) 
  tmp = tmp +  matrix(rep(bn, m), nrow = m, byrow = TRUE)
  sqrt( tmp - 2 * tcrossprod(A,B) )
}


#' @title Speed Adjustment 
#' 
#' @description This function adjusts the speed of individuals based on the 
#'  local neighborhood. 
#' 
#' @param df A data frame containing at least the following columns: x (x 
#'  coordinates of each individual), y (y coordinates of each individual), h 
#'  (heading in radians of each individual), s (the speed of each individual).
#' @param affinSame The degree of affinity of an individual for other 
#'  individuals of the same class (-1: repulsion; 1: attraction).
#' @param affinOther The degree of affinity of an individual for other 
#'  individuals of a different class (-1: repulsion; 1: attraction). 
#' 
#' @return A data frame of the same dimensions as \code{df}.
#' 
#' @author Simon Garnier: \email{garnier@@njit.edu}, 
#'  \link[https://twitter.com/sjmgarnier]{@@sjmgarnier}
#'
sp <- function(df, affinSame = 0, affinOther = 0) {
  dist <- pdist(as.matrix(df[, 1:2]), as.matrix(df[, 1:2]))
  neighbor <- dist < 0.125
  b_neighbor <- apply(df$col == "#107AB6" & neighbor, 2, sum) - (df$col == "#107AB6")
  r_neighbor <- apply(df$col == "#D86810" & neighbor, 2, sum) - (df$col == "#D86810")
  
  nb <- (df$col == "#107AB6") * affinSame * b_neighbor + 
    (df$col == "#D86810") * affinSame * r_neighbor + 
    (df$col == "#107AB6") * affinOther * r_neighbor + 
    (df$col == "#D86810") * affinOther * b_neighbor
  
  df$s <- sigmoid(nb, k = 0.1, m = 4, b = -1)
  df
}


### DEFINE GLOBAL VARIABLES ###
pop <- NULL
run <- FALSE
