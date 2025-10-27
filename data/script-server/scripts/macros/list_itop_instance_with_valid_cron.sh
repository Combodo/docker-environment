#!/bin/bash

set -euo pipefail

# Mind the `-r` option of xargs to avoid error when no result is found
find /host_html/ -maxdepth 4 -path '*/webservices/cron.php' -exec dirname {} \; 2>/dev/null \
  | xargs -r -n1 dirname \
  | sed 's|/host_html/||g'