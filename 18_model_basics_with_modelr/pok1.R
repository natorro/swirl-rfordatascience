

pokemon3 %>% select(categorical, Total)
mod2 <- lm(Total ~ categorical, data = pokemon3)
grid <- pokemon3 %>% data_grid(categorical) %>% add_predictions(mod2)
grid
ggplot(pokemon3, aes(tipo1)) + geom_point(aes(y = Total)) + geom_point(data = grid, aes(y = pred), color = "red", size = 4)

pokemon4 <- pokemon3 %>% select(Legendary, Attack, Total) %>% 
  mutate(level_attack = ifelse(Attack < 55, 1, ifelse(Attack > 100, 3, 2))) %>% 
  select(level_attack, Legendary, Total)


ggplot(pokemon4, aes(level_attack, Total)) +
  geom_point(aes(color = Legendary))

mod1 <- lm(Total ~ level_attack + Legendary, data = pokemon4)
mod2 <- lm(Total ~ level_attack * Legendary, data = pokemon4)

grid <- pokemon4 %>%
  data_grid(level_attack, Legendary) %>%
  gather_predictions(mod1, mod2)
grid

ggplot(pokemon4, aes(level_attack, Total, color = Legendary)) +
  geom_point() +
  geom_line(data = grid, aes(y = pred)) +
  facet_wrap(~ model)


residuales <- pokemon4 %>%
  gather_residuals(mod1, mod2)
ggplot(residuales, aes(level_attack, resid, color = Legendary)) +
  geom_point() +
  facet_grid(model ~ Legendary)





