# There are three sub-themes in total #
library(tidyverse)
library(ggplot2)
library(plotly)
library(leaflet)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(sf)
library(gganimate)
library(gifski)
library(lubridate)
library(usmap)
library(htmlwidgets)

#####Sub-theme 1: Weapon Type and Shooting Incidents#####

# Static bar chart showing the frequency of weapon types used in all shootings
# The dynamic graph shows the change in the frequency of use of each weapon type in different years
# Interactive bar chart showing the top five weapon types used in all shootings, with hovering options to view specific values


# Reading Data
data <- read.csv(file.choose())

# Check data types
str(data)



#（Static Plot）
# Extract and clean weapon type data
weapon_data <- data %>%
  filter(!is.na(arms_category)) %>%
  count(arms_category) %>%
  arrange(desc(n))

# Creating a Bar Chart
p <- ggplot(weapon_data, aes(x = reorder(arms_category, -n), y = n, fill = arms_category)) +
  geom_bar(stat = "identity") +
  labs(title = "Frequency of use of different weapon types", x = "Weapon Types", y = "Usage frequency") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#
print(p)

#（GIF Animation）
data <- data %>%
  filter(!is.na(arms_category)) %>%
  mutate(date = ymd(date),  # Convert a date to a Date type
         year = year(date)) %>%  # Extraction Year
  count(year, arms_category) %>%
  arrange(year, desc(n))

p <- ggplot(data, aes(x = reorder(arms_category, -n), y = n, fill = arms_category)) +
  geom_bar(stat = "identity") +
  labs(title = 'Annual change in weapon type usage frequency: {closest_state}', x = 'Weapon Types', y = 'Usage frequency') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  transition_states(year, transition_length = 2, state_length = 1) +
  ease_aes('cubic-in-out')

p



weapon_data <- data %>%
  filter(!is.na(arms_category)) %>%
  count(arms_category) %>%
  arrange(desc(n)) %>%
  head(5)

p <- plot_ly(weapon_data, x = ~reorder(arms_category, -n), 
             y = ~n, type = 'bar', marker = list(color = 'rgb(158,202,225)',
             line = list(color = 'rgb(8,48,107)', width = 1.5))) %>%
  layout(title = "Frequency of use of the top five most common weapon types",
         xaxis = list(title = "Weapon Types"),
         yaxis = list(title = "Usage frequency"))


# Save as HTML file to the specified directory
htmlwidgets::saveWidget(as_widget(p), file_path)

# Print the file path to confirm whether it is correct
print(file_path)

# Since my (PANZHANGYU) computer has problems, this method can be used to generate interactive diagrams
# You need to find the corresponding path and click to view the html file



#####Sub-theme 2: Ethnic distribution of shooting victims#####


shoot<-read.csv(file.choose(),header = T)
head(shoot)
sum(is.na(shoot))
shoot$date<-as.Date(shoot$date,format="%Y-%m-%d")
shoot$year<-year(shoot$date)

# Racial distribution of shooting victims
race_count <- shoot %>%group_by(race) %>%
  summarise(count = n(), .groups = 'drop') 
fig <- plot_ly(race_count, labels = ~race, values = ~count, type = 'pie', textinfo = 'label+percent+value',
               hoverinfo = 'label+percent', insidetextorientation = 'radial', textfont = list(size = 12))
fig %>% layout(title = list(text = 'Percentage of Shooting Incidents by Race', x = 0.5),
               showlegend = TRUE)

## Number of shootings per state
shoot_df<-as.data.frame(table(shoot$state))
names(shoot_df)<-c('state','number_of_case')
plot_usmap(data=shoot_df, values = "number_of_case", color = "black") + scale_fill_continuous(low = "white", high = "darkred", name = "Total shooting case",label = scales::comma)+theme(legend.position = "right")

# Plot a histogram of the racial distribution of victims in these states
top_shoot<-shoot_df %>% top_n(3,number_of_case)
top_states_data <- shoot %>% filter(state %in% top_shoot$state)
ggplot(top_states_data, aes(x = race, fill = race)) +
  geom_bar() +
  facet_wrap(~state, scales = "fixed") +
  theme_minimal() +
  labs(title = "Top States by Shooting Cases: Victim Race Distribution",
       x = "Race",
       y = "Number of Cases",
       fill = "Race")


## Changes in the proportion of victims by race over time
race_year <- shoot %>% group_by(year, race) %>%
  summarise(count = n(), .groups = 'drop')

ggplot(race_year, aes(x = year, y = count, group = race, colour =factor(race))) +
  geom_line() + 
  scale_x_continuous(breaks = unique(race_yearly$year)) +  
  labs(x = "Year", y = "Number of Victims", title = "Changes in the proportion of victims by race over time") +
  transition_reveal(year) +
  theme_minimal()   



#####Sub-theme 3: Mental health and shootings#####

df<-read.csv(file.choose())
#View data
head(df)
# Check for missing values
sum(is.na(df))

#1. Static Image
data<-data.frame(df$id,df$manner_of_death,df$signs_of_mental_illness)
head(data)

#Discrete Variable 
b <- ggplot(data=df,aes(x=signs_of_mental_illness,fill=manner_of_death)) 
b <- b + geom_bar(width=0.5, position=position_dodge(0.7))
b <- b + ggtitle('Number of victims with mental health problems')  
b <- b + theme(plot.title=element_text(face="bold.italic",colour="darkred"))
b <- b + xlab("Whether there are psychological problems") + ylab("count")
print(b)

# Calculate the ratio
true_ratio <- sum(df$signs_of_mental_illness == "True") / length(df$id)
false_ratio <- sum(df$signs_of_mental_illness == "False") / length(df$id)

# Create a new data frame
df_ratio <- data.frame(
  signs_of_mental_illness = c("True", "False"),
  ratio = c(true_ratio, false_ratio)
)

# Draw a pie chart
pie <- ggplot(df_ratio, aes(x = "", y = ratio, fill = factor(signs_of_mental_illness)))
pie <- pie + geom_bar(stat = "identity", width = 1) 
pie <- pie + coord_polar(theta = "y")
pie <- pie + geom_text(aes(label = scales::percent(ratio)), position = position_stack(vjust = 0.5))
print(pie)

#Interactive graph
plot_ly(data=df, x = ~signs_of_mental_illness, color=~threat_level) %>% add_histogram(name="threat_level")


#GIF Animation
df$date <- as.Date(df$date)
df$year <- year(df$date)
df$month <- month(df$date)
df$signs_of_mental_illness <- as.logical(df$signs_of_mental_illness)
df$year <- as.numeric(df$year)
df$month <- as.numeric(df$month)

df <- data.frame(df)
windows(width = 10, height = 7) 

df_gif <- df %>%
  filter(signs_of_mental_illness == TRUE) %>%
  group_by(year, month, threat_level) %>%
  summarize(count = n(), .groups = "drop")

df_gif$date <- as.Date(paste(df_gif$year, df_gif$month, "01", sep = "-"), format = "%Y-%m-%d")

ggplot(df_gif, aes(x = date, y = count, group = threat_level, colour = factor(threat_level))) +
  geom_line() +
  labs(x = "Year-Month", y = "Count of Mental Health Issues") +
  theme(legend.position = "top") +
  transition_reveal(date)