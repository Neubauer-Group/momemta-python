# MoMEMta Docker image with Python 3 and LHAPDF

[![GitHub Actions Status: CI](https://github.com/Neubauer-Group/momemta-python/workflows/CI/svg?branch=master)](https://github.com/Neubauer-Group/momemta-python/actions?query=workflow%3ACI+branch%3Amaster)
[![Docker Pulls](https://img.shields.io/docker/pulls/matthewfeickert/momemta-python)](https://hub.docker.com/r/matthewfeickert/momemta-python)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/matthewfeickert/momemta-python/latest)](https://hub.docker.com/r/matthewfeickert/momemta-python/tags?name=latest)


## Use

```
docker pull matthewfeickert/momemta-python:latest
docker run --rm -it matthewfeickert/momemta-python:latest
```

## Tests

To run the [MoMEMta `TTbar_FullyLeptonic` tutorial](https://github.com/MoMEMta/Tutorials/tree/v1.0.0) (compute weights under the hypothesis of top quark pair production with fully leptonic decay) either run

```
make test
```

or the equivalent following command

```
docker run --rm -v $PWD:$PWD -w $PWD matthewfeickert/momemta-python:latest "bash tests/tt_fullyleptonic_tutorial.sh"
```
