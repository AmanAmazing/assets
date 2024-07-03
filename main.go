package main

import (
	"assets/routes"
	"assets/utils"
	"assets/views/pages"
	"context"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
)

func init() {
	if err := godotenv.Load(); err != nil {
		log.Fatal(err)
	}
	utils.SetTokenAuth(os.Getenv("JWT_SECRET_KEY"))
	// err := services.InitDB()
	// if err != nil {
	// 	log.Fatalf("database initilisation error: %v", err)
	// }
	// testData := false
	// // Insert test data into the database
	// if testData {
	// 	services.TestData()
	// }
}

func main() {
	router := chi.NewRouter()
	router.Use(middleware.Logger)
	router.Use(middleware.Recoverer)
	// creating a fileserver
	dir := http.Dir("./assets")
	fs := http.FileServer(dir)

	router.Handle("/assets/*", http.StripPrefix("/assets/", fs))

	// router.Mount("/", routes.UserRouter())
	// router.Mount("/admin", routes.AdminRouter())
	//
	router.NotFound(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusNotFound)
		pages.Error404().Render(context.Background(), w)
	})
	router.MethodNotAllowed(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusMethodNotAllowed)
		w.Write([]byte("Jesus is watching, don't do something stupid"))
		return
	})

	router.Mount("/", routes.UserRouter())

	http.ListenAndServe(os.Getenv("PORT"), router)

}
