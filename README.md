# MoMEMta Docker image with Python 3 and LHAPDF

[![Docker Images](https://github.com/Neubauer-Group/momemta-python/actions/workflows/docker-debian.yml/badge.svg?branch=main)](https://github.com/Neubauer-Group/momemta-python/actions/workflows/docker-debian.yml?query=branch%3Amain+)
[![Docker Pulls](https://img.shields.io/docker/pulls/neubauergroup/momemta-python)](https://hub.docker.com/r/neubauergroup/momemta-python)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/neubauergroup/momemta-python/latest)](https://hub.docker.com/r/neubauergroup/momemta-python/tags?name=latest)

> `MoMEMta` is a C++ software package to compute Matrix Element weights. Designed in a modular way, it covers the needs of experimental analysis workflows at the LHC.

`MoMEMta`'s source is [distributed on GitHub](https://github.com/MoMEMta/MoMEMta) and is a product of the `MoMEMta` development team.
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1250697.svg)](https://doi.org/10.5281/zenodo.1250697)
[![paper-DOI](https://zenodo.org/badge/DOI/10.1140/epjc/s10052-019-6635-5.svg)](https://doi.org/10.1140/epjc/s10052-019-6635-5)


## Use

```
docker pull neubauergroup/momemta-python:latest
docker run --rm -it neubauergroup/momemta-python:latest
```

### LHAPDF PDF Sets

No LHAPDF PDF sets are included in the Docker image by default.
To download LHAPDF PDF sets for use, use the `lhapdf get` CLI

```
$ lhapdf --help
usage: lhapdf [-h] [--listdir LISTDIR] [--pdfdir PDFDIR] [--source SOURCES] [--quiet] [--verbose] [--version] COMMAND [suboptions]

A program for managing LHAPDF parton distribution function data files.

The main sub-commands that can be used are:
  - list|ls:     list available PDF sets, optionally filtered and/or categorised by status
  - show:        show metadata details of specified PDF sets
  - update:      download and install a new PDF set index file
  - install|get: download and install new PDF set data files
  - upgrade:     download and install newer replacement PDF set data files where available

positional arguments:
  COMMAND [suboptions]  Subcommand to run

optional arguments:
  -h, --help            show this help message and exit
  --listdir LISTDIR     Directory containing the lhapdf.index list file [default: /usr/local/share/LHAPDF]
  --pdfdir PDFDIR       Directory for installation of PDF set data [default: /usr/local/share/LHAPDF]
  --source SOURCES      Prepend a path or URL to be used as a source of data files [default: ['/cvmfs/sft.cern.ch/lcg/external/lhapdfsets/current/', 'http://lhapdfsets.web.cern.ch/lhapdfsets/current/']]
  --quiet               Suppress normal messages
  --verbose             Output debug messages
  --version             show program's version number and exit
```

Example:

```
$ lhapdf get CT10nlo
$ lhapdf show CT10nlo | grep ID
LHAPDF ID: 11000
$ find /usr/local/ -iname "CT10nlo.info"
/usr/local/share/LHAPDF/CT10nlo/CT10nlo.info
```

A [complete list of available LHAPDF PDF sets](https://lhapdf.hepforge.org/pdfsets.html) is available on the LHAPDF website.

## Tests

To run the [MoMEMta `TTbar_FullyLeptonic` tutorial](https://github.com/MoMEMta/Tutorials/tree/v1.0.0) (compute weights under the hypothesis of top quark pair production with fully leptonic decay) either run

```
make test
```

or the equivalent following command

```
docker run --rm -v $PWD:$PWD -w $PWD neubauergroup/momemta-python:latest 'bash tests/tt_fullyleptonic_tutorial.sh'
```
