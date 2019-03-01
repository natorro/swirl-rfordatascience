peces <- read.csv('fish.csv', header = TRUE)
print(peces)
str(peces)
head(peces)
barplot(prop.table(table(peces$Especies)), main = "Especies de peces", xlab = "Especies", ylab = "Contéo", width = 1)

