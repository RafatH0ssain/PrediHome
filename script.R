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


# Cleaning housing_df dataset
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


# Cleaning employment_df dataset
employment_df <- employment_df %>% filter(Age.group=="15 years and over") %>%
                select(REF_DATE, Province=GEO, Employment.rate, Unemployment.rate) %>%
                group_by(year = substr(REF_DATE, 1, 4), Province) %>% summarize(
                  Employment.rate = mean(Employment.rate, na.rm = TRUE),
                  Unemployment.rate = mean(Unemployment.rate, na.rm = TRUE)
                )  %>% ungroup() %>%  filter(year >= 1986) %>% filter(Province != 'Canada') %>%
                pivot_wider(names_from = "Province", values_from = c("Employment.rate", "Unemployment.rate"))


# Joining the two datasets
employment_df$year <- as.numeric(employment_df$year) #changed employment_db year's type to integer from character
merged_df <- inner_join(housing_df, employment_df, by = "year")

# Train a regression model to predict HPI and Unemployment rate for each province (years 2023-2035)

# Newfoundland and Labrador
hpi_model_NaL <- lm(Newfoundland.and.Labrador.HPI ~ year, data = housing_df)
unemployment_model_NaL <- lm(`Employment.rate_Newfoundland and Labrador` ~ year, data = employment_df)
future_years_NaL <- data.frame(year = 2023:2035)
future_hpi_NaL <- predict(hpi_model_NaL, newdata = future_years_NaL)
future_unemployment_NaL <- predict(unemployment_model_NaL, newdata = future_years_NaL)

# Alberta
hpi_model_A <- lm(Alberta.HPI ~ year, data = housing_df)
unemployment_model_A <- lm(`Employment.rate_Alberta` ~ year, data = employment_df)
future_years_A <- data.frame(year = 2023:2035)
future_hpi_A <- predict(hpi_model_A, newdata = future_years_A)
future_unemployment_A <- predict(unemployment_model_A, newdata = future_years_A)

# British Columbia
hpi_model_BC <- lm(British.Columbia.HPI ~ year, data = housing_df)
unemployment_model_BC <- lm(`Employment.rate_British Columbia` ~ year, data = employment_df)
future_years_BC <- data.frame(year = 2023:2035)
future_hpi_BC <- predict(hpi_model_BC, newdata = future_years_BC)
future_unemployment_BC <- predict(unemployment_model_BC, newdata = future_years_BC)

# Manitoba
hpi_model_M <- lm(Manitoba.HPI ~ year, data = housing_df)
unemployment_model_M <- lm(`Employment.rate_Manitoba` ~ year, data = employment_df)
future_years_M <- data.frame(year = 2023:2035)
future_hpi_M <- predict(hpi_model_M, newdata = future_years_M)
future_unemployment_M <- predict(unemployment_model_M, newdata = future_years_M)

# New Brunswick
hpi_model_NB <- lm(New.Brunswick.HPI ~ year, data = housing_df)
unemployment_model_NB <- lm(`Employment.rate_New Brunswick` ~ year, data = employment_df)
future_years_NB <- data.frame(year = 2023:2035)
future_hpi_NB <- predict(hpi_model_NB, newdata = future_years_NB)
future_unemployment_NB <- predict(unemployment_model_NB, newdata = future_years_NB)

# Nova Scotia
hpi_model_NS <- lm(Nova.Scotia.HPI ~ year, data = housing_df)
unemployment_model_NS <- lm(`Employment.rate_Nova Scotia` ~ year, data = employment_df)
future_years_NS <- data.frame(year = 2023:2035)
future_hpi_NS <- predict(hpi_model_NS, newdata = future_years_NS)
future_unemployment_NS <- predict(unemployment_model_NS, newdata = future_years_NS)

# Ontario
hpi_model_O <- lm(Ontario.HPI ~ year, data = housing_df)
unemployment_model_O <- lm(`Employment.rate_Ontario` ~ year, data = employment_df)
future_years_O <- data.frame(year = 2023:2035)
future_hpi_O <- predict(hpi_model_O, newdata = future_years_O)
future_unemployment_O <- predict(unemployment_model_O, newdata = future_years_O)

# Prince Edward Island
hpi_model_PEI <- lm(Prince.Edward.Island.HPI ~ year, data = housing_df)
unemployment_model_PEI <- lm(`Employment.rate_Prince Edward Island` ~ year, data = employment_df)
future_years_PEI <- data.frame(year = 2023:2035)
future_hpi_PEI <- predict(hpi_model_PEI, newdata = future_years_PEI)
future_unemployment_PEI <- predict(unemployment_model_PEI, newdata = future_years_PEI)

