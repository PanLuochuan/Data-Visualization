######  line chart + area chart  + add confidence interval
# basic line chart
library(ggplot2)
g<-ggplot(trees,aes(x=Girth,y=Height))
g+geom_line() 

#expand the limits
g+geom_line()+expand_limits(x=c(5,25))

# add points to a line
g+geom_line()+geom_point()+scale_y_log10() 
g+geom_line()+geom_point()+scale_x_log10() 

sleep
ggplot(sleep,aes(x=as.numeric(ID),y=extra))+geom_line()

#multiple lines
#third variable discrete

ggplot(sleep,aes(x=as.numeric(ID),y=extra,colour=group))+geom_line()

ggplot(sleep,aes(x=as.numeric(ID),y=extra,linetype=group))+geom_line()

ggplot(sleep,aes(x=as.numeric(ID),y=extra,shape=group))+geom_line()+geom_point()

ggplot(sleep,aes(x=as.numeric(ID),y=extra,group=group))+geom_line()

#change line and point features
g<-ggplot(trees,aes(x=Girth,y=Height))
g+geom_line(colour="red",linetype="dashed",size=2)+geom_point()

g+geom_line(colour="red",linetype="dotted",size=0.5)+
  geom_point(shape=22,size=3,colour="blue",fill="red")

ggplot(sleep,aes(x=as.numeric(ID),y=extra,fill=group))+
  geom_line()+geom_point(shape=21,size=2)

##### area chart 
dt<-data.frame(1871:1970,Nile) 
names(dt)<-c("Year","Flow")

ga<-ggplot(dt,aes(x=Year,y=Flow))
ga+geom_area() 

#change area features
ga+geom_area(fill="lightpink",colour="darkred")
##transparency
ga+geom_area(fill="lightpink",colour="darkred",alpha=0.2)#80% transparent
ga+geom_area(fill="lightpink",colour="darkred",alpha=0.4)#60% transparent

#stacked area chart 
Year<-rep(1960:1980,rep(4,21))
Quarter<-rep(1:4,21)
ds<-data.frame(Year,JohnsonJohnson,Quarter)
names(ds)<-c("Year","Earnings","Quarter")

ggplot(ds,aes(x=Year,y=Earnings,fill=factor(Quarter)))+geom_area(alpha=0.7)

#add confidence interval 
dt<-data.frame(seq(1871,1970,1),Nile)
names(dt)<-c("Year","Flow")
ga<-ggplot(dt,aes(x=Year,y=Flow))
std<-sd(dt$Flow)
#geom_ribbon
ga+geom_ribbon(aes(ymin=Flow-std,ymax=Flow+std),alpha=0.3)+
                 geom_line()

ga+geom_line()+geom_ribbon(aes(ymin=Flow-std,ymax=Flow+std),alpha=0.3)

##geom_line()
ga+geom_line(aes(y=Flow-std),linetype="dashed",colour="darkgrey")+
  geom_line(aes(Flow+std),linetype="dashed",colour="darkgrey")+
  geom_line()

