PROJECT      = datadog-sidekiq
ORGANIZATION = feedforce
VERSION      := $(shell grep 'const version ' main.go | sed -E 's/.*"(.+)"$$/\1/')
SRC          ?= $(shell go list ./... | grep -v vendor)
TESTARGS     ?= -v

test:
	go test $(SRC) $(TESTARGS)
.PHONY: test

fmt:
	go fmt $(SRC)
.PHONY: fmt

vet:
	go vet $(SRC)
.PHONY: vet

build:
	go build -o build/$(PROJECT)
.PHONY: build

cross-build:
	rm -rf pkg
	mkdir -p pkg/dist

	docker run --rm -it \
		-v ${PWD}:/gopath/src/github.com/$(ORGANIZATION)/$(PROJECT) \
		-w /gopath/src/github.com/$(ORGANIZATION)/$(PROJECT) \
		tcnksm/gox:1.9 gox -osarch="linux/amd64" -output="pkg/{{.OS}}_{{.Arch}}/{{.Dir}}"

	for PLATFORM in $$(find pkg -mindepth 1 -maxdepth 1 -type d); do \
		PLATFORM_NAME=$$(basename $$PLATFORM); \
		ARCHIVE_NAME=$(PROJECT)_$(VERSION)_$${PLATFORM_NAME}; \
		\
		if [ $$PLATFORM_NAME = "dist" ]; then \
			continue; \
		fi; \
		\
		pushd $$PLATFORM; \
		tar -zvcf $(CURDIR)/pkg/dist/$${ARCHIVE_NAME}.tar.gz *; \
		popd; \
	done

	pushd pkg/dist; \
	shasum -a 256 * > $(VERSION)_SHASUMS; \
	popd
.PHONY: cross-build

release: cross-build
	docker run --rm -it \
		-e GITHUB_TOKEN=${GITHUB_TOKEN} \
		-v ${PWD}:/go/src/github.com/$(ORGANIZATION)/$(PROJECT) \
		-w /go/src/github.com/$(ORGANIZATION)/$(PROJECT) \
		tsub/ghr -username $(ORGANIZATION) -repository $(PROJECT) $(VERSION) pkg/dist/
.PHONY: release
