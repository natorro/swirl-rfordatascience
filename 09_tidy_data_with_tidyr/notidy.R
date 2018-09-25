library(tidyr)
modelo = c("Chevy", "Fusion", "Explorer")
hp2010 = c(27, 25, 29)
hp2011 = c(180, 170, 185)
autos_data = data.frame(modelos,hp2010,hp2011)
# Print
autos_data

tidydata=gather(autos_data,'hp2010','hp2011', key = 'hpYear',value = 'hp')
tidydata
end()