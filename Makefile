pull-submodules:
	git submodule update --init --recursive

build:
	hugo

preview:
	hugo server
