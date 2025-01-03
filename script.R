# PrediHome

library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)

# Load datasets
housing_df <- read.csv("D:/projects/PrediHome/HPI 1981-2022 by regions.csv")
employment_df <- read.csv("D:/projects/PrediHome/Unemployment_Canada_1976_present.csv")

# Inspect the datasets
#View(employment_df)
#View(housing_df)

#Cleaning housing_df dataset
housing_df <- housing_df %>% filter(Type == "House and Land") %>% 
              select(year, Newfoundland.and.Labrador, Prince.Edward.Island,
                     Nova.Scotia, New.Brunswick, Quebec, Ontario, Manitoba,
                     Saskatchewan, Alberta, British.Columbia) %>% 
              group_by(year) %>% summarize(
                Newfoundland.and.Labrador = mean(Newfoundland.and.Labrador, na.rm = TRUE),
                Prince.Edward.Island = mean(Prince.Edward.Island, na.rm = TRUE),
                Nova.Scotia = mean(Nova.Scotia, na.rm = TRUE),
                New.Brunswick= mean(New.Brunswick, na.rm = TRUE),
                Quebec = mean(Quebec, na.rm = TRUE),
                Ontario = mean(Ontario, na.rm = TRUE),
                Manitoba = mean(Manitoba, na.rm = TRUE),
                Saskatchewan = mean(Saskatchewan, na.rm = TRUE),
                Alberta = mean(Alberta, na.rm = TRUE),
                British.Columbia = mean(British.Columbia, na.rm = TRUE)
              ) %>% ungroup() %>%  filter(year >= 1986)


View(housing_df)