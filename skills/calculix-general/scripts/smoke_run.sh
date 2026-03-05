#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
test_dir="${repo_root}/test"
job="${1:-simplebeam}"

resolve_ccx_bin() {
  if [ -x "${repo_root}/src/CalculiX" ]; then
    printf '%s\n' "${repo_root}/src/CalculiX"
    return 0
  fi
  if command -v CalculiX >/dev/null 2>&1; then
    command -v CalculiX
    return 0
  fi
  if command -v ccx >/dev/null 2>&1; then
    command -v ccx
    return 0
  fi
  return 1
}

if [ "${job}" = "--resolve-bin" ]; then
  if resolve_ccx_bin; then
    exit 0
  fi
  echo "ERROR: No CalculiX executable found. Build src/CalculiX or install CalculiX/ccx in PATH." >&2
  exit 1
fi

ccx_bin="$(resolve_ccx_bin || true)"
if [ -z "${ccx_bin}" ]; then
  echo "ERROR: No CalculiX executable found. Build src/CalculiX or install CalculiX/ccx in PATH." >&2
  exit 1
fi

if [ ! -f "${test_dir}/${job}.inp" ]; then
  echo "ERROR: Input deck not found: test/${job}.inp" >&2
  exit 2
fi

cd "${test_dir}"
rm -f "${job}.dat" "${job}.frd" "${job}.sta" "${job}.cvg"
"${ccx_bin}" "${job}"

for out in "${job}.dat" "${job}.frd"; do
  if [ ! -s "${out}" ]; then
    echo "ERROR: Missing or empty output ${out}" >&2
    exit 3
  fi
done

echo "OK: ${job}.dat and ${job}.frd created"

if [ -f "${job}.dat.ref" ] && [ -x "./datcheck.pl" ]; then
  ./datcheck.pl "${job}" > "error.${job}.datcheck" || true
  if [ -s "error.${job}.datcheck" ]; then
    echo "WARN: datcheck differences found in test/error.${job}.datcheck"
  else
    rm -f "error.${job}.datcheck"
    echo "OK: datcheck matches ${job}.dat.ref"
  fi
fi

if [ -f "${job}.frd.ref" ] && [ -x "./frdcheck.pl" ]; then
  ./frdcheck.pl "${job}" > "error.${job}.frdcheck" || true
  if [ -s "error.${job}.frdcheck" ]; then
    echo "WARN: frdcheck differences found in test/error.${job}.frdcheck"
  else
    rm -f "error.${job}.frdcheck"
    echo "OK: frdcheck matches ${job}.frd.ref"
  fi
fi
