# PrediHome: Housing Price Index and Employment Rate Analytics

**PrediHome** is an interactive web app built using **R** and **Shiny**, designed to help users make informed decisions about the best province to live in Canada. The app provides detailed analytics on **housing price data (HPI)**, **unemployment rate**, and **employment rate** data for the years **1986-2035**. Users can input a specific year and receive insights and predictions about the HPI and employment metrics across different provinces.

## Objective

The primary goal of **PrediHome** is to help users evaluate potential provinces to live in based on key economic and housing indicators. Users can:
- Explore **historical data (1986-2022)** and **predicted data (2023-2035)**.
- View the province with the **lowest Housing Price Index (HPI)** and the province with the **lowest unemployment rate**.
- **Visualize** HPI and employment statistics for different provinces, assisting in comparing various factors that impact the cost of living.

## Features

1. **User Input**:
   - Users select a year between **1986** and **2035** to analyze housing prices and employment statistics.
   
2. **Data Analysis**:
   - The app identifies the **lowest HPI** province and **lowest unemployment rate** province using both historical data and predictive models (for the years 2023-2035).
   
3. **Visualizations**:
   - **Bar Chart**: Displays the **HPI** values for each province in the selected year.
   - **Bar Chart**: Shows the **unemployment rate** for each province in the selected year.

4. **Regression Model Predictions (for years 2023-2035)**:
   - Uses linear regression models to predict future **HPI** and **unemployment rates** based on historical data.
   
5. **Identifies the best province to live in**:
- Calculates a composite score for each province, where a higher score indicates a better province to live in. This is done based on the following metrics:
  - Housing Price Index (HPI)
  - Unemployment Rate
  - Employment Rate

## Datasets

The analysis is based on the following datasets from Kaggle:

1. [**Canada housing price data by regions 1981-2022**](https://www.kaggle.com/datasets/anki112279/canada-housing-price-data-by-regions-19812022): Contains data on the housing price index for each province in Canada between 1981 and 2022.
2. [**Unemployment in Canada, by Province (1976-Present)**](https://www.kaggle.com/datasets/pienik/unemployment-in-canada-by-province-1976-present): Includes employment and unemployment rates for each province between 1976 and 2022.

## Steps Involved

### 1. **Data Preprocessing**:
   - Cleaned and prepared the datasets by removing unnecessary columns and aggregating data at the **province** level for comparison.

### 2. **Data Analysis**:
   - **Historical Data (1986-2022)**: Analyzed trends in **HPI** and **unemployment rates** across provinces.
   - **Prediction for Future Years (2023-2035)**: Applied regression models to predict future values of **HPI** and **unemployment rates**.

### 3. **Data Visualization**:
   The following visualizations help users understand and compare housing and employment metrics across provinces:

#### 1. **Bar Chart**: Housing Price Index (HPI) by Province
   - A bar chart showing **HPI** values for each province in the selected year.
   - Helps users visually compare housing prices and identify affordable or expensive provinces for that year.

   ![Bar Chart: Housing Price Index](plot-examples/lowest_hpi_2027.png)

#### 2. **Bar Chart**: Unemployment Rates by Province
   - A bar chart displaying the **unemployment rate** for each province in the selected year.
   - Helps users analyze the economic climate in different provinces and make informed decisions about employment opportunities.

   ![Bar Chart: Unemployment Rates](plot-examples/lowest_unemployment_rate_2027.png)

## User Interface

**PrediHome** features a modern, easy-to-navigate user interface that includes:

- **Numeric Input**: Users can select a year between **1986** and **2035**.
- **Submit Button**: After selecting the year, users can click the submit button to receive:
  - The overall **best province** to live in.
  - The province with the **lowest HPI**.
  - The province with the **lowest unemployment rate**.
  - **Visualizations**: A bar chart showing the HPI values of all provinces and one showing unemployment rates for all provinces.

## Tools Used

- **R**: For data cleaning, manipulation, and analysis.
- **Shiny**: For building the interactive web application.
- **ggplot2**: For creating visualizations like bar charts.
- **dplyr**: For data manipulation and aggregation.
- **tidyr**: For tidying and reshaping the data.
- **lm()**: For building regression models to predict future data.

## How to Run the App in RStudio

1. Install the necessary R packages:
   ```r
   install.packages(c("shiny", "ggplot2", "dplyr", "tidyr"))

2. Clone or download the repository.
3. Open the R script and run the app.
4. Enter a year (1986-2035) to view the analysis and predictions.
- **Note**: If you see an error that says "*cannot open file '<filename>': No such file or directory*", run `setwd("<path_to_working_directory>")` in your terminal, replacing <path_to_working_directory> with the path to the directory containing the files you cloned.
