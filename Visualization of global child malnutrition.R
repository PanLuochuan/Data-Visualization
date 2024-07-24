library(tidyverse)
library(gifski)
library(gganimate)
library(map)
library(plotly)
library(viridis)
library(RColorBrewer)

data1<-read.csv(file.choose())
head(data1)
data1<-na.omit(data1)
data2<-read.csv(file.choose(),header = T)
data2<-na.omit(data2)
head(data2)
str(data1)


### Trends in nutritional status over time
data2_1 <- data2 %>% 
  filter(!is.na(Wasting) & !is.na(Stunting) & !is.na(Overweight) & !is.na(Underweight) & !is.na(Severe.Wasting)) %>%
  group_by(Year) %>%
  summarise(Avg_Wasting = mean(Wasting, na.rm = TRUE),
            Avg_Stunting = mean(Stunting, na.rm = TRUE),
            Avg_Overweight = mean(Overweight, na.rm = TRUE),
            Avg_Underweight = mean(Underweight, na.rm = TRUE),
            Avg_Severe.Wasting = mean(Severe.Wasting, na.rm = TRUE))

data_long <- pivot_longer(data2_1, cols = c(Avg_Wasting, Avg_Stunting, Avg_Overweight,Avg_Underweight,Avg_Severe.Wasting), 
                          names_to = "Condition", values_to = "Average")

ggplot(data_long,aes(x=Year,y=Average,group=Condition,colour=factor(Condition)))+
  geom_line()+
  labs(title = "Trends in Global Malnutrition Indicators", y = 'Average Percentage', x = 'Year') +
  transition_reveal(Year)

### Number of countries in different income categories
income_counts <- aggregate(Country ~ Income.Classification, data = data1, FUN = length)
income_counts$Income.Classification <- factor(income_counts$Income.Classification,
                                              levels = c("0", "1", "2", "3"),
                                              labels = c("Low Income", "Lower Middle Income", "Upper Middle Income", "High Income"))

ggplot(income_counts, aes(x = as.factor(Income.Classification), y = Country)) +
  geom_bar(stat = "identity", fill = c("#2c7bb6", "#fdae61", "#d7191c", "#abd9e9"), color = "black") +
  theme_minimal() +
  labs(title = "Number of Countries per Income Classification",
       x = "Income Classification",
       y = "Number of Countries") +
  theme(axis.text.x = element_text( hjust = 1),
        panel.grid.major = element_blank(),   
        panel.grid.minor = element_blank(),   
        panel.background = element_rect(fill = "white", colour = "white")) +  
  coord_flip()

### relation chart
library(corrplot)
numeric_data1 <- data1[, sapply(data1, is.numeric)]
cor_matrix <- cor(numeric_data1, use = "complete.obs")
corrplot(cor_matrix, method = "color", tl.col = "black",tl.srt = 45,tl.cex = 0.8) 
corrplot(cor_matrix, method = "color", 
         tl.col = "black",  
         tl.srt = 45,       
         tl.cex = 0.8,      
         addCoef.col = "black",  
         number.cex = 0.6,       
         addCoefasPercent = TRUE) 

### Income and region

data2$LLDC.or.SID2 <- factor(data2$LLDC.or.SID2, levels = c(0, 1, 2),
                               labels = c("Others", "Land Locked Developing Countries (LLDC)", "Small Island Developing States (SIDS)"))


data2$Income.Classification <- factor(data2$Income.Classification, levels = c(0, 1, 2, 3),
                                       labels = c("Low Income", "Lower Middle Income", "Upper Middle Income", "High Income"))


summary_data <- aggregate(Country ~ Income.Classification + LLDC.or.SID2, data2, length)

ggplot(summary_data, aes(x = Income.Classification, y = Country, fill = LLDC.or.SID2)) +
  geom_bar(stat = "identity") +  
  labs(title = "Relationship between Income Classification and LLDC or SID2",
       x = "Income Classification",
       y = "Number of Countries") +
  scale_fill_manual(values = c("Others" = "#abd9e9", 
                               "Land Locked Developing Countries (LLDC)" = "#fdae61", 
                               "Small Island Developing States (SIDS)" = "#d7191c")) +
  theme(axis.text.x = element_text( hjust = 1),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),   
        panel.background = element_rect(fill = "white", colour = "white")) + 
  coord_flip()

library(maps)
library(mapdata)

### 1. Severe Wasting
income_wast <- aggregate(Severe.Wasting ~ Income.Classification, data1, mean, na.rm = TRUE)
ggplot(income_wast, aes(x = as.factor(Income.Classification), y = Severe.Wasting)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(title = "Severe Wasting",
       x = "Income Classification",
       y = "% Severe Wasting") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
income_wast$Income.Classification <- factor(income_wast$Income.Classification,
                                            levels = c("0", "1", "2", "3"),
                                            labels = c("Low Income", "Lower Middle Income", "Upper Middle Income", "High Income"))


ggplot(income_wast, aes(x = Income.Classification, y = Severe.Wasting, fill = Income.Classification)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Low Income" = "#1b9e77", 
                               "Lower Middle Income" = "#d95f02", 
                               "Upper Middle Income" = "#7570b3", 
                               "High Income" = "#e7298a")) +  
  theme_minimal() +
  labs(title = "The Distribution of Severe Wasting in Different Income Categories",
       x = "Income Classification",
       y = "Severe Wasting") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

country_wast <- aggregate(Severe.Wasting ~ Country, data1, mean, na.rm = TRUE)
fig <- plot_ly(
  type = 'choropleth',
  locations = country_wast$Country,
  locationmode = 'country names',
  z = country_wast$Severe.Wasting,
  text = country_wast$Country,
  colorscale = 'Portland',
  colorbar = list(title = 'Severe Wasting', len = 200, lenmode = 'pixels')
)


