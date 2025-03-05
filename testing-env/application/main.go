package main

import (
	"embed"
	"encoding/json"
	"fmt"
	"html/template"
	"io"
	"log"
	"net/http"
	"os"
)

//go:embed components/index.html
var templateFiles embed.FS

func GetServerAddress()  string{
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

func GetApplicationAddress() string {
	host := os.Getenv("APPLICATION_HOST_IP")
	port := os.Getenv("APPLICATION_PORT")

	if host == "" {
		host = "127.0.0.1"
	}
	if port == "" {
		port = "5000"
	}

	return fmt.Sprintf("%s:%s", host, port)
}


func get_data() []byte {

	resp, err := http.Get("http://" + GetServerAddress() + "/api/v1/data")
	if err != nil {
		log.Println("\n\nserver is down", err)
		return nil
	}
	defer resp.Body.Close()

	fmt.Println("Response status:", resp.Status)

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		log.Println("can't read Response Body:", err)
		return nil
	}
	return body
}

func process_json_data(body []byte) map[string]interface{} {
	var data map[string]interface{}
	err := json.Unmarshal(body, &data)
	if err != nil {
		log.Println("can't process json data", err)
		return nil
	}
	return data
}

func dashboard(w http.ResponseWriter, resp *http.Request) {
	tmpl, err := template.ParseFS(templateFiles, "components/index.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	err = tmpl.Execute(w, nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

}

func entryData(w http.ResponseWriter, resp *http.Request) {

	data := process_json_data(get_data())
	w.Header().Set("Content-Type", "text/html")

	entry := fmt.Sprintf(`
		<tr id="new-entry">
		<td>%s</td>
		<td>%s</td>
		<td>%s</td>
		<td>%.2f</td>
		<td>%s</td>
		<td>%s</td>
		<td>%s</td>
		<td>%s</td>
		<td>%s</td>
		</tr>`,
		data["UID"],
		data["FirstName"],
		data["LastName"],
		data["PayAmount"],
		data["PaymentMode"],
		data["PayStatus"],
		data["DateOfTransaction"],
		data["Location"],
		data["Contact"],
	)
	fmt.Fprint(w, entry)
}


func index(w http.ResponseWriter, resp *http.Request) {

	message := `🌸🌸 Welcome to the dummy client 🌸🌸

*--------------------------------*
| Available Endpoints:           |
| - index     : /                |
| - Dashboard : /dashboard       |
*--------------------------------*

🔑 head to /dashboard that will make a json request
   to server:port/api/v1/data response will be like this


{
  "UID": "<unique identifier>",
  "FirstName": "<user first name>",
  "LastName": "<user last name>",
  "PayAmount": "<user amount>",
  "PaymentMode": "<user payment method>",
  "PayStatus": "<user payment status>",
  "DateOfTransaction": "<user date and time>",
  "Location": "<user location>",
  "Contact": "<user contact number>"
}

🐛 The data will be presented in a table on the dashboard.
`

	fmt.Fprintf(w, "%v", message)
}


func main() {
	http.HandleFunc("/", index)
	http.HandleFunc("/dashboard", dashboard)
	http.HandleFunc("/htmx/get/entry", entryData)

  address := GetApplicationAddress()
	log.Println("\n\napplication is running on http://"+address)
	log.Fatal(http.ListenAndServe(address, nil))
}
