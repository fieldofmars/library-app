library(shiny)
library(RSQLite)
library(lubridate)

# Define server logic
server <- function(input, output, session) {
  # Initialize database connection
  db_con <- dbConnect(SQLite(), "books.db")

  # Create books table if it doesn't exist
  dbExecute(db_con, "
    CREATE TABLE IF NOT EXISTS books (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      author TEXT,
      borrower TEXT,
      borrow_date DATE,
      return_date DATE
    )
  ")

  # Function to load books from the database
  load_books <- function() {
    dbGetQuery(db_con, "SELECT * FROM books")
  }

  # Initially load books
  books_data <- reactiveVal(load_books())

  # Update book choices for borrowing
  observe({
    books <- books_data()
    available_books <- books[is.na(books$borrower), ]
    updateSelectInput(session, "borrow_book_id", choices = available_books$id,
                      label = "Select Book to Borrow:")
  })

  # Add book event
  observeEvent(input$add_book, {
    new_title <- input$book_title
    new_author <- input$book_author

    # Insert new book into the database, setting borrow_date and return_date to NULL
    query <- sprintf("INSERT INTO books (title, author, borrow_date, return_date) VALUES ('%s', '%s', NULL, NULL)", new_title, new_author)
    dbExecute(db_con, query)

    # Refresh books data
    books_data(load_books())
  })

  # Borrow book event
  observeEvent(input$borrow_book, {
    book_id <- input$borrow_book_id
    borrower_name <- input$borrower_name
    borrow_days <- input$borrow_days

    borrow_date <- Sys.Date()
    return_date <- borrow_date + days(borrow_days)

    # Update book information in the database
    query <- sprintf("
      UPDATE books
      SET borrower = '%s', borrow_date = '%s', return_date = '%s'
      WHERE id = %s
    ", borrower_name, borrow_date, return_date, book_id)
    dbExecute(db_con, query)

    # Refresh books data
    books_data(load_books())
  })

  # Output book list
  output$book_list <- renderTable({
    books_data()
  })

  # Close database connection when session ends
  session$onSessionEnded(function() {
    dbDisconnect(db_con)
  })
}
