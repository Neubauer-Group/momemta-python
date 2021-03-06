default: image

all: image

image:
	docker build . \
	-f docker/debian/Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	--build-arg MOMEMTA_VERSION=v1.0.1 \
	-t neubauergroup/momemta-python:latest \
	-t neubauergroup/momemta-python:1.0.1
	--compress .

debug:
	docker build . \
	-f docker/debian/Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	--build-arg MOMEMTA_VERSION=v1.0.1 \
	-t neubauergroup/momemta-python:debug-local

debug-centos:
	docker build . \
	-f docker/centos/Dockerfile \
	--build-arg MOMEMTA_VERSION=v1.0.1 \
	-t neubauergroup/momemta-python-centos:debug-local

test:
	docker run \
		--rm \
		-v $(shell pwd):$(shell pwd) \
		-w $(shell pwd) \
		neubauergroup/momemta-python:latest \
		"bash tests/tt_fullyleptonic_tutorial.sh"
