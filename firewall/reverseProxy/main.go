package main

import (
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
	"strings"
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

func getHeader(resp *http.Request) string {

	var headers []string
	for key, values := range resp.Header {
		headers = append(headers, fmt.Sprintf("%s: %s", key, values))
	}
	return strings.Join(headers, "\n")
}

func getTransferEncoding(resp *http.Request) []string {
	if len(resp.TransferEncoding) > 0 {
		return resp.TransferEncoding
	}
	return []string{"No Transfer Encoding"}
}

func getQueryParams(resp *http.Request) string {

	if len(resp.URL.Query()) > 0 {

		var queryParams []string

		for key, values := range resp.URL.Query() {
			queryParams = append(queryParams, fmt.Sprintf("%s: %s", key, values))
		}

		return strings.Join(queryParams, "\n")
	}
	return "[No Path Parameter]"
}

type Color string

const (
	Reset   Color = "\033[0m"
	Magenta Color = "\033[35m"
	Blue    Color = "\033[34m"
	Yellow  Color = "\033[33m"

	White Color = "\033[37m"
	Green Color = "\033[32m"
	Red   Color = "\033[31m"
	Cyan  Color = "\033[36m"
	Black Color = "\033[30m"
	Gray  Color = "\033[90m"
)

var logStore []string

func LogWithColor(input any, label string, Marker string, valueColor Color) {

	value := fmt.Sprintf("%v", input)

	for _, value := range strings.SplitAfter(value, "\n") {
		value = strings.TrimSuffix(value, "\n")

		formattedLine := fmt.Sprintf("%s[%s]%s %s%s%s %s%s%s",
			Magenta, Marker, Reset, Blue, label, Reset, valueColor, value, Reset)

		logStore = append(logStore, formattedLine)
		log.Println(formattedLine)
	}
}

func logRequest(resp *http.Request, requestType string, color Color) {
	LogWithColor(getHeader(resp), "Headers", requestType, color)

	LogWithColor(requestType, "Request Type", requestType, color)
	LogWithColor(resp.RemoteAddr, "Remote Address", requestType, color)
	LogWithColor(getTransferEncoding(resp), "Transfer Encoding", requestType, color)
	LogWithColor(resp.Method, "Method", requestType, color)
	LogWithColor(resp.ContentLength, "Content Length", requestType, color)
	LogWithColor(getQueryParams(resp), "Query Parameter", requestType, color)
	LogWithColor(resp.RequestURI, "Requested URI", requestType, color)
	LogWithColor(resp.Host, "Host", requestType, color)
	LogWithColor(resp.Proto, "Protocol", requestType, color)
	LogWithColor(resp.Close, "Close Connection Afterwards", requestType, color)
}

func logIncomingRequest(resp *http.Request) {

	fmt.Printf("\n*-------------- :｡･:*:･ﾟ’★,｡･:*:･ﾟ’☆------------------⋆𐙚₊˚⊹REQUEST INCOMING⋆౨ৎ˚⟡˖---------------- :｡･:*:･ﾟ’★,｡･:*:･ﾟ’☆------------------*\n")

	summery := fmt.Sprintf("%s %s%s from %s",
		resp.Method, resp.Host, resp.URL.Path, resp.RemoteAddr)

	LogWithColor(summery, "Summery", "Reverse Proxy Incoming", Red)

	logRequest(resp, "Incoming Request", Yellow)
}

func logOutgoingRequest(resp *http.Request) {

	fmt.Printf("\n*-------------- :｡･:*:･ﾟ’★,｡･:*:･ﾟ’☆------------------⋆𐙚₊˚⊹REQUEST OUTGOING⋆౨ৎ˚⟡˖---------------- :｡･:*:･ﾟ’★,｡･:*:･ﾟ’☆------------------*\n")

	summery := fmt.Sprintf("%s %s%s --> %s%s",
		resp.Method, resp.Host, resp.URL.Path, "http://"+GetServerAddress(), resp.URL.Path)

	LogWithColor(summery, "Summery", "Reverse Proxy redirected", Red)

	logRequest(resp, "Outgoing Request", Green)
}

func ReverseProxy(w http.ResponseWriter, resp *http.Request) {

	targetURL, err := url.Parse("http://" + GetServerAddress())
	if err != nil {
		http.Error(w, "Internal server error", http.StatusInternalServerError)
		log.Printf("error parsing target url: %v", err)
		return
	}

	logIncomingRequest(resp)

	proxy := httputil.NewSingleHostReverseProxy(targetURL)
	proxy.ServeHTTP(w, resp)

	logOutgoingRequest(resp)
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
