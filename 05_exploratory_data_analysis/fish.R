peces <- read.csv('/home/ricardo/swirl-rfordatascience/05_exploratory_data_analysis/fish.csv', header = TRUE)
print(peces)
str(peces)
head(peces)
barplot(prop.table(table(peces$Especies)), main = "Especies de peces", xlab = "Especies", ylab = "Contéo", width = 1)

