###############
# Sasori Sgathan: Azurite
# Variation Intent: Regression Analysis of Cancer Incidence & Mortality Data
###############

# Load required libraries
library(readxl)
library(tidyr)
library(dplyr)
library(ggplot2)
library(shiny)
library(car)

# Set working directory and import data. Path noted below is an example. Put the path to your data between the "".
# When copying a path for setwd, remember to replace '\' with '/'. Otherwise you will throw an error.
setwd("/Users/johnqsmith/Documents/R")
cancer_rates <- read.csv("Combo-Invasive-Cancer-Rates-and-Cancer-Mortality-per-County-in-CA-All-Sites_2011-2015-v3.csv")

##########
# Multiple Regression
##########

# One: Import data and libraries (after running code above)
mydat <- cancer_rates

# Two: Define User Interface
ui <- fluidPage(
  
  # Application title
  titlePanel("Sasori Sgathan (Azurite)"),
             h3("California Cancer Incidence & Mortality Rates, 2011-2015: Multiple Linear Regression"),
  
  # Sidebar with input options
  sidebarLayout(
    sidebarPanel(
      
      # Choose independent variables for analysis
      selectInput("indepVar",                            # Name of input
                  "REQUIRED: Independent Variables",   # Display Label
                  multiple = TRUE,
                  choices = list("Incidence_Cases","Incidence_Crude Rate","Incidence_Age-adjusted_Rate","Incidence_95per_Confidence_Interval-Lower_Limit","Incidence_95per_Confidence_Interval-Upper_Limit",
                                 "Mortality_Deaths","Mortality_Crude_Rate","Mortality_Age-adjusted_Rate","Mortality_95per_Confidence_Interval-Lower_Limit","Mortality_95per_Confidence_Interval-Upper_Limit")),   # Specify choices

      # Choose dependent variable for analysis
      selectInput("depVar",                                # Name of input
                  "Select Dependent Variable",             # Display Label
                  multiple = FALSE,
                  choices = list("Incidence_Population_at_Risk","Mortality_Population_at_Risk")),   # Specify choices
      
      # Select Region from Dropdown Menu
      selectInput("region",                           # Name of input
                  "Select Region",                    # Display Label
                  choices = c("All" = "all",          # Available choices in the dropdown
                              "State" = "STATE",
                              "North" = "North",
							                "Bay Area" = "Bay Area",
							                "Sacramento" = "Sacramento",
							                "Santa Clara" = "Santa Clara",
							                "Central" = "Central",
							                "Desert Sierra" = "Desert Sierra",
							                "Tri-County" = "Tri-County",
							                "Los Angeles County" = "Los Angeles County",
							                "Orange County" = "Orange County",
							                "San Diego" = "San Diego")),
      
      
	  # Filter Input for Incidence Range
      sliderInput("incidenceInput",                # Name of input
                  "Incidence Range",               # Display Label
                  min = 500,                       # Lowest Value of Range
                  max = 1000000,                   # Highest Value of Range
                  value = c(500, 1000000),         # Pre-selected values
                  step = 500),                      # Size per step change

      # Filter Input for Mortality Range
      sliderInput("mortalityInput",                # Name of input
                  "Mortality Range",               # Display Label
                  min = 100,                       # Lowest Value of Range
                  max = 300000,                    # Highest Value of Range
                  value = c(100, 300000),          # Pre-selected values
                  step = 250),                      # Size per step change

      # Filter Input for Population at Risk Range
      sliderInput("populationInput",               # Name of input
                  "Population Range",              # Display Label
                  min = 150000,                    # Lowest Value of Range
                  max = 193000000,                 # Highest Value of Range
                  value = c(250000, 193000000),    # Pre-selected values
                  step = 150000)                   # Size per step change

    ),
    
    # Items to show in the Main Panel
    mainPanel(
      
      tabsetPanel(type = "tabs",

                 tabPanel("Scatterplot Matrix", plotOutput("scatterplot")),       # Scatter plot matrix
                 tabPanel("Model Summary", verbatimTextOutput("summary")),        # Regression output
                 tabPanel("Model Diagnostics", plotOutput("diagnostic"))  # Regression diagnostic plots
      )
    )
  )
)

