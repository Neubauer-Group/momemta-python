default: image

all: image

image:
	docker build . \
	-f Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	--build-arg MOMEMTA_VERSION=v1.0.0 \
	-t matthewfeickert/momemta-python:latest \
	-t matthewfeickert/momemta-python:1.0.0
	--compress .

debug:
	docker build . \
	-f Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	--build-arg MOMEMTA_VERSION=v1.0.0 \
	-t matthewfeickert/momemta-python:debug-local

test:
	docker run \
		--rm \
		-v $(shell pwd):$(shell pwd) \
		-w $(shell pwd) \
		matthewfeickert/momemta-python:latest \
		"bash tests/tt_fullyleptonic_tutorial.sh"
