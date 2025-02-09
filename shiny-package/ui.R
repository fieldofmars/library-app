library(shiny)

ui <- fluidPage(
  titlePanel("Book Lending Library"),
  sidebarLayout(
    sidebarPanel(
      textInput("book_title", "Book Title:"),
      textInput("book_author", "Book Author:"),
      actionButton("add_book", "Add Book"),
      hr(),
      selectInput("borrow_book_id", "Select Book to Borrow:", choices = NULL),
      textInput("borrower_name", "Borrower Name:"),
      numericInput("borrow_days", "Borrowing Period (days):", value = 14, min = 1),
      actionButton("borrow_book", "Borrow Book")
    ),
    mainPanel(
      tableOutput("book_list")
    )
  )
)