# Quebec
hpi_model_Q <- lm(Quebec.HPI ~ year, data = housing_df)
unemployment_model_Q <- lm(`Employment.rate_Quebec` ~ year, data = employment_df)
future_years_Q <- data.frame(year = 2023:2035)
future_hpi_Q <- predict(hpi_model_Q, newdata = future_years_Q)
future_unemployment_Q <- predict(unemployment_model_Q, newdata = future_years_Q)

# Saskatchewan
hpi_model_S <- lm(Saskatchewan.HPI ~ year, data = housing_df)
unemployment_model_S <- lm(`Employment.rate_Saskatchewan` ~ year, data = employment_df)
future_years_S <- data.frame(year = 2023:2035)
future_hpi_S <- predict(hpi_model_S, newdata = future_years_S)
future_unemployment_S <- predict(unemployment_model_S, newdata = future_years_S)


# Final dataframe with all predictions
future_predictions <- data.frame(
  year = 2023:2035,
  Newfoundland.and.Labrador.HPI = future_hpi_NaL,
  `Unemployment.rate_Newfoundland and Labrador` = future_unemployment_NaL,
  Alberta.HPI = future_hpi_A,
  `Unemployment.rate_Alberta` = future_unemployment_A,
  British.Columbia.HPI = future_hpi_BC,
  `Unemployment.rate_British` = future_unemployment_BC,
  Manitoba.HPI = future_hpi_M,
  `Unemployment.rate_Manitoba` = future_unemployment_M,
  New.Brunswick.HPI = future_hpi_NB,
  `Unemployment.rate_New Brunswick` = future_unemployment_NB,
  Nova.Scotia.HPI = future_hpi_NS,
  `Unemployment.rate_Nova Scotia` = future_unemployment_NS,
  Ontario.HPI = future_hpi_O,
  `Unemployment.rate_Ontario` = future_unemployment_O,
  Prince.Edward.Island.HPI = future_hpi_PEI,
  `Unemployment.rate_Prince Edward Island` = future_unemployment_PEI,
  Quebec.HPI = future_hpi_Q,
  `Unemployment.rate_Quebec` = future_unemployment_Q,
  Saskatchewan.HPI = future_hpi_S,
  `Unemployment.rate_Saskatchewan`= future_unemployment_S
)


# Create a function to calculate the composite score for each province
calculate_score <- function(hpi, unemployment_rate, employment_rate, hpi_weight = 0.4, unem_rate_weight = 0.3, emp_rate_weight = 0.3) {
  # Inverse HPI and Unemployment rate for the score, as lower values are better
  score <- (hpi_weight * (1 / hpi)) + (unem_rate_weight * (1 / unemployment_rate)) + (emp_rate_weight * employment_rate)
  return(score)
}


# Handle user input
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
    output$data <- renderText({
      paste(colnames(data))
    })
    
    #CHATGPT
    # Calculate the composite score for each province
    provinces <- colnames(data)
    provinces_hpi <- grep("HPI", provinces, value = TRUE)
    provinces_unemployment <- grep("Unemployment.rate", provinces, value = TRUE)
    provinces_employment <- grep("Employment.rate", provinces, value = TRUE)
    
    scores <- sapply(provinces_hpi, function(province) {
      hpi <- as.numeric(data[[province]])
      
      # Extract the province name by removing the "HPI" suffix
      province_name <- sub("\\.HPI$", "", province)
      
      # Construct the correct column names for unemployment and employment rates
      unemployment_rate <- as.numeric(data[[paste0("Unemployment.rate_", province_name)]])
      employment_rate <- as.numeric(data[[paste0("Employment.rate_", province_name)]])
      
      # Calculate score for each province
      calculate_score(hpi, unemployment_rate, employment_rate)
    })
    
    
    # Find the province with the highest score
    best_province <- names(scores)[which.max(scores)]
    
    output$best_province <- renderText({
      paste("The best province to live in for", input$year, "is", best_province)
    })
    #END
    
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
        scale_fill_gradient(low = "white", high = "black", name = "Unemployment.rate") +
        coord_flip()
    })
  })
}


# Show output in UI
ui <- fluidPage(
  titlePanel("PrediHome: Province Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      # Input: Select Year
      numericInput("year", "Select Year:", value = 2000, min = 1986, max = 2022),
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      textOutput("data"),
      
      h3("Best Province"),
      textOutput("best_province"),
      
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