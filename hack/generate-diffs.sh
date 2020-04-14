#!/usr/bin/env bash
set -eu

function write_diff() {
	start="$1"
  end="$2"
  out="$3"

  set +e
  diff "$start" "$end" > "$out"
  ret="$?"
  set -e

  if [ "$ret" -gt 1 ]; then
    echo "Error: Exit code >1 ($ret) from diff between:"
    echo "  $start and"
    echo "  $end"
    exit $?
  fi
}

write_diff static/struts/Dockerfile static/struts/Dockerfile-streamlined static/struts/streamlined.patch
write_diff static/struts/Dockerfile static/struts/Dockerfile-ro static/struts/ro.patch
write_diff static/simple-server/Dockerfile static/simple-server/Dockerfile-nonroot static/simple-server/nonroot.patch
