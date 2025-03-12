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

func index(w http.ResponseWriter, resp *http.Request) {

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

func main() {
	http.HandleFunc("/", index)

	address := GetReverseProxyAddress()
	log.Println("\n\nServer is running on http://" + address)
	log.Fatal(http.ListenAndServe(address, nil))
}
