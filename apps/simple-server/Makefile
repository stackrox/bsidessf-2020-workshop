VERSION=0.0.1
IMAGE=connorg/simple-server:$(VERSION)

.PHONY: all
all: image

main: main.go
	GOOS=linux GOARCH=amd64 go build main.go

.PHONY: image
image: main
	docker build -t $(IMAGE) .
	docker build -t $(IMAGE)-nonroot -f Dockerfile-nonroot .

.PHONY: push
push:
	docker push $(IMAGE)
	docker push $(IMAGE)-nonroot
