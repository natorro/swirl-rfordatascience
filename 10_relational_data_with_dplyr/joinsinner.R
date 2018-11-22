

df <- data.frame(llave = c("1", "2", "3") ,dos = c("a", "b", "c"))
df1 <- data.frame(llave1 = c("1", "2", "4"), dos1 = c("e", "f", "g"))
print(list(df, df1))
df %>% inner_join(df1, by = c('llave' = 'llave1'))



