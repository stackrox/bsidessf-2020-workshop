.PHONY: pull-submodules
pull-submodules:
	git submodule update --init --recursive

.PHONY: diffs
diffs:
	hack/generate-diffs.sh

.PHONY: build
build: diffs
	hugo

.PHONY: preview
preview: diffs
	hugo server
