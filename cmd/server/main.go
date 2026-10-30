package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"os"

	_ "github.com/jackc/pgx/v5/stdlib"
)

func main() {
	f, err := os.OpenFile("info.log", os.O_RDWR|os.O_CREATE, 0666)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()
	errorLog := log.New(f, "ERROR\t", log.Ldate|log.Ltime|log.Lshortfile)

	dbPassword := os.Getenv("DB_PASSWORD")
	if dbPassword == "" {
		errorLog.Fatal("DB_PASSWORD не установлен")
	}
	dsn := url.URL{
		Scheme:   "postgres",
		User:     url.UserPassword("postgres", dbPassword),
		Host:     "127.0.0.1:5432",
		Path:     "/toOzo",
		RawQuery: "sslmode=disable",
	}

	db, err := sql.Open("pgx", dsn.String())
	if err != nil {
		errorLog.Fatal("ошибка подлкючения к базе данных", err)
	}

	err = db.Ping()
	if err != nil {
		errorLog.Fatal("Ошибка подключения", err)
	}

	defer db.Close()

	http.HandleFunc("/home", homeHandler)

	fmt.Println("сервер запущен на http://127.0.0.1:8020")
	http.ListenAndServe(":8020", nil)

}

func homeHandler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "./web/html/index.html")
}
