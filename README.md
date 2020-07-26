# MoMEMta Docker image with Python 3 and LHAPDF

[![GitHub Actions Status: CI](https://github.com/Neubauer-Group/momemta-python/workflows/CI/badge.svg?branch=master)](https://github.com/Neubauer-Group/momemta-python/actions?query=workflow%3ACI+branch%3Amaster)
[![Docker Pulls](https://img.shields.io/docker/pulls/matthewfeickert/momemta-python)](https://hub.docker.com/r/matthewfeickert/momemta-python)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/matthewfeickert/momemta-python/latest)](https://hub.docker.com/r/matthewfeickert/momemta-python/tags?name=latest)

> `MoMEMta` is a C++ software package to compute Matrix Element weights. Designed in a modular way, it covers the needs of experimental analysis workflows at the LHC.

`MoMEMta`'s source is [distributed on GitHub](https://github.com/MoMEMta/MoMEMta) and is a product of the `MoMEMta` development team.
[![DOI](https://zenodo.org/badge/DOI/10.1140/epjc/s10052-019-6635-5.svg)](https://doi.org/10.1140/epjc/s10052-019-6635-5)


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
