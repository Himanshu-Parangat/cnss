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
