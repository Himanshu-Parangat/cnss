package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func GetFirewallAddress() string {
	host := os.Getenv("FIREWALL_HOST_IP")
	port := os.Getenv("FIREWALL_PORT")

	if host == "" {
		host = "127.0.0.1"
	}
	if port == "" {
		port = "9000"
	}

	return fmt.Sprintf("%s:%s", host, port)
}

func index(w http.ResponseWriter, resp *http.Request) {

	message := `🌸🌸 Welcome to the WAF Web Application Firewall! 🌸🌸

*---------------------------------------------------*
| Available Endpoints  :                            |
| - Show this message  : /                          |
*---------------------------------------------------*

🔑 This will comunnicate in conjunction with revere proxy to set rules.

🐛 This is an implementation of waf Web Application Firewall.
`

	fmt.Fprintf(w, "%v", message)
}

func main() {
	http.HandleFunc("/", index)

	address := GetFirewallAddress()
	log.Println("\n\nServer is running on http://" + address)
	log.Fatal(http.ListenAndServe(address, nil))
}
