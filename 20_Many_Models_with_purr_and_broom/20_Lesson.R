#Utilizando muchos modelos simples para entender los complejos

#Utilizando el paquete broom, convirtiendo los modelos en datos. 

#
library(gapminder) ; library(ggplot2) ; library(tidyverse); library(modelr)
#Datos resumen sobre la progresion de los paises sobre el tiempo, mirando estadisticas de vida y PIB.
head(gapminder)

#Comenzando a analizar los datos.
#¿Como cambia la esperanza de vida a lo largo del tiempo para cada pais?
gapminder %>%
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)
#Es un pequeño conjunto de datos pero aun es dificil saber que esta pasando realmente

#La primero impresion, la esperanza de vida aumenta con los años. Aunque algunos paises no sigan esta pauta aun es dificil identificarlos con facilidad.

#Crearemos varios modelos lineales para identificar mejor las tendencias, en el caso para un pais:

nz <- filter(gapminder, country == "New Zealand")
nz %>%
  ggplot(aes(year, lifeExp)) +
  geom_line() +
  ggtitle("Full data = ")

nz_mod <- lm(lifeExp ~ year, data = nz)
nz %>%
  add_predictions(nz_mod) %>%
  ggplot(aes(year, pred)) +
  geom_line() +
  ggtitle("Linear trend + ")

nz %>%
  add_residuals(nz_mod) %>%
  ggplot(aes(year, resid)) +
  geom_hline(yintercept = 0, color = "white", size = 3) +
  geom_line() +
  ggtitle("Remaining pattern")

#¿Como adaptar este modelo a cada pais?

####
#Datos Anidados
##

#Se podria copiar y pegar el codigo, existen mejores practicas...

#Codificando una duncion que repita el modelo, necesitamos primero modificar la estructura de los datos.

by_country <- gapminder %>%
  group_by(country, continent) %>%
  nest()
by_country

#La siguiente estructura contiene en la columna data, los datos por cada pais.

by_country$data[[1]]

#Comenzamos a entender la diferencia entre marcos de datos agrupados estander y un marco de datos anidado.

#En los marcos de datos agrupados cada fila es una observacion y en un marco anidado cada fila es un grupo.

#Esto nos permite ver que cada fila nos cuenta la histori a traves del tiempo para cada pais.

##
#Lista en Columnas
##

#Trabajando con los datos anidados, estamos en buena posicion para ajustar algunos modelos:

country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}

#Ocupando la funcion map del paquete purr podemos aplicar la funcion country_model a cada elemento.

models <- map(by_country$data, country_model)

#Se crearon 142 modelos uno para cada pais, tomando los valores de cada fila.
head(models,1)

#Almacenaremos los resultados en una nueva columna en el marco de datos
by_country <- by_country %>%
  mutate(model = map(data, country_model))
by_country

#Ya tenemos organizados los modelos para cada pais...

#Es facil realizar filtros y ver el comportamiento por Continente

by_country %>%
  filter(continent == "Europe")

#Organizar los datos es una buena practica, si tuvieramos nuevos datos se identifican de inmediato al observar alguna diferencia.
by_country %>%
  arrange(continent, country)

##
#Analizando los residuos de todos los modelos
##

by_country <- by_country %>%
  mutate(
    resids = map2(data, model, add_residuals)
  )
by_country

#Volvamos a convertir los datos en marco de datos regulares. Anteriormente usamos nest() para anidarlos. Utilizaremos unnest() para regresar.

resids <- unnest(by_country, resids)

resids

#Teniendo los datos como marco de datos regulares, veamos los residuos de forma general.

resids %>%
  ggplot(aes(year, resid)) +
  geom_line(aes(group = country), alpha = 1 / 3) +
  geom_smooth(se = FALSE)

#La visualizacion por continente es realmente revelador.

resids %>%
  ggplot(aes(year, resid, group = country)) +
  geom_line(alpha = 1 / 3) +
  facet_wrap(~continent)

#Conclucion; Nos henmos perdido de algun patron suave, Es interesante lo que ocurre en Africa viendo residuos muy grandes lo que sugiere que el modelo no encaja muy bien alli.

##
#Calidad del Modelo
##

#No solo nos centramos en analizar los residuos, veamos medidas generales de la calidad del modelo...

#Con el paquete broom podemos extraer metricas importantes.

library(broom)
#Caso de un solo pais
glance(nz_mod)

#Con la ayuda de mutate() y unnest() creamos de nuevo un marco de datos donde tendremos en cada fila las metricas de calidad del modelo por pais.

by_country %>%
  mutate(glance = map(model, broom::glance)) %>%
  unnest(glance)

#Este no es precisamente el marco de datos que buscamos ya que segimos teniendo en algunas columnas valores en lista.

#con el argumento .drop = FALSE extremos todos los valores

glance <- by_country %>%
  mutate(glance = map(model, broom::glance)) %>%
  unnest(glance, .drop = TRUE)
glance

#Con este marco de datos en mano, podemos comenzar a buscar modelos que no queden bien.

glance %>%
  arrange(r.squared)

#Los peores modelos parecen estar en Afica. Tenemos un pequeño numero de observaciones y una variables discreta funcion geom_jitter() es efectiva.

glance %>%
  ggplot(aes(continent, r.squared)) +
  geom_jitter(width = 0.5)

#Podriamos extraer los paises con un R2 particularmente malo y trazar los datos.

bad_fit <- filter(glance, r.squared < 0.25)

gapminder %>%
  semi_join(bad_fit, by = "country") %>%
  ggplot(aes(year, lifeExp, color = country)) +
  geom_line()

#Aqui vemos 2 efectos principales las tragedias de la epidamia del VIH/SIDA y los genocidios Rwanda.

###########
#Detalles sobre los metodos utilizados en el analis de varios modelos
############

#Listas en Columnas, una lista es un vector por lo que siempre a sido legitimo utilizar una lista como una columna.
#Sin embargo R no facilita la creacion de columnas de listas.

data.frame(x = list(1:3, 3:5))

#Otro intento de colocar listas es con la funcion I()
I(list(1:3, 3:5))

data.frame(
  x = I(list(1:3, 3:5)),
  y = c("1, 2", "3, 4, 5")
)
#Sin embargo el resultado no es el mejor.

#Funcion tibble mejora el formato
tibble(
  x = list(1:3, 3:5),
  y = c("1, 2", "3, 4, 5"))

#Es aun mas facil con trible() ya que puede resolver automaticamente que necesitamos una lista.
tribble(
  ~x, ~y,
  1:3, "1, 2",
  3:5, "3, 4, 5")

#Las listas en columnas sueles ser utiles como una estructura de datos intermedios.
#Es dificil trabajar directamente, porque la mayoria de las funciones en R trabajan con vectores.
#En general, hay tres partes de una tuberia de lista-columna efectiva.

#1. Crear la lista-columna usando funcion nest(), summarize(), list() y mutate() con map()

#2. En la transformacion son utiles funciones map(), map2() o pmap().

#3. Simolificacion de las listas-columnas de nuevo a un marco de datos.

#Pongamos en practica estas recomendaciones...

####
#Creacion de Listas-Columnas pag.411
####





















































