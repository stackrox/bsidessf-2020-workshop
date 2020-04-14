package main

import (
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

func init() {
	http.DefaultTransport.(*http.Transport).TLSClientConfig = &tls.Config{InsecureSkipVerify: true}
}

func ssrf(w http.ResponseWriter, r *http.Request) {
	c := http.Client{
		Timeout: 5 * time.Second,
	}
	resp, err := c.Get(r.URL.Query().Get("url"))
	if err != nil {
		w.WriteHeader(http.StatusBadGateway)
		w.Write([]byte(fmt.Sprintf("Couldn't fetch URL: %s\n", err)))
		return
	}
	defer resp.Body.Close()
	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(fmt.Sprintf("Couldn't read response: %s\n", err)))
		return
	}
	w.Write(b)
}

func main() {
	http.HandleFunc("/fetch", ssrf)
	log.Fatal(http.ListenAndServe("0.0.0.0:8080", nil))
}
