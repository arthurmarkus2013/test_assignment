package main

import (
	"html/template"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	engine := gin.Default()
	engine.LoadHTMLFiles("index.tmpl")
	configure_routes(engine)
	engine.Run()
}

var (
	gandalf_counter = promauto.NewCounter(prometheus.CounterOpts{
		Name: "gandalf_counter",
		Help: "The total number of calls to Gandalf endpoint.",
	})

	colombo_counter = promauto.NewCounter(prometheus.CounterOpts{
		Name: "colombo_counter",
		Help: "The total number of calls to Colombo endpoint.",
	})
)

func configure_routes(engine *gin.Engine) {
	handler := promhttp.Handler()

	engine.StaticFile("/gandalf.webp", "./gandalf.webp")

	engine.GET("/metrics", func(ctx *gin.Context) {
		handler.ServeHTTP(ctx.Writer, ctx.Request)
	})

	engine.GET("/gandalf", func(ctx *gin.Context) {
		gandalf_counter.Inc()

		ctx.HTML(http.StatusOK, "index.tmpl", gin.H{
			"contents": template.HTML("<img src=\"gandalf.webp\" alt=\"Gandalf\">"),
		})
	})

	engine.GET("/colombo", func(ctx *gin.Context) {
		colombo_counter.Inc()

		location, err := time.LoadLocation("Asia/Colombo")
		if err != nil {
			ctx.String(http.StatusInternalServerError, err.Error())
			return
		}

		ctx.HTML(http.StatusOK, "index.tmpl", gin.H{
			"contents": template.HTML("<h1>Current time in Colombo City (Sri Lanka) is: " + time.Now().In(location).Format(time.TimeOnly) + "</h1>"),
		})
	})
}
