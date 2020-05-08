VERSION=0.0.3
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

	docker tag $(IMAGE) quay.io/$(IMAGE)
	docker push quay.io/$(IMAGE)
	docker tag $(IMAGE)-ro quay.io/$(IMAGE)-ro
	docker push quay.io/$(IMAGE)-ro
	docker tag $(IMAGE)-streamlined quay.io/$(IMAGE)-streamlined
	docker push quay.io/$(IMAGE)-streamlined
