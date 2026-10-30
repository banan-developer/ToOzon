package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/home", homeHandler)

	fmt.Println("сервер запущен на http://127.0.0.1:8020")
	http.ListenAndServe(":8020", nil)

}

func homeHandler(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "./web/html/index.html")
}
