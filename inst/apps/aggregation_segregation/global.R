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

sigmoid <- function(x, a = 0, k = 1, b = 0.1, m = 100, v = 1, q = 1) {
  a + (k - a) / ((1 + q * exp(-b * (x - m))) ^ (1 / v))
}

pdist <- function(A, B) {
  an = apply(A, 1, function(rvec) crossprod(rvec,rvec))
  bn = apply(B, 1, function(rvec) crossprod(rvec,rvec))
  
  m = nrow(A)
  n = nrow(B)
  
  tmp = matrix(rep(an, n), nrow = m) 
  tmp = tmp +  matrix(rep(bn, m), nrow = m, byrow = TRUE)
  sqrt( tmp - 2 * tcrossprod(A,B) )
}

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

pop <- NULL
run <- FALSE
