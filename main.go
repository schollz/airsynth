package main

import (
	"embed"
	"fmt"
	"io/fs"
	"io/ioutil"
	"net/http"
	"strings"
	"time"

	"github.com/gorilla/websocket"
	"github.com/hypebeast/go-osc/osc"
	log "github.com/schollz/logger"
	"gonum.org/v1/gonum/stat"
)

var client *osc.Client

//go:embed static
var static embed.FS
var fsStatic http.Handler

func main() {
	fsRoot, _ := fs.Sub(static, "static")
	fsStatic = http.FileServer(http.FS(fsRoot))
	// client = osc.NewClient("localhost", 57120)
	log.SetLevel("debug")
	port := 8098
	log.Infof("listening on :%d", port)
	http.HandleFunc("/", handler)
	http.ListenAndServe(fmt.Sprintf(":%d", port), nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	t := time.Now().UTC()
	err := handle(w, r)
	if err != nil {
		log.Error(err)
	}
	log.Infof("%v %v %v %s\n", r.RemoteAddr, r.Method, r.URL.Path, time.Since(t))
}

func handle(w http.ResponseWriter, r *http.Request) (err error) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
	w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")

	// very special paths
	if r.URL.Path == "/ws" {
		return handleWebsocket(w, r)
	} else {
		if strings.HasSuffix(r.URL.Path, ".js") {
			w.Header().Set("Content-Type", "text/javascript")
		}
		fsStatic.ServeHTTP(w, r)
		return
		var b []byte
		if r.URL.Path == "/" {
			log.Debug("loading index")
			b, err = ioutil.ReadFile("static/index.html")
			if err != nil {
				return
			}
		} else {
			b, err = ioutil.ReadFile("static" + r.URL.Path)
			if err != nil {
				return
			}
		}
		w.Write(b)
	}

	return
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

var wsupgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func handleWebsocket(w http.ResponseWriter, r *http.Request) (err error) {
	c, errUpgrade := wsupgrader.Upgrade(w, r, nil)
	if errUpgrade != nil {
		return errUpgrade
	}
	defer c.Close()

	for {
		var p HandData
		err := c.ReadJSON(&p)
		if err != nil {
			log.Debug("read:", err)
		} else {
			go processScore(p)
		}
	}
	return
}

var minSpread = 1000.0
var maxSpread = 0.0

func processScore(p HandData) {
	for i, hand := range p.MultiHandLandmarks {
		xs := make([]float64, len(hand))
		ys := make([]float64, len(hand))
		zs := make([]float64, len(hand))
		ws := make([]float64, len(hand))
		for j, coord := range hand {
			xs[j] = coord.X
			ys[j] = coord.Y
			zs[j] = coord.Z
			ws[j] = 1
		}
		meanX, stdX := stat.MeanStdDev(xs, ws)
		meanY, stdY := stat.MeanStdDev(ys, ws)
		meanZ, stdZ := stat.MeanStdDev(zs, ws)
		_ = meanZ
		_ = stdZ
		spread := (stdX + stdY) / 2
		if spread < minSpread {
			minSpread = spread
		}
		if spread > maxSpread {
			maxSpread = spread
		}
		spread = (spread - minSpread) / (maxSpread - minSpread)

		log.Debugf("%s: (%2.2f, %2.2f, %2.2f)", p.MultiHandedness[i].Label, meanX, meanY, spread)
	}
}
