sigmoid <- function(x, a = 0, k = 1, b = 0.1, m = 100, v = 1, q = 1) {
  a + (k - a) / ((1 + q * exp(-b * (x - m))) ^ (1 / v))
}

pdist <- function(A, B) {
  an = apply(A, 1, function(rvec) crossprod(rvec,rvec))
  bn = apply(B, 1, function(rvec) crossprod(rvec,rvec))
  
  m = nrow(A)
  n = nrow(B)
  
  tmp = matrix(rep(an, n), nrow=m) 
  tmp = tmp +  matrix(rep(bn, m), nrow=m, byrow=TRUE)
  sqrt( tmp - 2 * tcrossprod(A,B) )
}

agg_seg_model <- function(n = 300, t = 100, affin_same = 1, affin_diff = -1) {  
  loc <- data.frame(t = 0, x = runif(n), y = runif(n), h = runif(n, 0, 2 * pi), 
                    color = rep(c("blue", "red"), n / 2))
  color <- matrix(loc$color, nrow = nrow(loc), ncol = nrow(loc))
  
  saved_loc <- data.frame(t = rep(0:t, each = n), x = NA, y = NA, h = NA, 
                          color = c("blue", "red")) 
  saved_loc[saved_loc$t == 0, ] <- loc
  
  for (i in 1:t) {
    dist <- pdist(as.matrix(loc[, 2:3]), as.matrix(loc[, 2:3]))
    neighbor <- dist < 0.1
    b_neighbor <- apply(color == "blue" & neighbor, 2, sum) - (loc$color == "blue")
    r_neighbor <- apply(color == "red" & neighbor, 2, sum) - (loc$color == "red")
    
    loc$h <- loc$h + rnorm(n, sd = pi / 6)
    
    nb <- (loc$color == "blue") * affin_same * b_neighbor + 
      (loc$color == "red") * affin_same * r_neighbor + 
      (loc$color == "blue") * affin_diff * r_neighbor + 
      (loc$color == "red") * affin_diff * b_neighbor
    
    s <- sigmoid(nb, k = 0.1, m = 4, b = -1)
    
    new_x <- loc$x + s * cos(loc$h)
    new_y <- loc$y + s * sin(loc$h)
    
    loc$h[new_x < 0] <- 0
    loc$h[new_x > 1] <- pi
    loc$h[new_y < 0] <- pi / 2
    loc$h[new_y > 1] <- -pi / 2
    
    new_x <- loc$x + s * cos(loc$h)
    new_y <- loc$y + s * sin(loc$h)
    
    loc$x <- new_x
    loc$y <- new_y
    loc$t <- i
    
    saved_loc[saved_loc$t == i, ] <- loc
  }
  
  saved_loc
}

