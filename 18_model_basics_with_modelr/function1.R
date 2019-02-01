library(ggplot2)
library(modelr)
library(purrr)
library(dplyr)
options(na.action = na.warn)



dia <- head(diamonds, 20) %>% 
  select(x, y) %>% 
  as_tibble(dia)

linearm <- tibble(x1 = runif(3000, -3, 6),
                  x2 = runif(3000, -3, 3))


familym <- function(a, data) {
  a[1] + data$x * a[2]}

dist1 <- function(mod, data) {
  diff <- data$y - familym(mod, data)
  sqrt(mean(diff ^ 2))
}
distf <- function(x, y) {
  dist1(c(x, y), dia)
}

bestmodel <- linearm %>% 
  mutate(dist = map2_dbl( x1, x2, distf))


bestmodel


















