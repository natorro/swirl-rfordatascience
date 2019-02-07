library(dplyr)
library(ggplot2)



grid %>%
  ggplot(aes(x1, x2)) +
  geom_point(
    data = filter(grid, rank(dist) <= 10),
    size = 4, colour = "red"
  ) +
  geom_point(aes(color = -dist)) 


