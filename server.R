# server file

library(shiny)
library(ggplot2)
library(scales)
library(reshape2)

solveVAsset <- function(t, A = 0, C = 10000, r = 0.05) {
        if(r == 0) {
                return(A + C*t)
        } else{
                return(A*(1+r)^t + C * ((1 + r)^t - 1)/r)   
        }
}

shinyServer(
        function(input, output) {
                output$plot <- renderPlot({

                        year <- 0:input$years
                        minAge <- min(input$age1, input$age2)
                        age <- minAge + year
                        finalage <- minAge + input$years
                        xlabels <- if(input$years > 20) {
                                seq(minAge, finalage, 2)
                        } else {
                                age
                        }
                        
                        offset1 <- input$age1 - minAge
                        offset2 <- input$age2 - minAge
                        assetValue1 <- sapply(year - offset1, solveVAsset, 
                                              A = input$initAmt1, C = input$savings1, r = input$rate1/100)
                        if(offset1 > 0) {assetValue1[0:offset1] <- NA}
                        assetValue2 <- sapply(year - offset2, solveVAsset, 
                                              A = input$initAmt2, C = input$savings2, r = input$rate2/100)
                        if(offset2 > 0) {assetValue2[0:offset2] <- NA}
                        
                        df <- data.frame(age, assetValue1, assetValue2)
                        df <- melt(df, id = "age", variable.name = "Scenario")
                        levels(df$Scenario) <- c("One", "Two")
                        ggplot(df, aes(age, value, color = Scenario)) +
                                geom_line(size = 1) +
                                geom_hline(yintercept = 0) +
                                ylab("Dollars") +
                                xlab("Age") +
                                scale_x_continuous(breaks = xlabels) +
                                scale_y_continuous(labels = dollar)
                })
                
                output$results1 <- renderText({
                        minAge <- min(input$age1, input$age2)
                        offset <- input$age1 - minAge
                        V <- solveVAsset(t = input$years - offset, A = input$initAmt1, 
                                         C = input$savings1, r = input$rate1/100)
                        V <- dollar(V)
                        startAge <- as.character(input$age1)
                        initAmt <- dollar(input$initAmt1)
                        rate <- as.character(input$rate1)
                        savings <- dollar(input$savings1)
                        years <- as.character(input$years)
                        finalAge <- as.character(minAge + input$years)
                        paste("Starting at age ", 
                              startAge, 
                              " with an initial amount of ", 
                              initAmt, 
                              ", an interest rate of ", 
                              rate, 
                              " percent, and yearly savings of ", 
                              savings, 
                              ", you will have ", 
                              V, 
                              " at age ", 
                              finalAge, 
                              ".", 
                              sep = "")
                })
                
                output$results2 <- renderText({
                        minAge <- min(input$age1, input$age2)
                        offset <- input$age2 - minAge
                        V <- solveVAsset(t = input$years - offset, A = input$initAmt2, 
                                         C = input$savings2, r = input$rate2/100)
                        V <- dollar(V)
                        startAge <- as.character(input$age2)
                        initAmt <- dollar(input$initAmt2)
                        rate <- as.character(input$rate2)
                        savings <- dollar(input$savings2)
                        years <- as.character(input$years)
                        finalAge <- as.character(minAge + input$years)
                        paste("Starting at age ", 
                              startAge, 
                              " with an initial amount of ", 
                              initAmt, 
                              ", an interest rate of ", 
                              rate, 
                              " percent, and yearly savings of ", 
                              savings, 
                              ", you will have ", 
                              V, 
                              " at age ", 
                              finalAge, 
                              ".", 
                              sep = "")
                })
                
        
        }
)