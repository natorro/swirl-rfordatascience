library(dplyr)
library(purrr)



grid <- expand.grid(
  x1 = seq(-5, 20, length = 25),
  x2 = seq(1, 3, length = 25)
) %>%
  mutate(dist = purrr::map2_dbl(x1, x2, dist1))