fig <- fig %>% layout(
  title = "Severe Wasting around the world",
  geo = list(scope = 'world')
)

fig

### Wasting

income_wast <- aggregate(Wasting ~ Income.Classification, data1, mean, na.rm = TRUE)
income_wast$Income.Classification <- factor(income_wast$Income.Classification,
                                            levels = c(0, 1, 2, 3),  
                                            labels = c("Low Income", "Lower Middle Income", "Upper Middle Income", "High Income"))

ggplot(income_wast, aes(x = "", y = Wasting, fill = Income.Classification)) +
  geom_bar(stat = "identity", width = 1) +  
  coord_polar(theta = "y") +  
  labs(title = "Wasting by Income Classification", x = NULL, y = NULL) +  
  theme_void() +  
  theme(legend.title = element_blank(), legend.position = "bottom") + 
  scale_fill_manual(values = c("Low Income" = "#a1dab4", 
                               "Lower Middle Income" = "#a6bddb",  
                               "Upper Middle Income" = "#d0bfe6",  
                               "High Income" = "#fbb4b9")) 

country_wast <- aggregate(Wasting ~ Country, data1, mean, na.rm = TRUE)
fig <- plot_ly(
  type = 'choropleth',
  locations = country_wast$Country,
  locationmode = 'country names',
  z = country_wast$Wasting,
  text = country_wast$Country,
  colorscale = 'Portland',
  colorbar = list(title = 'Wasting', len = 200, lenmode = 'pixels')
)

fig <- fig %>% layout(
  title = "Wasting around the world",
  geo = list(scope = 'world')
)
fig

### Overweight
average_overweight <- aggregate(Overweight ~ Income.Classification, data1, mean)
data1$Income.Classification <- factor(data1$Income.Classification,
                                      levels = c(0, 1, 2, 3),
                                      labels = c("Low Income", "Lower Middle Income", "Upper Middle Income", "High Income"))

ggplot(data1, aes(x = as.factor(Income.Classification), y = Overweight, fill = as.factor(Income.Classification))) +
  geom_boxplot(outlier.shape = NA) +  
  labs(title = "Overweight by Income Classification",
       x = "Income Classification",
       y = "Overweight") +
  scale_fill_manual(name = "Income Classification", values = c("Low Income" = "#a1dab4", 
                                                               "Lower Middle Income" = "#a6bddb",  
                                                               "Upper Middle Income" = "#d0bfe6",  
                                                               "High Income" = "#fbb4b9")) +  
  theme_minimal() +
  theme(axis.text.x = element_text(hjust = 1))  #

country_overweight <- aggregate(Overweight ~ Country, data1, mean, na.rm = TRUE)

fig <- plot_ly(
  type = 'choropleth',
  locations = country_overweight$Country,
  locationmode = 'country names',
  z = country_overweight$Overweight,
  text = country_overweight$Country,
  colorscale = 'Portland',
  colorbar = list(title = 'Overweight', len = 200, lenmode = 'pixels')
)

fig <- fig %>% layout(
  title = "Overweight around the world",
  geo = list(scope = 'world')
)
fig

### stunting 
data1$Income.Classification <- factor(data1$Income.Classification,
                                      levels = c(0, 1, 2, 3),
                                      labels = c("Low Income", "Lower Middle Income", "Upper Middle Income", "High Income"))
income_wast <- aggregate(Stunting ~ Income.Classification, data1, mean, na.rm = TRUE)
ggplot(data1, aes(x = as.factor(Income.Classification), y = Stunting, fill = as.factor(Income.Classification))) +
  geom_violin(trim = FALSE) +  
  scale_fill_manual(values = c("Low Income" = "#a1dab4",  
                               "Lower Middle Income" = "#a6bddb", 
                               "Upper Middle Income" = "#d0bfe6",  
                               "High Income" = "#fbb4b9"),
                    name="Income Classification") + 
  labs(title = "Stunting by Income Classification",  
       x = "Income Classification", 
       y = "Stunting") +  
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

country_stunting <- aggregate(Stunting ~ Country, data1, mean, na.rm = TRUE)
fig <- plot_ly(
  type = 'choropleth',
  locations = country_stunting$Country,
  locationmode = 'country names',
  z = country_stunting$Stunting,
  text = country_stunting$Country,
  colorscale = 'Portland',
  colorbar = list(title = 'Stunting', len = 200, lenmode = 'pixels')
)

fig <- fig %>% layout(
  title = "Stunting around the world",
  geo = list(scope = 'world')
)
fig

### Underweight
income_wast <- aggregate(Underweight ~ Income.Classification, data1, mean, na.rm = TRUE)
ggplot(income_wast, aes(x = as.factor(Income.Classification), y = Underweight, fill = as.factor(Income.Classification))) +
  geom_bar(stat = "identity") +  # 使用identity统计变换绘制条形图
  scale_fill_manual(values = c("skyblue", "lightgreen", "salmon", "gold"),
                    name="Income Classification") +  
  theme_minimal() +  
  labs(title = "Underweight by Income Classification",  
       x = "Income Classification", 
       y = "% Underweight") +  
  theme(axis.text.x = element_text(hjust = 1)) 
country_underweight <- aggregate(Underweight ~ Country, data1, mean, na.rm = TRUE)

fig <- plot_ly(
  type = 'choropleth',
  locations = country_underweight$Country,
  locationmode = 'country names',
  z = country_underweight$Underweight,
  text = country_underweight$Country,
  colorscale = 'Portland',
  colorbar = list(title = 'Underweight', len = 200, lenmode = 'pixels')
)

fig <- fig %>% layout(
  title = "Underweight around the world",
  geo = list(scope = 'world')
)
fig







