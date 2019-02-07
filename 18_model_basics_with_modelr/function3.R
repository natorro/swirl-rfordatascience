library(dplyr)
library(purrr)



grid <- expand.grid(
  x1 = seq(3, 15, length = 20),
  x2 = seq(1.9, 3.9, length = 25)
) %>%
  mutate(dist = purrr::map2_dbl(x1, x2, distf))