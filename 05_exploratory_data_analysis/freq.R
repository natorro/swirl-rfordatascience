ggplot(data = diamonds, mapping = aes(x = carat, color = cut)) + geom_freqpoly(binwidth = 0.1)

