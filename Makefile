.PHONY: all
all: clean format lint gen

BUF_VERSION=1.42.0
NAMES=common order_service

.PHONY: install-plugins
install-plugins:
	@go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	@go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

.PHONY: buf-install
buf-install:
ifeq ($(shell uname -s), Darwin)
	@[ ! -f $(GOPATH)/bin/buf ] || exit 0 && \
	tmp=$$(mktemp -d) && cd $$tmp && \
	curl -L -o buf \
		https://github.com/bufbuild/buf/releases/download/v$(BUF_VERSION)/buf-Darwin-arm64 && \
	mv buf $(GOPATH)/bin/buf && \
	chmod +x $(GOPATH)/bin/buf
else
	@[ ! -f $(GOPATH)/bin/buf ] || exit 0 && \
	tmp=$$(mktemp -d) && cd $$tmp && \
	curl -L -o buf \
		https://github.com/bufbuild/buf/releases/download/v$(BUF_VERSION)/buf-Linux-x86_64 && \
	mv buf $(GOPATH)/bin/buf && \
	chmod +x $(GOPATH)/bin/buf
endif


.PHONY: tags
tags: SHELL:=/bin/bash
tags:
	@for name in $(NAMES); do \
  		version=$$(cat $(CURDIR)/proto/$$name/version) && echo "work with $$name and $$version" && \
  		tag=gen/go/$$name/v$$version && echo "tag: $$tag" && \
  		if [[ ! $$(git tag -l "$$tag") ]]; then \
  		  	git tag -a "$$tag" -m "" && \
  		  	git push origin "$$tag" -o ci.skip; \
		fi; \
	done

.PHONY: gen
gen: buf-install
	@$(GOPATH)/bin/buf generate --debug
	@for name in $(NAMES); do \
  		cd $(CURDIR)/gen/go/$$name && \
  		go mod init github.com/WM1rr0rB8/contractsTest/gen/go/$$name && go mod tidy; \
  	done

.PHONY: lint
lint: buf-install
	@$(GOPATH)/bin/buf lint

.PHONY: format
format: buf-install
	@$(GOPATH)/bin/buf format -w


.PHONY: clean
clean:
	@rm -rf ./gen || true
