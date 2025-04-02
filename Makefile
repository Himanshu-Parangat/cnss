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



build-all: 
	@printf "$(Purple)[All]$(Green)[Build all component's] Reverse Proxy, WAF, Server, Application & Simulator in $(BIN_DIR) directory $(Cyan)\n"
	@$(MAKE) metadata build-waf build-reverseProxy build-application build-server build-simulator


build-reverseProxy: clean-reverseProxy deps-reverseProxy
	@printf "$(Purple)[Reverse Proxy]$(Yellow)[Build component] Building reverseProxy...$(Reset)\n"
	@cd $(REVERSEPROXY_PATH) && go build -o ../../$(BIN_DIR)/reverseProxy-$(OS)-$(ARCH)-$(TIMESTAMP)
	@printf "$(Purple)[Reverse Proxy]$(Green)[Build component] Built binary reverseProxy here -> $(BIN_DIR)/reverseProxy-$(OS)-$(ARCH)-$(TIMESTAMP)$(Reset)\n"


build-waf: clean-waf deps-waf
	@printf "$(Purple)[WAF]$(Yellow)[Build component] Building waf...$(Reset)\n"
	@cd $(WAF_PATH) && go build -o ../../$(BIN_DIR)/waf-$(OS)-$(ARCH)-$(TIMESTAMP)
	@printf "$(Purple)[WAF]$(Green)[Build component] Built binary waf here -> $(BIN_DIR)/waf-$(OS)-$(ARCH)-$(TIMESTAMP)$(Reset)\n"


build-application: clean-application deps-application
	@printf "$(Purple)[Application]$(Yellow)[Build component] Building application...$(Reset)\n"
	@cd $(APPLICATION_PATH) && go build -o ../../$(BIN_DIR)/application-$(OS)-$(ARCH)-$(TIMESTAMP)
	@printf "$(Purple)[Application]$(Green)[Build component] Built binary application here -> $(BIN_DIR)/application-$(OS)-$(ARCH)-$(TIMESTAMP)$(Reset)\n"


build-server: clean-server deps-server
	@printf "$(Purple)[Server]$(Yellow)[Build component] Building server...$(Reset)\n"
	@cd $(SERVER_PATH) && go build -o ../../$(BIN_DIR)/server-$(OS)-$(ARCH)-$(TIMESTAMP)
	@printf "$(Purple)[Server]$(Green)[Build component] Built binary server here -> $(BIN_DIR)/server-$(OS)-$(ARCH)-$(TIMESTAMP)$(Reset)\n"


build-simulator: clean-simulator deps-simulator
	@printf "$(Purple)[Simulator]$(Yellow)[Build component] Building simulator...$(Reset)\n"
	@cd $(SIMULATOR_PATH) && go build -o ../../$(BIN_DIR)/simulator-$(OS)-$(ARCH)-$(TIMESTAMP)
	@printf "$(Purple)[Simulator]$(Green)[Build component] Built binary simulator here -> $(BIN_DIR)/simulator-$(OS)-$(ARCH)-$(TIMESTAMP)$(Reset)\n"





clean-all: clean-simulator clean-server clean-application clean-waf clean-reverseProxy
	@printf "\n$(Purple)[cleanup]$(Red) Cleaning up binaries directory...$(Reset)\n"
	@rm -r ./$(BIN_DIR)
	@printf "$(Purple)[Cleanup]$(Red) Cleanup complete!$(Reset)\n"


clean-reverseProxy: ensure
	@printf "\n$(Purple)[Reverse Proxy]$(Red)[cleanup component] Cleaning up old reverseProxy binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'reverseProxy-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"
	@rm -f $(BIN_DIR)/reverseProxy-$(OS)-$(ARCH)-*
	@printf "$(Purple)[Reverse Proxy]$(Red)[cleanup] Removed old reverseProxy binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'reverseProxy-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"


clean-waf: ensure
	@printf "\n$(Purple)[WAF]$(Red)[cleanup component] Cleaning up old waf binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'waf-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"
	@rm -f $(BIN_DIR)/waf-$(OS)-$(ARCH)-*
	@printf "$(Purple)[WAF]$(Red)[cleanup] Removed old waf binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'waf-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"


clean-server: ensure
	@printf "\n$(Purple)[Server]$(Red)[cleanup component] Cleaning up old server binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'server-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"
	@rm -f $(BIN_DIR)/server-$(OS)-$(ARCH)-*
	@printf "$(Purple)[Server]$(Red)[cleanup] Removed old server binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'server-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"


clean-application: ensure
	@printf "\n$(Purple)[Application]$(Red)[cleanup component] Cleaning up old application binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'application-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"
	@rm -f $(BIN_DIR)/application-$(OS)-$(ARCH)-*
	@printf "$(Purple)[Application]$(Red)[cleanup] Removed old application binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'application-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"


clean-simulator: ensure
	@printf "\n$(Purple)[Simulator]$(Red)[cleanup component] Cleaning up old simulator binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'simulator-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"
	@rm -f $(BIN_DIR)/simulator-$(OS)-$(ARCH)-*
	@printf "$(Purple)[Simulator]$(Red)[cleanup] Removed old simulator binaries: %s$(Reset)\n" "$$(ls -t $(BIN_DIR) | grep 'simulator-$(OS)-$(ARCH)-*' || echo 'No old binaries found.')"
