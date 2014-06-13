setwd('/home/sicarul/Dev/worldcup_scraper')
library(igraph)

input <- read.csv('preliminary.csv')

input$home <- as.character(input$home)
input$away <- as.character(input$away)

allnames <- unique(c(input$home, input$away))

teamMap <- 1:length(allnames)
names(teamMap) <- allnames

team_translate <- function(x) {return (as.numeric(teamMap[x]))}

homewins <- subset(input, scoreHome > scoreAway)
awaywins <- subset(input, scoreHome < scoreAway)

graph_data <- data.frame(from=c(awaywins$home, homewins$away), to=c(awaywins$away, homewins$home))
graph_data$from <- team_translate(graph_data$from)
graph_data$to <- team_translate(graph_data$to)

gteam <- graph.edgelist(as.matrix(graph_data))

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

classif_ids = as.numeric(Map(team_translate, classif))
subset(classif_ids, is.na(classif_ids) == TRUE)

pr <- page.rank(gteam, vids = classif_ids)

join <- data.frame(equipo = classif, page_rank = pr$vector)
final <- join[order(join[,2], decreasing=TRUE),]
