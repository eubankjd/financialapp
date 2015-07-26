# user interface file

library(shiny)

shinyUI(fluidPage(
        title = "Compare Financial Scenarios",
        h1("Financial Scenario Comparison Tool", align = "center"),
        plotOutput("plot"),
        
        p("Enter parameters below to compare two financial scenarios.", align = "center",
          style = "font-size:20px"),
        
        fluidRow(
                column(width = 4,
                       h3('Scenario One'),
                       numericInput("initAmt1", "Initial amount ($)", -100000),
                       sliderInput("rate1", "Interest rate (%)", min = 0, max = 20, value = 7.5, step = 0.25),
                       numericInput("savings1", "Annual savings ($)", 25000, min = 0, step = 1000),
                       numericInput("age1", "Start age", 30, min = 0)
                ),
                column(width = 4,
                       h3("Scenario Two"),
                       numericInput("initAmt2", "Initial amount ($)", 5500),
                       sliderInput("rate2", "Interest rate (%)", min = 0, max = 20, value = 7.5, step = 0.25),
                       numericInput("savings2", "Annual savings ($)", 5500, min = 0, step = 1000),
                       numericInput("age2", "Start age", 25, min = 1),
                       numericInput("years", "Number of years from minimum start age", 20, min = 0, max = 100)
                ),
                column(width = 4,
                       h3("Results"),
                       h4("Scenario One"),
                       textOutput("results1"),
                       h4("Scenario Two"),
                       textOutput("results2")
                )       
        ),
        fluidRow(
                column(width = 12,
                       align = "center",
                       submitButton("Submit"),
                       br(),
                       h4("Details"),
                       p("Initial amounts can be negative to represent debt. Debts (negative amounts) and assets 
                        (positive amounts) are assumed to have the same interest rate. Interest compounds annually. When the 
                         amount is negative, annual savings are applied as debt payments. Payments are first applied to 
                         interest, then to the principal. The interest rate is the real interest rate; i.e., the interest rate 
                         after inflation is accounted for.")
                )
        )
        
        
))
