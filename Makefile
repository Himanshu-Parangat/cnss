# color for printf
Red=\033[0;31m
Green=\033[0;32m
Yellow=\033[0;33m
Blue=\033[0;34m
Purple=\033[0;35m
Cyan=\033[0;36m
White=\033[0;37m
Black=\033[0;30m
Gray=\033[0;90m
Reset=\033[0m


BIN_DIR=bin

REVERSEPROXY_PATH=firewall/reverseProxy
WAF_PATH=firewall/waf
APPLICATION_PATH=testing-env/application
SERVER_PATH=testing-env/server
SIMULATOR_PATH=testing-env/simulator

# Metadata
TIMESTAMP=$(shell date +"%Y-%b-%d_%H-%M-%S")
ARCH=$(shell go env GOARCH)
OS=$(shell go env GOOS)


ensure:
	@printf "\n$(Purple)[Essentials]$(Green)[directory check] ensureing required $(BIN_DIR) directory $(Reset)\n"
	@mkdir -p ./$(BIN_DIR)


metadata:
	@printf "$(Purple)[Metadata]$(Reset)Check Metadata to include in binary name$(Reset)\n\n"
	@printf "$(Blue)    Current time     $(Reset)=>    $(Green) $(TIMESTAMP) $(Reset)\n"
	@printf "$(Blue)    Set Architecture $(Reset)=>    $(Green) $(ARCH) $(Reset)\n"
	@printf "$(Blue)    Set os           $(Reset)=>    $(Green) $(OS) $(Reset)\n"


deps-all:
	@printf "$(Purple)[All]$(Green)[Go Modules] Dependence Resolving for all Modules Reverse Proxy,WAF, Server, Application & Simulator $(Cyan)\n"
	@$(MAKE) deps-waf deps-reverseProxy deps-application deps-server deps-simulator

deps-reverseProxy:
	@printf "$(Purple)[Reverse Proxy]$(Blue)[Go Modules] Resolving dependencies...$(Reset)\n"
	@cd $(REVERSEPROXY_PATH) && { \
		go mod tidy || { printf "$(Red)[Error] go mod tidy failed!$(Reset)\n"; exit 1; }; \
		go mod download || { printf "$(Red)[Error] go mod download failed!$(Reset)\n"; exit 1; }; \
		go mod verify || { printf "$(Red)[Error] go mod verify failed!$(Reset)\n"; exit 1; }; \
	}
	@printf "$(Purple)[Reverse Proxy]$(Green)[Go Modules] Dependencies resolved successfully!$(Reset)\n"


deps-waf:
	@printf "$(Purple)[WAF]$(Blue)[Go Modules] Resolving dependencies...$(Reset)\n"
	@cd $(WAF_PATH) && { \
		go mod tidy || { printf "$(Red)[Error] go mod tidy failed!$(Reset)\n"; exit 1; }; \
		go mod download || { printf "$(Red)[Error] go mod download failed!$(Reset)\n"; exit 1; }; \
		go mod verify || { printf "$(Red)[Error] go mod verify failed!$(Reset)\n"; exit 1; }; \
	}
	@printf "$(Purple)[WAF]$(Green)[Go Modules] Dependencies resolved successfully!$(Reset)\n"


deps-server:
	@printf "$(Purple)[Server]$(Blue)[Go Modules] Resolving dependencies...$(Reset)\n"
	@cd $(SERVER_PATH) && { \
		go mod tidy || { printf "$(Red)[Error] go mod tidy failed!$(Reset)\n"; exit 1; }; \
		go mod download || { printf "$(Red)[Error] go mod download failed!$(Reset)\n"; exit 1; }; \
		go mod verify || { printf "$(Red)[Error] go mod verify failed!$(Reset)\n"; exit 1; }; \
	}
	@printf "$(Purple)[Server]$(Green)[Go Modules] Dependencies resolved successfully!$(Reset)\n"


deps-application:
	@printf "$(Purple)[Application]$(Blue)[Go Modules] Resolving dependencies...$(Reset)\n"
	@cd $(APPLICATION_PATH) && { \
		go mod tidy || { printf "$(Red)[Error] go mod tidy failed!$(Reset)\n"; exit 1; }; \
		go mod download || { printf "$(Red)[Error] go mod download failed!$(Reset)\n"; exit 1; }; \
		go mod verify || { printf "$(Red)[Error] go mod verify failed!$(Reset)\n"; exit 1; }; \
	}
	@printf "$(Purple)[Application]$(Green)[Go Modules] Dependencies resolved successfully!$(Reset)\n"


deps-simulator:
	@printf "$(Purple)[Simulator]$(Blue)[Go Modules] Resolving dependencies...$(Reset)\n"
	@cd $(SIMULATOR_PATH) && { \
		go mod tidy || { printf "$(Red)[Error] go mod tidy failed!$(Reset)\n"; exit 1; }; \
		go mod download || { printf "$(Red)[Error] go mod download failed!$(Reset)\n"; exit 1; }; \
		go mod verify || { printf "$(Red)[Error] go mod verify failed!$(Reset)\n"; exit 1; }; \
	}
	@printf "$(Purple)[Simulator]$(Green)[Go Modules] Dependencies resolved successfully!$(Reset)\n"


