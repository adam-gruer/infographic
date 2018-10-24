library(grid)



angle <-75
radians <- angle * pi / 180
m <- tan( radians)


x1 <- -30:30/30
x2  <- (1 + (x1 * m ))/m
xs <- as.vector(mapply(function(x,y) c(x,y), x1, x2))

grid.newpage()
grid.polyline(
              #x=c(0.1,0.15,
             #     0.2,0.25),
              x=xs,
              y = rep(c(0.2,0.6),length(x1)),
              id=rep(1:length(x1),each=2),
              gp = gpar(lwd=1,
                        lex=10,
                        lineend = "square",
                        linemitre=5,
                       
                        col=colours_vector["stripes"]))


grid.newpage()
grid.polyline(
  #x=c(0.1,0.15,
  #     0.2,0.25),
  x=c(0.2,0.5),
  y = rep(0:1,1),
  id=rep(1,each=2),
  gp = gpar(lwd=20,
            col=colours_vector["stripes"]))




