library(ggplot2)
#################bar chart  + histogram
#bar chart with table 
# Discrete variable 
x<-1:5
y<-round(runif(5,1,10))
z<-data.frame(x,y)
z
ggplot(data = z,aes(x=x,y=y))+geom_bar(stat = "identity")

#if x continuous variable 
x<-c(1,1.3,1.4,2.0,2.5)
y<-round(runif(5,1,10))
z<-data.frame(x,y)

ggplot(data = z,aes(x=x,y=y))+geom_bar(stat = "identity")

#force x to be discrete 
ggplot(data = z,aes(x=factor(x),y=y))+geom_bar(stat = "identity")

#change colour
ggplot(data = z,aes(x=x,y=y))+geom_bar(stat = "identity",fill="lightgreen")
ggplot(data = z,aes(x=x,y=y))+geom_bar(stat = "identity",fill=rainbow(5))

#add border
ggplot(data = z,aes(x=x,y=y))+geom_bar(stat = "identity",fill="lightgreen",colour="black")

#count data 
# continuous variable
mpg
ggplot(data = mpg,aes(x=class))+geom_bar()
b<-ggplot(data = mpg)
b+geom_bar(aes(x=class),colour="skyblue",fill="steelblue")
b+geom_bar(aes(x=displ))
b+geom_histogram(aes(x=displ))#直方图
b+geom_histogram(aes(x=displ),bins = 50,fill="lightcoral")
b+geom_histogram(aes(x=displ),binwidth = 0.1,fill="lightcoral")

#change colour with respect to categpries
a<-c("A","B","C","D","E","F","G","H","I","J")
b<-ceiling(runif(10,10,13)) 
c<-round(runif(10,5,20))
d<-data.frame(a,b,c)

ggplot(data = d,aes(x=a,y=c,fill=b))+geom_bar(stat = "identity")

ggplot(data = d,aes(x=a,y=c,fill=factor(b)))+geom_bar(stat = "identity")

ggplot(data = d,aes(x=a,y=c))+geom_bar(stat = "identity",fill=b)

f<-factor(b,labels = c("First","Second","Third"))    
e<-data.frame(a,f,c)       
ggplot(data = e,aes(x=a,y=c,fill=f))+geom_bar(stat = "identity")
ggplot(data = e,aes(x=a,y=c))+geom_bar(stat = "identity",fill=f)

g<-factor(b,labels = c("red","violet","coral"))
e<-data.frame(a,f,c,g)
ggplot(data = e,aes(x=a,y=c))+geom_bar(stat = "identity",fill=g)

#group data
x<-rep(1:3,2) 
y<-rep(1:2,3)
r<-round(runif(6,1,10))
z<-data.frame(x,y,r)
table(z$x,z$y) 
ggplot(data = z,aes(x=factor(x),y=r,fill=factor(y)))+
  geom_bar(stat = "identity",colour="black")

ggplot(data = z,aes(x=factor(x),y=r,fill=factor(y)))+
  geom_bar(stat = "identity",colour="black",position = "dodge")
#or
ggplot(data = z,aes(x=factor(x),y=r,fill=factor(y)))+
  geom_bar(stat = "identity",colour="black",position=position_dodge())

z1<-z[-6,] 
z1
ggplot(data = z1,aes(x=factor(x),y=r,fill=factor(y)))+
  geom_bar(stat = "identity",colour="black")

ggplot(data = z1,aes(x=factor(x),y=r,fill=factor(y)))+
  geom_bar(stat = "identity",colour="black",position = "dodge")

z2<-rbind(z1,c(3,2,NA))
ggplot(data = z2,aes(x=factor(x),y=r,fill=factor(y)))+
  geom_bar(stat = "identity",colour="black",position = "dodge")

#group count data
ggplot(data=mpg,aes(x=class,fill=drv))+geom_bar(position = "dodge")
ggplot(data=mpg,aes(x=class,fill=drv))+geom_bar()

#set bar width and spacing 
ggplot(data=mpg,aes(x=class,fill=drv))+geom_bar(width = 0.5) 
ggplot(data=mpg,aes(x=class,fill=drv))+geom_bar(width = 1)

ggplot(data=mpg,aes(x=class,fill=drv))+geom_bar(width = 0.5,position = "dodge")

# width=x makes each group total width=x
ggplot(data=mpg,aes(x=class,fill=drv))+geom_bar(width = 0.5,position = position_dodge(width = 0.7))

#position_dodge(width=x) makes the middle of each bar
#where it would be if the bar width is x and touching

#add labels
x<-1:5
y<-round(runif(5,1,10))
z<-data.frame(x,y)

ggplot(data = z,aes(x=x,y=y))+geom_bar(stat="identity")+
  geom_text(aes(label=y),colour="red",vjust=-0.5)

b<-ggplot(data=mpg)
mpg$class
tab<-data.frame(table(mpg$class))
b+geom_bar(aes(x=class),fill="steelblue")+
  geom_text(aes(x=1:7,y=Freq,label=Freq),data=tab,vjust=1,size=3)
#default size font=5

#reorder bars
a<-c("A","B","C","D","E","F","G","H","I","J")
b<-ceiling(runif(10,10,13))
c<-round(runif(10,5,20))
d<-data.frame(a,b,c)

ggplot(data=d,aes(x=a,y=c))+geom_bar(stat = "identity")

ggplot(data=d,aes(x=a,y=c))+geom_bar(stat = "identity")+
  scale_x_discrete(limits=c("A","C","B","D","E","F","G","H","I","J"))

ggplot(data=d,aes(x=reorder(a,b),y=c))+geom_bar(stat = "identity")

library(rmarkdown)
rmarkdown::run("barchats.Rmd")


