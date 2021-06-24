package main

import (
	"embed"
	"fmt"
	"io/fs"
	"net/http"
	"strings"
)

//go:embed static
var static embed.FS

func main() {
	fsRoot, _ := fs.Sub(static, "static")
	fsStatic := http.FileServer(http.FS(fsRoot))
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		ruri := r.RequestURI
		fmt.Println(ruri, strings.HasSuffix(ruri, ".js"))
		if strings.HasSuffix(ruri, ".js") {
			w.Header().Set("Content-Type", "text/javascript")
		}
		fsStatic.ServeHTTP(w, r)
	})
	fmt.Println("running on port 8080")
	http.ListenAndServe(":8080", nil)
}

type HandData struct {
	MultiHandLandmarks [][]struct {
		X float64 `json:"x"`
		Y float64 `json:"y"`
		Z float64 `json:"z"`
	} `json:"multiHandLandmarks"`
	MultiHandedness []struct {
		Index int     `json:"index"`
		Score float64 `json:"score"`
		Label string  `json:"label"`
	} `json:"multiHandedness"`
}
