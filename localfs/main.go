package main

import "net/http"

func main() {
	http.Handle("/", crossOrigin(http.FileServer(http.Dir("/localstore"))))
	panic(http.ListenAndServe(":8080", nil))
}

func crossOrigin(h http.Handler) http.HandlerFunc {

	return func(rw http.ResponseWriter, req *http.Request) {
		println("HI")
		rw.Header().Set("Access-Control-Allow-Origin", "*")
		rw.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		rw.Header().Set("Access-Control-Allow-Headers",
			"Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")
		// Stop here if its Preflighted OPTIONS request
		if req.Method == "OPTIONS" {
			return
		}
		// Lets Gorilla work
		h.ServeHTTP(rw, req)
	}
}