# Three: Define server logic required to make model and plot matrix
server <- function(input, output) {
  
    # TAB 1: Scatterplot Matrix  
    output$scatterplot <- renderPlot({
    
    # Filter data based on user input (incidence/mortality/populationatrisk)
    filtered <- mydat %>%
      filter(Incidence_Cases >= input$incidenceInput[1],
			 Incidence_Cases <= input$incidenceInput[2],
			 Mortality_Deaths >= input$mortalityInput[1],
			 Mortality_Deaths <= input$mortalityInput[2],
			 Population >= input$populationInput[1],
			 Population <= input$populationInput[2]
      )
    
    # Filter data based on region
    ## All regions
    if (input$region == "All") {
      filtered <- filtered
    }
	## State Only
    else if (input$region == "STATE") {
      filtered <- filtered[filtered$Region== 'STATE',]
    }
	## North Only
    else if (input$region == "North") {
      filtered <- filtered[filtered$Region== 'North',]
    }
	## Bay Area Only
    else if (input$region == "Bay Area") {
      filtered <- filtered[filtered$Region== 'Bay Area',]
    }
	## Sacramento Only
    else if (input$region == "Sacramento") {
      filtered <- filtered[filtered$Region== 'Sacramento',]
    }
	## Santa Clara Only
    else if (input$region == "Santa Clara") {
      filtered <- filtered[filtered$Region== 'Santa Clara',]
    }
	## Central Only
    else if (input$region == "Central") {
      filtered <- filtered[filtered$Region== 'Central',]
    }
	## Desert Sierra Only
    else if (input$region == "Desert Sierra") {
      filtered <- filtered[filtered$Region== 'Desert Sierra',]
    }
	## Tri-County Only
    else if (input$region == "Tri-County") {
      filtered <- filtered[filtered$Region== 'Tri-County',]
    }
	## Los Angeles County Only
    else if (input$region == "Los Angeles County") {
      filtered <- filtered[filtered$Region== 'Los Angeles County',]
    }
	## Orange County Only
    else if (input$region == "Orange County") {
      filtered <- filtered[filtered$Region== 'Orange County',]
    }
	## San Diego Only
    else if (input$region == "San Diego") {
      filtered <- filtered[filtered$Region== 'San Diego',]
    }
    
    #Set up scatterplot matrix
      # Correlation panel
    panel.cor <- function(x, y){
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(0, 1, 0, 1))
      r <- round(cor(x, y), digits=2)
      txt <- paste0("R = ", r)
      cex.cor <- 0.8/strwidth(txt)
      text(0.5, 0.5, txt, cex = cex.cor * r)
    }
      # Customize upper panel
    upper.panel<-function(x, y){
      points(x,y, pch = 19)
    }
      # Histogram panel
    panel.hist <- function(x)
    {
      usr <- par("usr"); on.exit(par(usr))
      par(usr = c(usr[1:2], 0, 1.5) )
      h <- hist(x, plot = FALSE)
      breaks <- h$breaks; nB <- length(breaks)
      y <- h$counts; y <- y/max(y)
      rect(breaks[-nB], 0, breaks[-1], y, col = "cyan")
    }
    # Create the plots
    pairs(filtered[,c(input$depVar,input$indepVar)],
          lower.panel = panel.cor,
          upper.panel = upper.panel,
          diag.panel = panel.hist)
  }, height=800)
  
  # TAB 2: Regression output
  output$summary <- renderPrint({
    
    # Filter data based on user input (rank/salary)
    filtered <- mydat %>%
      filter(Incidence_Cases >= input$incidenceInput[1],
			 Incidence_Cases <= input$incidenceInput[2],
			 Mortality_Deaths >= input$mortalityInput[1],
			 Mortality_Deaths <= input$mortalityInput[2],
			 Population >= input$populationInput[1],
			 Population <= input$populationInput[2]
      )
    
    # Filter data based on region
    ## All regions
    if (input$region == "All") {
      filtered <- filtered
    }
	## State Only
    else if (input$region == "STATE") {
      filtered <- filtered[filtered$Region== 'STATE',]
    }
	## North Only
    else if (input$region == "North") {
      filtered <- filtered[filtered$Region== 'North',]
    }
	## Bay Area Only
    else if (input$region == "Bay Area") {
      filtered <- filtered[filtered$Region== 'Bay Area',]
    }
	## Sacramento Only
    else if (input$region == "Sacramento") {
      filtered <- filtered[filtered$Region== 'Sacramento',]
    }
	## Santa Clara Only
    else if (input$region == "Santa Clara") {
      filtered <- filtered[filtered$Region== 'Santa Clara',]
    }
	## Central Only
    else if (input$region == "Central") {
      filtered <- filtered[filtered$Region== 'Central',]
    }
	## Desert Sierra Only
    else if (input$region == "Desert Sierra") {
      filtered <- filtered[filtered$Region== 'Desert Sierra',]
    }
	## Tri-County Only
    else if (input$region == "Tri-County") {
      filtered <- filtered[filtered$Region== 'Tri-County',]
    }
	## Los Angeles County Only
    else if (input$region == "Los Angeles County") {
      filtered <- filtered[filtered$Region== 'Los Angeles County',]
    }
	## Orange County Only
    else if (input$region == "Orange County") {
      filtered <- filtered[filtered$Region== 'Orange County',]
    }
	## San Diego Only
    else if (input$region == "San Diego") {
      filtered <- filtered[filtered$Region== 'San Diego',]
    }
    
    # Set up multiple linear regression model
    factors <- paste(c(colnames(filtered[,input$indepVar])), collapse = "+")
    outcome <- paste(input$depVar)
    
    print(paste("Number of Independent Variables: ",length(input$indepVar)))
    
    if (length(input$indepVar) == 1){
      form <- filtered[,input$depVar] ~ filtered[,input$indepVar]
      fit <- lm(form)
      names(fit$coefficients) <- c("Intercept", input$indepVar)
    }

    else if (length(input$indepVar) > 1){
      form <- paste(outcome,"~", factors)
      print(paste("Model: ",form))
      fit <- lm(form, data = filtered)
    }
    
    summary(fit)
  })
    
    # TAB 3: Regression diagnostic plots
    output$diagnostic <- renderPlot({

      # Filter data based on user input (rank/salary)
      filtered <- mydat %>%
        filter(Incidence_Cases >= input$incidenceInput[1],
			   Incidence_Cases <= input$incidenceInput[2],
			   Mortality_Deaths >= input$mortalityInput[1],
			   Mortality_Deaths <= input$mortalityInput[2],
			   Population >= input$populationInput[1],
			   Population <= input$populationInput[2]
        )

    # Filter data based on region
    ## All regions
    if (input$region == "All") {
      filtered <- filtered
    }
	## State Only
    else if (input$region == "STATE") {
      filtered <- filtered[filtered$Region== 'STATE',]
    }
	## North Only
    else if (input$region == "North") {
      filtered <- filtered[filtered$Region== 'North',]
    }
	## Bay Area Only
    else if (input$region == "Bay Area") {
      filtered <- filtered[filtered$Region== 'Bay Area',]
    }
	## Sacramento Only
    else if (input$region == "Sacramento") {
      filtered <- filtered[filtered$Region== 'Sacramento',]
    }
	## Santa Clara Only
    else if (input$region == "Santa Clara") {
      filtered <- filtered[filtered$Region== 'Santa Clara',]
    }
	## Central Only
    else if (input$region == "Central") {
      filtered <- filtered[filtered$Region== 'Central',]
    }
	## Desert Sierra Only
    else if (input$region == "Desert Sierra") {
      filtered <- filtered[filtered$Region== 'Desert Sierra',]
    }
	## Tri-County Only
    else if (input$region == "Tri-County") {
      filtered <- filtered[filtered$Region== 'Tri-County',]
    }
	## Los Angeles County Only
    else if (input$region == "Los Angeles County") {
      filtered <- filtered[filtered$Region== 'Los Angeles County',]
    }
	## Orange County Only
    else if (input$region == "Orange County") {
      filtered <- filtered[filtered$Region== 'Orange County',]
    }
	## San Diego Only
    else if (input$region == "San Diego") {
      filtered <- filtered[filtered$Region== 'San Diego',]
    }

      # Set up multiple linear regression model
      factors <- paste(c(colnames(filtered[,input$indepVar])), collapse = "+")
      outcome <- paste(input$depVar)

      if (length(input$indepVar) == 1){
        form <- filtered[,input$depVar] ~ filtered[,input$indepVar]
        fit <- lm(form)
        names(fit$coefficients) <- c("Intercept", input$indepVar)
      }

      else if (length(input$indepVar) > 1){
        form <- paste(outcome,"~", factors)
        fit <- lm(form, data = filtered)
      }
      
      par(mfrow=c(2,2))
      plot(fit)

  }, height=800)
    
  
}

# Four: Run the application on localhost
#shinyApp(ui = ui, server = server)

# To run the app over local network, unccomment the following:
runApp(shinyApp(ui = ui, server = server), port = 3838, host="0.0.0.0")
