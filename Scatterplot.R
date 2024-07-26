# Scatter plot 

ggplot(trees,aes(x=Girth,y=Height))+geom_point() 

#change feature of points
ggplot(trees,aes(x=Girth,y=Height))+geom_point(shape=21,size=3)
# default shape=16,size=2

# groups of points
ggplot(mpg,aes(x=cty,y=hwy,shape=class))+geom_point()+
  scale_shape_manual(values = 1:7)

ggplot(mpg,aes(x=cty,y=hwy,colour=class))+geom_point()

ggplot(mpg,aes(x=cty,y=hwy,colour=class,shape=class))+geom_point()+
  scale_shape_manual(values = 1:7)

ggplot(mtcars,aes(x=drat,y=wt,shape=factor(am),colour=factor(am)))+
  geom_point()+scale_shape_manual(values = 1:2)+scale_color_manual(values = c("red","black"))

#for shape 21-25,we can also change fill
ggplot(mtcars,aes(x=drat,y=wt))+
  geom_point(colour="red",fill="black",size=5,shape=21)

ggplot(mtcars,aes(x=drat,y=wt,shape=as.factor(am),colour=as.factor(am),fill=as.factor(am)))+
  geom_point(size=4)+scale_shape_manual(values = 21:22)+
  scale_color_manual(values = c("red","black"))+
  scale_fill_manual(values = c("black","red"))

#if 3rd variable is continuous
ggplot(mpg,aes(x=cty,y=hwy,size=displ))+geom_point()

ggplot(mpg,aes(x=cty,y=hwy,colour=displ))+geom_point()

ggplot(mtcars,aes(x=drat,y=wt,fill=qsec))+
  geom_point(shape=21,colour="black",fill="red",alpha=0.5)

ggplot(mtcars,aes(x=drat,y=wt,size=qsec,fill=factor(am)))+
  geom_point(shape=21,colour="black",alpha=0.5)

ggplot(mtcars,aes(x=drat,y=wt,size=qsec,fill=factor(am)))+
  geom_point(shape=21,colour="black",alpha=0.5)+
  scale_size_area()

## transparency
ggplot(diamonds,aes(x=carat,y=price))+geom_point(alpha=0.01)

#jitter
ggplot(Loblolly,aes(x=age,y=height))+geom_point()
ggplot(Loblolly,aes(x=age,y=height))+
  geom_point(position = position_jitter())
# default 40% of the resolution of data

#adding fitted lines 
#linear regression
ggplot(trees,aes(x=Girth,y=Height))+geom_point()+
  geom_smooth(method = lm)

#default 95% confidence region
ggplot(trees,aes(x=Girth,y=Height))+geom_point()+
  geom_smooth(method = lm,level=0.99)

ggplot(trees,aes(x=Girth,y=Height))+geom_point()+
  geom_smooth(method = lm,se=F)

lm(trees$Height~trees$Girth)
txt<-"italic(y)==62.031+1.054*italic(x)"
ggplot(trees,aes(x=Girth,y=Height))+geom_point()+
  geom_smooth(method = lm,level=0.99)+
  annotate("text",label=txt,x=18,y=65,parse=T)

ggplot(trees,aes(x=Girth,y=Height))+geom_point()+
  geom_smooth() #locally weighted polynomial curbe

#logistic regression
ggplot(mtcars,aes(x=mpg,y=am))+geom_point()+
  geom_smooth(method = glm,method.args=list(family="binomial"))

#add marginal rugs 
ggplot(faithful,aes(x=eruptions,y=waiting))+geom_point()+
  geom_rug(size=1)

#add labels
CARS<-rownames(mtcars)
new<-data.frame(CARS,mtcars)

ggplot(new,aes(x=drat,y=wt))+geom_point()+
  geom_text(aes(label=CARS),size=3,vjust=1,hjust=-0.2)


