library(nycflights13)
flights
año = flights$year
mes = flights$month
dia = flights$day
w = data.frame(año , mes , dia)
print(w)