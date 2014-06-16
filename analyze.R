setwd('/home/sicarul/dev/worldcup')
library(igraph)
library(plyr)

input <- read.csv('preliminary.csv')

areaCount <- ddply(input,.(area), summarise, count = length(area))

areaMap <- areaCount$count
names(areaMap) <- areaCount$area

input$home <- as.character(input$home)
input$away <- as.character(input$away)

allnames <- unique(c(input$home, input$away))

teamMap <- 1:length(allnames)
names(teamMap) <- allnames

mapBack <- names(teamMap)
names(mapBack) <- teamMap

team_translate <- function(x) {return (as.numeric(teamMap[x]))}
team_translate_back <- function(x) {return (mapBack[x])}
area_count <- function(x) {return (as.numeric(areaMap[x]))}

input$area_count <- area_count(input$area)

homewins <- subset(input, scoreHome > scoreAway)
awaywins <- subset(input, scoreHome < scoreAway)

graph_data <- data.frame(from=c(awaywins$home, homewins$away), to=c(awaywins$away, homewins$home), weight=36/c(awaywins$area_count, homewins$area_count))

gteam <- graph.data.frame(graph_data)

(b1 <- betweenness(gteam, directed = TRUE))
(c1 <- closeness(gteam, mode = "out"))
(d1 <- degree(gteam, mode = "out"))

tkplot(gteam)


classif <-c('Camerún',
  'México',
  'Croacia',
  'Australia',
  'Chile',
  'Países Bajos',
  'España',
  'Colombia',
  'Costa de Marfil',
  'Grecia',
  'Japón',
  'Costa Rica',
  'Inglaterra',
  'Italia',
  'Uruguay',
  'Ecuador',
  'Francia',
  'Honduras',
  'Suiza',
  'Argentina',
  'Bosnia y Herzegovina',
  'Irán',
  'Nigeria',
  'Alemania',
  'Ghana',
  'Portugal',
  'EEUU',
  'Argelia',
  'Bélgica',
  'República de Corea',
  'Rusia')


classif_ids = team_translate(classif)
interest <- intersect(classif_ids, as.numeric(V(gteam)))

pr <- page.rank(gteam, vids = classif)


join <- pr$vector
sort(join, decreasing=TRUE)
