library(dplyr)
library(ggplot2)


pokemon <- read.csv("/home/dan/swirl-rfordatascience/18_model_basics_with_modelr/Pokemon.csv")


pokemon <- pokemon %>% rename(tipo1 = `Type.1`)


pokemon %>%
  summarise(n = n_distinct(tipo1))

tipo1 <- pokemon %>%
  distinct(tipo1) %>%
  pull()

categorical <- seq(1, 54, 3)

pokemon2 <- tibble(tipo1, categorical)


pokemon3 <- full_join(pokemon, pokemon2, by = "tipo1")

pokemon3 <- as_tibble(pokemon3)
