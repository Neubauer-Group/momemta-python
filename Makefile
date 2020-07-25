default: image

all: image

image:
	docker build . \
	-f Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	-t matthewfeickert/momemta-python:latest \
	-t matthewfeickert/momemta-python:2.7.2
	--compress .

image:
	docker build . \
	-f Dockerfile \
	--build-arg LHAPDF_VERSION=6.2.3 \
	-t matthewfeickert/momemta-python:debug-local
