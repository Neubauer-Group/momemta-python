default: image

all: image

image:
	docker build . \
	-f Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	--build-arg MOMEMTA_VERSION=v1.0.0 \
	-t matthewfeickert/momemta-python:latest \
	-t matthewfeickert/momemta-python:2.7.2
	--compress .

debug:
	docker build . \
	-f Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	--build-arg MOMEMTA_VERSION=v1.0.0 \
	-t matthewfeickert/momemta-python:debug-local
