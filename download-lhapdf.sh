#!/usr/bin/env bash

function download_LHAPDF() {
  # 1: LHAPDF set name
  local pdfset_name="${1}"
  lhapdf --source http://lhapdfsets.web.cern.ch/lhapdfsets/current/ get "${pdfset_name}"
}

download_LHAPDF "$@" || exit 1
