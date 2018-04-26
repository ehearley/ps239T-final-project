
##################################
# 2_Data_Cleaning -- PS 239T     #
# Author: Elisabeth Earley       #
# Date: 4/25/18                  #
##################################
setwd("C:/Users/bbits/Desktop/Documentss/1 SCHOOL/1 POLITICAL SCIENCE/final_project_ps239t/Data")
library(dplyr)
library(ggmap)
library(stringr)

elite_friends <- read.csv("friends_cleaned.csv", na.strings = c("", "NA"))  #read csv file
elite_friends <- elite_friends %>% na.omit()  #remove NAs                   #turn blanks to NA
options(scipen=999) #supress scientific notation

#create list of elite names
elites <- list('Alvaro Uribe Velez', 'Sergio Fajardo',
            'Gustavo Petro', 'Ivan Duque Marquez', 
            'German Vargas Lleras', 'Juan Manuel Santos',
            'Humberto de la Calle')

#sort a list of the unique names of locations alphabetically
#We will create a dictionary that references each location's long and lat 
unq_locations <- elite_friends$location %>% as.character() %>% tolower() %>% unique() %>% sort()

#this installs the register_google(key = "my_api_key") function to fix query limit
#devtools::install_github("dkahle/ggmap")

#register an app online to use API key
google_maps_key <- "XXXXXXXXX"
register_google(key = google_maps_key)


#create locations "dictionary" *not a technical dict
locations_dict <- list()

#For each location, use Google Maps to try and get long/lat coordinates
#Store in dictionary! Wait time = 10 minutes
for (i in unq_locations) { 
  locations_dict[[i]] <- geocode(location = i) 
}

locations_dic_df <- bind_rows(locations_dict) %>% cbind(names(locations_dict)) 
write.csv(locations_dic_df, "locs_dict.csv", row.names = FALSE)


#Create an empty data.frame that we will be using in visualization
#to hold the coordinates of all unique locations
locations_df <- data.frame()
for (i in locations_dict) {
  coord_vec <- c(i[[1]], i[[2]])
  locations_df <- rbind(locations_df, coord_vec)
}



#separate the locations into dataframes for each elite! 
#Repeat this command and name each dataframe accordingly.
#This is because I want to make graphs/charts for each elite on their own.
velez_locations <- data.frame()
max_length = length(elite_friends[,1])
i <- 1
k <- 1
while (i <= max_length) {
  row <- elite_friends[i,]
  if (row[[1]] == elites[1]) {
    location <- row[[5]]
    coord <- locations_dict[location]
    coord_vec <- c(coord[[1]][[1]], coord[[1]][[2]])
    velez_locations <- rbind(velez_locations, coord_vec)
    k <- k + 1
  }
  i <- i + 1
}


#repeat: fajardo
fajardo_locations <- data.frame()
max_length = length(elite_friends[,1])
i <- 1
k <- 1
while (i <= max_length) {
  row <- elite_friends[i,]
  if (row[[1]] == elites[2]) {
    location <- row[[5]]
    coord <- locations_dict[location]
    coord_vec <- c(coord[[1]][[1]], coord[[1]][[2]])
    fajardo_locations <- rbind(fajardo_locations, coord_vec)
    k <- k + 1
  }
  i <- i + 1
}


#repeat: petro
petro_locations <- data.frame()
max_length = length(elite_friends[,1])
i <- 1
k <- 1
while (i <= max_length) {
  row <- elite_friends[i,]
  if (row[[1]] == elites[3]) {
    location <- row[[5]]
    coord <- locations_dict[location]
    coord_vec <- c(coord[[1]][[1]], coord[[1]][[2]])
    petro_locations <- rbind(petro_locations, coord_vec)
    k <- k + 1
  }
  i <- i + 1
}


#repeat: duque
duque_locations <- data.frame()
max_length = length(elite_friends[,1])
i <- 1
k <- 1
while (i <= max_length) {
  row <- elite_friends[i,]
  if (row[[1]] == elites[4]) {
    location <- row[[5]]
    coord <- locations_dict[location]
    coord_vec <- c(coord[[1]][[1]], coord[[1]][[2]])
    duque_locations <- rbind(duque_locations, coord_vec)
    k <- k + 1
  }
  i <- i + 1
}


#repeat: lleras
lleras_locations <- data.frame()
max_length = length(elite_friends[,1])
i <- 1
k <- 1
while (i <= max_length) {
  row <- elite_friends[i,]
  if (row[[1]] == elites[5]) {
    location <- row[[5]]
    coord <- locations_dict[location]
    coord_vec <- c(coord[[1]][[1]], coord[[1]][[2]])
    lleras_locations <- rbind(lleras_locations, coord_vec)
    k <- k + 1
  }
  i <- i + 1
}


#repeat: santos
santos_locations <- data.frame()
max_length = length(elite_friends[,1])
i <- 1
k <- 1
while (i <= max_length) {
  row <- elite_friends[i,]
  if (row[[1]] == elites[6]) {
    location <- row[[5]]
    coord <- locations_dict[location]
    coord_vec <- c(coord[[1]][[1]], coord[[1]][[2]])
    santos_locations <- rbind(santos_locations, coord_vec)
    k <- k + 1
  }
  i <- i + 1
}


#repeat: delaCalle
delaCalle_locations <- data.frame()
max_length = length(elite_friends[,1])
i <- 1
k <- 1
while (i <= max_length) {
  row <- elite_friends[i,]
  if (row[[1]] == elites[7]) {
    location <- row[[5]]
    coord <- locations_dict[location]
    coord_vec <- c(coord[[1]][[1]], coord[[1]][[2]])
    delaCalle_locations <- rbind(delaCalle_locations, coord_vec)
    k <- k + 1
  }
  i <- i + 1
}

#rename all column names to be consistent
colnames(velez_locations)<- c("latitude", "longitude")
colnames(fajardo_locations)<- c("latitude", "longitude")
colnames(duque_locations)<- c("latitude", "longitude")
colnames(petro_locations)<- c("latitude", "longitude")
colnames(lleras_locations)<- c("latitude", "longitude")
colnames(delaCalle_locations)<- c("latitude", "longitude")
colnames(santos_locations)<- c("latitude", "longitude")

#list of dataframes
all_dfs <- list("Alvaro Uribe Velez" = velez_locations, "Sergio Fajardo"=fajardo_locations,
                "Gustavo Petro"=petro_locations, "Ivan Duque Marquez"=duque_locations,
                "German Vargas Lleras"=lleras_locations, "Juan Manuel Santos"=santos_locations,
                "Humberto de la Calle"=delaCalle_locations)

#bind list of dataframes to have a full dataset with a new column, "elite"
#save dataframe to the disk to avoid having to use google api so often
full_locations <- bind_rows(all_dfs, .id = "elite")
write.csv(full_locations, "full_locations.csv", row.names = FALSE)
