#!/usr/bin/env bash
set -euo pipefail

# A private handoff file lets every launch (including yy) exit before starting OC.
handoff=$(mktemp -t yazi-opencode.XXXXXX)
trap 'rm -f -- "$handoff"' EXIT
export YAZI_OPENCODE_FILE="$handoff"

status=0
"$YAZI_REAL_BIN" "$@" || status=$?

# Exit 90 is reserved for the OC opener; ordinary exits keep their exact status.
if [[ "$status" == 90 && -s "$handoff" ]]; then
  IFS= read -r -d '' directory < "$handoff"
  rm -f -- "$handoff"
  trap - EXIT
  unset YAZI_OPENCODE_FILE YAZI_REAL_BIN
  cd -- "$directory"
  exec opencode "$directory"
fi

exit "$status"
