#!/usr/bin/env bash
set -euo pipefail

mode="${1:?Missing opener mode}"
target="${2:?Missing selected path}"
if [[ -d "$target" ]]; then
  directory="$target"
elif [[ -f "$target" ]]; then
  directory=$(dirname -- "$target")
else
  echo "OpenCode requires a local file or directory: $target" >&2
  exit 1
fi

command -v opencode >/dev/null || { echo "opencode is not on PATH" >&2; exit 1; }

case "$mode" in
  quit)
    if [[ -z "${YAZI_OPENCODE_FILE:-}" ]]; then
      echo "Launch Yazi with the Home Manager wrapper to use Open in OC and quit." >&2
      exit 1
    fi
    printf '%s\0' "$directory" > "$YAZI_OPENCODE_FILE"
    ya emit quit --code=90
    ;;
  pane)
    if [[ "${HERDR_ENV:-}" != 1 || -z "${HERDR_PANE_ID:-}" ]]; then
      echo "Open in OC in new pane requires a Herdr pane." >&2
      exit 1
    fi
    # --current targets the Yazi caller, not another client's focused pane.
    pane=$(herdr pane split --current --direction down --cwd "$directory" --focus \
      | jq -er '.result.pane.pane_id')
    herdr pane run "$pane" opencode >/dev/null
    ;;
  *)
    echo "Unknown OpenCode opener mode: $mode" >&2
    exit 1
    ;;
esac
