### Heatmaps

library(ggplot2)
library(RColorBrewer)
Year<-rep(1960:1980,rep(4,21))
Quarter<-rep(1:4,21)
ds<-data.frame(Year,as.numeric(JohnsonJohnson),Quarter)
names(ds)<-c("Year","Earnings","Quarter")

gs<-ggplot(ds,aes(x=Year,y=Quarter,fill=Earnings))
gs+geom_tile() 
gs+geom_tile()+
  scale_fill_gradient2(midpoint = 7,mid = "plum",limits=c(0,20))

gs+geom_raster()
gs+geom_raster()+
  scale_fill_gradient2(midpoint = 7,mid = "steelblue",low = "hotpink",high="seagreen")

gs+geom_tile(color="white",lwd=1.5,linetype=1)+
  scale_fill_gradient2(midpoint = 7,mid = "steelblue",low = "hotpink",high="seagreen")

gs+geom_tile(color="white",lwd=1.5,linetype=1)+
  scale_fill_gradient2(midpoint = 7,mid = "steelblue",low = "hotpink",high="seagreen")+
  coord_fixed()

gs+geom_tile(color="white",lwd=1.5,linetype=1)+
  geom_text(aes(label=Earnings),color="white",size=2)+
  scale_fill_gradient2(midpoint = 7,mid = "steelblue",low = "hotpink",high="seagreen")+
  coord_fixed()


### Maps
library(map)
library(mapproj)
library(rgdal)
library(tmap)
library(osmdata)
library(sf)
library(ggmap)
library(MAP)

#package maps and mapproj
#world map
map1<-map_data("world")
head(map1)

ggplot(map1,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="skyblue",colour="darkblue")

ggplot(map1,aes(x=long,y=lat,group=group))+
  geom_path(fill="skyblue",colour="darkblue")

ggplot(map1,aes(x=long,y=lat,group=group))+
  geom_path(colour="seagreen") 

#separate country-detail map only for
#new zealand ,italy,france,usa


map2<-map_data("italy")
ggplot(map2,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="bisque",colour="chocolate")


msia<-map_data("world",region="Malaysia") 
ggplot(msia,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="skyblue",colour="darkblue")

#other countries-take from the world map
table(map1$region)
china<-map_data("world",region="China")
ggplot(china,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="bisque",colour="chocolate")

#rgdal
#readOGR that reads SHP file
selangor<-readOGR(dsn="C:/users/atiqah/Documents/Selangor",layer="Selangor")

ggplot(selangor,aes(x=long,y=lat,group=group))+
  geom_polygon() 
selangor<-fortify(selangor)

ggplot(selangor,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="wheat",colour="tan4")

library(sf)
selangor <- st_read("D:/ukm.ppt/数据可视化/Data for Map of Selangor/Selangor.shp")
ggplot(selangor) +
  geom_sf(fill="wheat", colour="tan4")

#add points
mymap<-read.csv(file="D:/ukm.ppt/数据可视化/Data for Map of Selangor/rain_selangor.csv",header=T)
ggplot(selangor,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude),data=mymap,shape=3,inherit.aes=F)

ggplot(selangor)+
  geom_sf(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude),data=mymap,shape=3,inherit.aes=F)

ggplot(selangor)+
  geom_sf(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude),data=mymap,shape=3,inherit.aes=F)+
  geom_density_2d(aes(x=longitude,y=latitude),data=mymap,inherit.aes=F)

ggplot(selangor)+
  geom_sf(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude,size=ave),
             data=mymap,inherit.aes=F,alpha=0.5)
#add contours
ggplot(mais,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude),data=mymap,shape=3,inherit.aes=F)+
  geom_density_2d(aes(x=longitude,y=latitude),data=mymap,inherit.aes = F)

ggplot(selangor,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude),data=mymap,shape=3,inherit.aes=F)+
  geom_density_2d(aes(x=longitude,y=latitude),data=mymap,inherit.aes=F)
# 换成sf
ggplot(selangor)+
  geom_sf(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude),data=mymap,shape=3,inherit.aes=F)+
  geom_density_2d(aes(x=longitude,y=latitude),data=mymap,inherit.aes=F)

#bubbles
ggplot(selangor,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude,size=ave),
             data=mymap,inherit.aes=F,alpha=0.5)
# 换成sf
ggplot(selangor)+
  geom_sf(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude,size=ave),
             data=mymap,inherit.aes=F,alpha=0.5)


