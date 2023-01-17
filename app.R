# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#    http://shiny.rstudio.com/
#
#First open the libraries I'll need..TEST CHANGE.
library(shiny)
library(shinythemes)
library(googlesheets4)
library(dbplyr)
library(dplyr)

# This is the id for the Google Sheet I use, but you need to make it a variable
# in order to use it in the "googlesheets4" package function read_sheet(id,sheet number (which tab))
# sheet_id2<-"15i21fIxmVHKxIkvaMOrxzq_kmPQR-iah69Ui9XceFm4"
# SchIndx<-read_sheet(sheet_id2,1)
# DrmIndx<-read_sheet(sheet_id2,3)
# CondTxt<-read_sheet(sheet_id2,4)

#Here I've imported the information into a .csv file into my computer's working directory
#so it takes less time each time I run it. I needed to write it to just a 4 column .csv file
# because I was getting errors when I tried to save the whole file
# schools<-list(SchIndxC[,1])
# schoolchar<-as.character(schools)

SchIndxRead<-read.csv("SchIndxC.csv")
DrmIndxRead<-read.csv("DrmIndxC.csv")
# get the list (vectorized) of schools from the schools index
schoolslist<-SchIndxRead %>% select(.College.Lookup) %>% unlist(use.names = FALSE)
#dormslist<-DrmIndxRead%>% select(.Dorm.Name) %>% unlist(use.names=FALSE)

# Define UI
ui <- fluidPage(
  theme = shinytheme("united"),
  # Application title
  titlePanel("This will someday be SmartStudentsVote") ,
  navbarPage(title = "SmartStudentsVote: For students attending school in Wisconsin"),

#data
  # Pick your state status
  selectInput("HomeState",label="Where are you from?",list("I'm a student from Wisconsin","I'm a student from another state","I'm from Wisconsin but I'm not a student")),
  # Pick a school
  selectInput("SchoolID",label="Pick Your School",choices=schoolslist),
  # Pick a dorm
  selectInput("DormID",label="Pick Your Dorm",choices="listofdorms") ,
  #Pick a frat or sor
  selectInput("GreekHouse",label="Pick Your Greek (this should only appear for colleges with frats or sororities)",
              list("AAA","BBB","CCC")),
  #Residence
  selectInput("Residency",label="Where do you live:",
              list("In college-operated housing", "Off campus in town ('town' to be a variable)", "Off campus not in town","In a sorority or fraternity house")   ) ,
  #Voting Needs
  selectInput("VoteRegNeeds",label="I need to:",
              list("Register & Vote", "Vote") )
  ,
  # Sidebar
  sidebarLayout(
    sidebarPanel()
    ,
    mainPanel(
      textOutput("HomePicked"),
      textOutput("SchoolPicked"),
      textOutput("DormPicked"),
      textOutput("GreekPicked"),
      textOutput("ResidencyPicked"),
      textOutput("VoteRegNeedsPicked")
    )
  )
)


# Define server logic required
server <- function(input, output) {

  # snag from the Schools Index the list of dorms from the college that was selected
  #  SchDormsList<-SchIndxRead %>% filter(.College.Lookup == "MIAD") %>% pull(.DormList)

  thesedorms <- reactive({
    thesedorms() <-SchIndxRead %>% filter(.College.Lookup == "UW-Green Bay") %>% pull(.DormList)
  })
  output$HomePicked <- renderText({input$HomeState})
  output$SchoolPicked <- renderText({input$SchoolID})
  output$listofdorms <-renderText(input$thesedorms)
  output$DormPicked <- renderText({input$DormID})
  output$GreekPicked <- renderText({input$GreekHouse})
  output$ResidencyPicked <- renderText({input$Residency})
  output$VoteRegNeedsPicked <- renderText({input$VoteRegNeeds})
  #Taking the selected school and looking in the database for the list

  #Removing the delimiter and separating the list of dorms
  #  data.frame(do.call('rbind', strsplit(as.character(thesedorms()),'/',fixed=TRUE)))
}

# Run the application
shinyApp(ui = ui, server = server)
