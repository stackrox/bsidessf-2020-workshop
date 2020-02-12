package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

type simpleServer struct {
	log io.Writer
}

func main() {
	var addr, logPath string

	// The purpose of this path is to demonstrate a use case for
	// an app's access to the local file system.
	// It is better to log to stdout/stderr, but many apps like
	// to use scratch space for other purposes.
	flag.StringVar(&logPath, "logPath", "/server.log", "Path to use for logging")
	// The purpose of this flag is to make it easier to change
	// the port; ports don't really matter when containers are
	// exposed using a Kubernetes Service, so it's nice to let
	// your apps take this as a parameter versus requiring code
	// changes to edit the port number.
	flag.StringVar(&addr, "addr", "0.0.0.0:80", "Address to listen on")

	flag.Parse()

	s := newServer(logPath)
	fmt.Fprintf(os.Stderr, "Listening on %q\n", addr)

	err := http.ListenAndServe(addr, s)

	if err != nil {
		fmt.Printf("Error serving: %v", err)
	}
}

func newServer(path string) *simpleServer {
	if path == "" {
		return &simpleServer{
			log: os.Stderr,
		}
	}

	file, err := os.OpenFile("file.go", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Panicf("Couldn't open log path %q: %v", path, err)
	}
	return &simpleServer{
		log: file,
	}
}

func (s *simpleServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.log.Write([]byte(fmt.Sprintf("Request: %s\n", r.URL.String())))
	w.Write([]byte("Hello!"))
}
