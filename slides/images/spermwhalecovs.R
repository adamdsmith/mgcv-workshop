# grab sperm whale covariates and make a figure

# only works on my computer, sorry!
load("~/current/spatial-workshops/spermwhale-analysis/predgrid.RData")

library(ggplot2)
library(gridExtra)
library(viridis)
library(ggalt)
library(sp)

pp <- list()

map_dat2 <- map_data("world", c("usa","canada"))



locs <- map_dat2[,c("long","lat")]
coordinates(locs) <- c("long", "lat")  # set spatial coordinates
crs.geo <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
proj4string(locs) <- crs.geo
crs.aea <- CRS("+proj=aea +lat_1=38 +lat_2=30 +lat_0=34 +lon_0=-73 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
locs.aea <- spTransform(locs, crs.aea)

map_dat2$y <- locs.aea$lat
map_dat2$x <- locs.aea$long

for(value in c("Depth", "SST", "NPP")){
  p <- ggplot(predgrid) +
    geom_tile(aes_string(x="x", y="y", fill=value)) +
    geom_polygon(aes(x=x, y=y, group = group),
                     fill = "#1A9850", data=map_dat2) +
    scale_fill_viridis() +
    coord_equal(xlim=c(-1e6,0.75e6), ylim = c(-0.75e6,0.75e6)) +
    theme_minimal()
  pp[[value]] <- p
}

png(file="spermcovars.png", width=1100, height=300)
grid.arrange(pp[["Depth"]], pp[["SST"]], pp[["NPP"]], ncol=3)
dev.off()

