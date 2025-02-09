library(shiny)
library(RSQLite)

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
      borrower TEXT
    )
  ")

  # Function to load books from the database
  load_books <- function() {
    dbGetQuery(db_con, "SELECT * FROM books")
  }

  # Initially load books
  books_data <- reactiveVal(load_books())

  # Add book event
  observeEvent(input$add_book, {
    new_title <- input$book_title
    new_author <- input$book_author

    # Insert new book into the database
    query <- sprintf("INSERT INTO books (title, author) VALUES ('%s', '%s')", new_title, new_author)
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
