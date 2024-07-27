library(MASS)

#Box plot
ggplot(birthwt,aes(x=factor(race),y=bwt))+geom_boxplot()

#change outliers
ggplot(birthwt,aes(x=factor(race),y=bwt))+
  geom_boxplot(coef=2)

#change feature
ggplot(birthwt,aes(x=factor(race),y=bwt))+
  geom_boxplot(outlier.size = 3,outlier.shape = 21,
               outlier.colour = "red",outlier.fill = "pink")

#a single box plot
#change outlier
ggplot(birthwt,aes(x=1,y=bwt))+
  geom_boxplot()

# notched box plot
ggplot(birthwt,aes(x=factor(race),y=bwt))+
  geom_boxplot(notch = T)

#add markers for means
ggplot(birthwt,aes(x=factor(race),y=bwt))+
  geom_boxplot()+
  stat_summary(fun.y = "mean",geom = "point",shape=23,size=3,fill="blue")

#group boxplot
ggplot(birthwt,aes(x=factor(race),y=bwt,fill=factor(smoke)))+
  geom_boxplot()
ggplot(birthwt,aes(x=factor(race),y=bwt,fill=factor(smoke)))+
  geom_boxplot(width=0.5,position = position_dodge(width = 0.7))

#violin plot 
ggplot(birthwt,aes(x=factor(race),y=bwt))+
  geom_violin()


