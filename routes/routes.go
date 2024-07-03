package routes

import (
	"context"
	"intranet/views/pages"
	"net/http"

	"github.com/go-chi/chi/v5"
)

func UserRouter() http.Handler {
	r := chi.NewRouter()

	// For routes that logged in users must not see
	r.Group(func(r chi.Router) {
		r.Get("/", func(w http.ResponseWriter, r *http.Request) {
			pages.GetHome().Render(context.Background(), w)
		})
		r.Get("/login", func(w http.ResponseWriter, r *http.Request) {
			pages.GetLogin().Render(context.Background(), w)
		})
	})

	return r
}