ggplot(msia,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="wheat",colour="tan4")+
  geom_point(aes(x=longitude,y=latitude,size=ave),
             data=mymap,inherit.aes=F,alpha=0.5)

#cloropleth
ggplot(selangor,aes(x=long,y=lat,group=group,fill=group))+
  geom_polygon(colour="black")
#RColorCrewer
mypal<-colorRampPalette(brewer.pal(9, "Set1"))(18)
ggplot(selangor,aes(x=long,y=lat,group=group,fill=group))+
  geom_polygon(colour="black")+
  scale_fill_manual(values=mypal)

#tmap package
tm_shape(selangor)+tm_fill()

tm_shape(selangor) + tm_borders()

tm_shape(selangor) + tm_fill() + tm_borders()
tm_shape(selangor) + tm_polygons()

tm_shape(selangor) + tm_fill(col = "red", alpha = 0.3)

tm_shape(selangor) + tm_fill(col = "red", alpha = 0.3) +
  tm_borders(col = "blue", lwd = 3, lty = 2)


map_selangor<-tm_shape(selangor)+tm_polygons()
map_selangor+tm_layout(title="Malaysia")

map_selangor+tm_layout(bg.color="floralwhite")
map_selangor+tm_layout(frame=F) 
map_selangor + tm_layout(scale = 5)
map_selangor+tm_style("bw")
map_selangor+tm_style("classic")
map_selangor+tm_style("cobalt")

legend_title <- expression("Area (km"^2*")")
tm_shape(selangor) + tm_fill(col="ID_1",
                             title = legend_title) + tm_borders()


#open streeMap
#package osm data,sf,ggmap
head(available_features())
head(available_tags("shop"))
head(available_tags("amenity"))

#build the query
library(tidyverse)
q<-getbb("madrid")%>%opq()%>%add_osm_features("amenity","cinema")

q<-add_osm_feature(opq(getbb("Madrid")),"amenity","cinema")

str(q)
#getbb will create boundary box
#opq main function for query
#add_osm_feature -filter criteria

cinema<-osmdata_sf(q)
cinema

selangor<-st_read("")
selangor<-fortify(selangor) 
register_stadiamaps("33437500-15db-4f5d-a063-e34b10e4b5c0") 
#background map
mad_map<-get_stadiamap(getbb("Madrid"),maptype="stamen_toner") 
ggmap(mad_map)+
  geom_sf(data = cinema$osm_points,inherit.aes = F,alpha=0.5,size=4,shape=21,
          colour="darkblue",fill="skyblue")+labs(x="",y="")

ggmap(mad_map)+
  geom_sf(data = cinema$osm_points,
          inherit.aes = FALSE,colour = "seagreen",fill = "darkgreen",
          alpha = 0.5,size = 4,shape = 21)+
  labs(x = "", y = "")

#build our own box
m <- c(-10, 30, 5, 46) 
q<-add_osm_feature(add_osm_feature(opq(m,timeout = 25*10),
                                   "name","Mercadona"),"shop", "supermarket")

mercadona <- osmdata_sf(q)

st_crs(mercadona$osm_points) <- 4326

ggplot(mercadona$osm_points)+
  geom_sf(colour = "darkblue",fill = "steelblue",
          alpha = 0.5,size = 1,shape = 21)+
  theme_void()

m <- c(99, 1, 120, 6)
q<-add_osm_feature(opq(m,timeout = 25*10),"shop", "coffee")
coffee<-osmdata_sf(q)
ggplot(coffee$osm_points)+geom_sf(alpha=0.5,size=4,shape=21,
                                 colour="darkblue",fill="skyblue")+theme_void()

msia <- get_map(m, maptype = "toner-lite")
ggmap(msia)+
  geom_sf(data = coffee$osm_points,
          inherit.aes = FALSE,colour = "darkred",fill = "lightpink",
          alpha = 0.5,size = 4,shape = 21)+
  labs(x = "", y = "")

msia<-get_stadiamap(m,maptype = "stamen_toner")
ggmap(msia)+
  geom_sf(dat = coffee$osm_points,inherit.aes = F,alpha=0.5,size=4,shape=21,
          colour="darkblue",fill="skyblue")+labs(x="",y="")

msia<-map_data("world",region="Malaysia") 
ggplot(msia,aes(x=long,y=lat,group=group))+
  geom_polygon(fill="skyblue",colour="darkblue")+
  geom_sf(data = coffee$osm_points,
          inherit.aes = FALSE,colour = "darkred",fill = "lightpink",
          alpha = 0.5,size = 4,shape = 21)+
  labs(x = "", y = "")





