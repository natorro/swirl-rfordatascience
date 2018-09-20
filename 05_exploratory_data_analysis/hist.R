library(nycflights13)
dep = flights$dep_time
print(dep)
df = data.frame(dep)
ggplot( data = df) + geom_histogram(mapping = aes(x = dep),binwidth = .95)




                                    