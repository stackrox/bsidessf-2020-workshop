VERSION=0.0.2
IMAGE=connorg/struts:$(VERSION)

.PHONY: all
all: image

.PHONY: image
image:
	docker build -t $(IMAGE) -f Dockerfile .
	docker build -t $(IMAGE)-ro -f Dockerfile-ro .
	docker build -t $(IMAGE)-streamlined -f Dockerfile-streamlined .

.PHONY: push
push:
	docker push $(IMAGE)
	docker push $(IMAGE)-ro
	docker push $(IMAGE)-streamlined
