library(shiny)

ui <- fluidPage(
  titlePanel("Book Lending Library"),
  sidebarLayout(
    sidebarPanel(
      textInput("book_title", "Book Title:"),
      textInput("book_author", "Book Author:"),
      actionButton("add_book", "Add Book")
    ),
    mainPanel(
      tableOutput("book_list")
    )
  )
)
