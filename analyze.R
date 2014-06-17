
library(igraph)
library(plyr)

input <- read.csv('preliminary.csv')

areaCount <- ddply(input,.(area), summarise, count = length(area))

areaMap <- areaCount$count
names(areaMap) <- areaCount$area

areaMap['matches'] <- 10

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

graph_data <- data.frame(from=c(awaywins$home, homewins$away), to=c(awaywins$away, homewins$home), weight=360/c(awaywins$area_count, homewins$area_count))

sum_graph_data <- aggregate(graph_data[,3], graph_data[1:2], FUN=sum)
names(sum_graph_data) <- c('from', 'to', 'weight')

gteam <- graph.data.frame(sum_graph_data)


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
  'Rusia',
  'Brasil')


pr <- page.rank(gteam, vids=classif)

V(gteam)$size <- pr$vector * 1000

tkplot(gteam)

#subgraph <- induced.subgraph(gteam, classif)
#V(subgraph)$size <- pr$vector * 1000



join <- pr$vector
final <- sort(join, decreasing=TRUE)
final_out <- data.frame(equipos=names(final), pagerank=as.numeric(final))

write.csv(final_out, file='pagerank.csv', row.names=FALSE)
