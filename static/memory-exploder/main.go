package main

import (
	"flag"
	"fmt"
  "io/ioutil"
	"net/http"
  "os"
  "strconv"
  "strings"
)

func main() {
	var addr string

	// The purpose of this flag is to make it easier to change
	// the port; ports don't really matter when containers are
	// exposed using a Kubernetes Service, so it's nice to let
	// your apps take this as a parameter versus requiring code
	// changes to edit the port number.
	flag.StringVar(&addr, "addr", "0.0.0.0:80", "Address to listen on")
	flag.Parse()

	fmt.Fprintf(os.Stderr, "Listening on %q\n", addr)

	err := http.ListenAndServe(addr, http.HandlerFunc(serve))

	if err != nil {
		fmt.Printf("Error serving: %v", err)
	}
}

func logRequest(r *http.Request) {
  fmt.Fprintf(os.Stderr, "Request URL:  %s\n", r.URL.String())
  body, err := ioutil.ReadAll(r.Body)
  if err != nil {
    fmt.Fprintf(os.Stderr, "Unable to print request body: %v", err)
    return
  }
  fmt.Fprintf(os.Stderr, "Request data: %v", body)
}

func alloc(n int) []int {
  return make([]int, 0, n)
}

func serve(w http.ResponseWriter, r *http.Request) {
  logRequest(r)

  if r.Method != "POST" {
    w.WriteHeader(http.StatusMethodNotAllowed)
    return
  }

  // This handler is what does all of the problematic allocation.
  // To use it, POST to /1234 (which will work), and progressively
  // get up to much larger numbers to trip your memory limit.
  // Warning: make sure not to DoS important workloads,
  // or your personal computer!
  n, err := strconv.Atoi(strings.TrimLeft(r.URL.Path, "/"))
  if err != nil {
    w.WriteHeader(http.StatusBadRequest)
    return
  }
  fmt.Fprintf(os.Stderr, "Allocating []int with size %d\n", n)
  _ = alloc(n)

	w.Write([]byte(fmt.Sprintf("Allocated a []int with size %d\n", n)))
}
