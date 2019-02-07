library(ggplot2)
library(dplyr)





ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(
    aes(intercept = x1, slope = x2, color = -dist),
    data = filter(grid, rank(dist) <= 100)
  )









