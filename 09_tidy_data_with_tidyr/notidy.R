library(tidyr)
modelo = c("Chevy", "Fusion", "Explorer")
hp2010 = c(27, 25, 29)
hp2011 = c(180, 170, 185)
autos_data = data.frame(modelos,hp2010,hp2011)
# Print
autos_data

tidydata=gather(autos_data,'hp2010','hp2011', key = 'hpYear',value = 'hp')
tidydata
modelo1 = c("Fusion", "Fusion","Fusion", "Fusion")
hpyear = c('hp2010','hp2010','hp2011','hp2011')
tipo = c('hybrid','normal','hybrid','normal')
valor = c(189,179,240,210)

fusion = data.frame(modelo1,hpyear,tipo,valor)
fusion
fusionS = spread(fusion, key = tipo, value = valor)
fusionS
tipoval = c('hybrid-189','normal-179','hybrid-240','normal-210')
sep = data.frame(modelo1, hpyear, tipoval)
separate(sep, tipoval, into = c('tipo','valor'))