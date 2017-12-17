package main

import (
	"html/template"
	"log"
	"net/http"
)

func renderTemplate(w http.ResponseWriter, tmpl string) {
	t, err := template.ParseFiles("templates/" + tmpl + ".html")
	if err != nil {
		handleError(w, err)
		return
	}
	err = t.Execute(w, nil)
	if err != nil {
		handleError(w, err)
	}
}

func handleError(w http.ResponseWriter, err error) {
	log.Println(err)
	http.Error(w, err.Error(), http.StatusInternalServerError)
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	renderTemplate(w, "index")
}

func main() {
	http.HandleFunc("/", indexHandler)

	http.Handle("/public/", http.FileServer(http.Dir(".")))
	http.ListenAndServe(":8080", nil)
}
