# Metadata
TIMESTAMP=$(shell date +"%Y-%b-%d_%H-%M-%S")
ARCH=$(shell go env GOARCH)
OS=$(shell go env GOOS)


metadata:
	@printf "[Metadata]Check Metadata to include in binary name\n\n"
	@printf "    Current time     =>     $(TIMESTAMP) \n"
	@printf "    Set Architecture =>     $(ARCH) \n"
	@printf "    Set os           =>     $(OS) \n"
