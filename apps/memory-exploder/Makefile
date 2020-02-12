VERSION=0.0.0
IMAGE=connorg/memory-exploder:$(VERSION)

.PHONY: all
all: image

main: main.go
	GOOS=linux GOARCH=amd64 go build main.go

.PHONY: image
image: main
	docker build -t $(IMAGE) .

.PHONY: push
push:
	docker push $(IMAGE)
