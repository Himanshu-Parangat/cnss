package main

import (
	"fmt"
	"log"
	"net/http"
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
	fmt.Fprintf(w, "\nthis is a Reverse Proxy...\n")
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
	log.Println("\n\nServer is running on http://" + address)
	log.Fatal(http.ListenAndServe(address, nil))
}
