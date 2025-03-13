package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
)

func GetReverseProxyAddress() string {
	host := os.Getenv("REVERSE_PROXY_HOST_IP")
	port := os.Getenv("REVERSE_PROXY_PORT")

	if host == "" {
		host = "127.0.0.1"
	}
	if port == "" {
		port = "8000"
	}

	return fmt.Sprintf("%s:%s", host, port)
}

func GetServerAddress() string {
	host := os.Getenv("SERVER_HOST_IP")
	port := os.Getenv("SERVER_PORT")

	if host == "" {
		host = "127.0.0.1"
	}
	if port == "" {
		port = "8080"
	}

	return fmt.Sprintf("%s:%s", host, port)
}

func showHelpMessage(w http.ResponseWriter, resp *http.Request) {

	message := `🌸🌸 Welcome to the Reverse Proxy! 🌸🌸

*---------------------------------------------------*
| Available Endpoints  :                            |
| - Show this message  : /                          |
*---------------------------------------------------*

🔑 When you request url, it would be redirected to the server.

🐛 This is an implementation of Reverse Proxy.
`

	fmt.Fprintf(w, "%v", message)
}

func ReverseProxy(w http.ResponseWriter, resp *http.Request) {

	targetURL, err := url.Parse("http://" + GetServerAddress())
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		log.Printf("error parsing target url: %v", err)
		return
	}

	log.Printf("[Reverse Proxy] Incoming request: %s %s%s from %s",
		resp.Method, resp.Host, resp.URL.Path, resp.RemoteAddr)

	proxy := httputil.NewSingleHostReverseProxy(targetURL)
	proxy.ServeHTTP(w, resp)

	log.Printf("[Reverse Proxy] Forwarded request: %s %s%s --> %s%s",
		resp.Method, resp.Host, resp.URL.Path, targetURL, resp.URL.Path)
}

func checkQueryParams(w http.ResponseWriter, resp *http.Request) {

	if resp.URL.Query().Get("enable_help_measssage") == "force" {
		showHelpMessage(w, resp)
		return
	}
	ReverseProxy(w, resp)

}

func main() {
	http.HandleFunc("/", checkQueryParams)

	address := GetReverseProxyAddress()
	log.Printf("\n\nReverse Proxy is running on http://%s\nRequests will be forwarded to the target http://%s", address, GetServerAddress())
	log.Fatal(http.ListenAndServe(address, nil))
}
