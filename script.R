# PrediHome

library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(shiny)

# Load datasets
housing_df <- read.csv("HPI 1981-2022 by regions.csv")
employment_df <- read.csv("Unemployment_Canada_1976_present.csv")

# Inspect the datasets
#View(employment_df)
#View(housing_df)

#Cleaning housing_df dataset
housing_df <- housing_df %>% filter(Type == "House and Land") %>% 
              select(year, Newfoundland.and.Labrador, Prince.Edward.Island,
                     Nova.Scotia, New.Brunswick, Quebec, Ontario, Manitoba,
                     Saskatchewan, Alberta, British.Columbia) %>% 
              group_by(year) %>% summarize(
                Newfoundland.and.Labrador.HPI = mean(Newfoundland.and.Labrador, na.rm = TRUE),
                Prince.Edward.Island.HPI = mean(Prince.Edward.Island, na.rm = TRUE),
                Nova.Scotia.HPI = mean(Nova.Scotia, na.rm = TRUE),
                New.Brunswick.HPI= mean(New.Brunswick, na.rm = TRUE),
                Quebec.HPI = mean(Quebec, na.rm = TRUE),
                Ontario.HPI = mean(Ontario, na.rm = TRUE),
                Manitoba.HPI = mean(Manitoba, na.rm = TRUE),
                Saskatchewan.HPI = mean(Saskatchewan, na.rm = TRUE),
                Alberta.HPI = mean(Alberta, na.rm = TRUE),
                British.Columbia.HPI = mean(British.Columbia, na.rm = TRUE)
              ) %>% ungroup() %>%  filter(year >= 1986)

#Cleaning employment_df dataset
employment_df <- employment_df %>% filter(Age.group=="15 years and over") %>%
                select(REF_DATE, Province=GEO, Employment.rate, Unemployment.rate) %>%
                group_by(year = substr(REF_DATE, 1, 4), Province) %>% summarize(
                  Employment.rate = mean(Employment.rate, na.rm = TRUE),
                  Unemployment.rate = mean(Unemployment.rate, na.rm = TRUE)
                )  %>% ungroup() %>%  filter(year >= 1986) %>% filter(Province != 'Canada') %>%
                pivot_wider(names_from = "Province", values_from = c("Employment.rate", "Unemployment.rate"))

#Joining the two datasets
employment_df$year <- as.numeric(employment_df$year) #changed employment_db year's type to integer from character
merged_df <- inner_join(housing_df, employment_df, by = "year")

# Train a regression model to predict HPI and Unemployment rate for each province (years 2023-2035)
# Newfoundland and Labrador
hpi_model <- lm(Newfoundland.and.Labrador.HPI ~ year, data = housing_df)
unemployment_model <- lm(`Employment.rate_Newfoundland and Labrador` ~ year, data = employment_df)
future_years <- data.frame(year = 2023:2035)
future_hpi <- predict(hpi_model, newdata = future_years)
future_unemployment <- predict(unemployment_model, newdata = future_years)

#Final dataframe with all predictions
future_predictions <- data.frame(
  year = 2023:2035,
  Newfoundland.and.Labrador.HPI = future_hpi,
  `Unemployment.rate_Newfoundland and Labrador` = future_unemployment
)

server <- function(input, output) {
  
  # Reactive expression to filter data for selected year
  filtered_data <- reactive({
    # If the selected year is in the current data, use the existing data
    if (input$year <= 2022) {
      year_data <- merged_df %>% filter(year == input$year)
    } else {
      # Otherwise, use predicted data for future years
      year_data <- future_predictions %>% filter(year == input$year)
    }
    return(year_data)
  })
  
  observeEvent(input$submit, {
    # Get the filtered data for the selected year
    data <- filtered_data()
    View(data)
    
    # Find the province with the lowest HPI
    input_hpi_df <- data %>% 
      select(ends_with("HPI")) %>%
      summarise_all(min, na.rm = TRUE) %>%
      pivot_longer(cols = everything(), names_to = "Province", values_to = "HPI")
    
    lowest_hpi <- input_hpi_df %>%
      arrange(HPI) %>%
      slice(1)
    
    output$lowest_hpi_province <- renderText({
      paste("The province with the lowest HPI in", input$year, "is", lowest_hpi$Province)
    })
    
    # Plot the HPI bar chart
    output$hpi_barplot <- renderPlot({
      ggplot(input_hpi_df, aes(x = Province)) + 
        geom_bar(aes(y = HPI, fill = HPI), stat = "identity") + 
        labs(title = "HPI by Province", x = "Province", y = "HPI") +
        scale_fill_gradient(low = "white", high = "black", name = "HPI")
    })
    
    
    # Find the province with the lowest Unemployment rate
    input_unemployment_df <- data %>% 
      select(starts_with("Unemployment.rate")) %>%
      summarise_all(min, na.rm = TRUE) %>%
      pivot_longer(cols = everything(), names_to = "Province", values_to = "Unemployment.rate")
    
    lowest_unemployment <- input_unemployment_df %>%
      arrange(Unemployment.rate) %>%
      slice(1)
    
    output$lowest_unemployment_province <- renderText({
      paste("The province with the lowest Unemployment rate in", input$year, "is", lowest_unemployment$Province)
    })
    
    # Plot the Unemployment rate bar chart
    output$unemployment_barplot <- renderPlot({
      ggplot(input_unemployment_df, aes(x = Province)) + 
        geom_bar(aes(y = Unemployment.rate, fill = Unemployment.rate), stat = "identity") + 
        labs(title = "Unemployment rate by Province", x = "Province", y = "Unemployment rate") +
        scale_fill_gradient(low = "white", high = "black", name = "Unemployment.rate")
    })
  })
}


ui <- fluidPage(
  titlePanel("PrediHome: Province Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      # Input: Select Year
      numericInput("year", "Select Year:", value = 2000, min = 1986, max = 2022),
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      h3("Province with Lowest HPI"),
      textOutput("lowest_hpi_province"),
      plotOutput("hpi_barplot"),
      
      h3("Province with Lowest Unemployment Rate"),
      textOutput("lowest_unemployment_province"),
      plotOutput("unemployment_barplot")
    )
  )
)

shinyApp(ui = ui, server = server)