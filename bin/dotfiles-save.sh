#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"

changed=0

sync_file() {
  local src="$1" dst="$2" label="$3"

  if [[ ! -f "${src}" ]]; then
    return
  fi

  mkdir -p "$(dirname "${dst}")"

  if ! cmp -s "${src}" "${dst}" 2>/dev/null; then
    cp -f "${src}" "${dst}"
    echo "  synced: ${label}"
    changed=1
  fi
}

echo "==> Saving live configs to dotfiles repo..."

sync_file "${HOME}/.claude/settings.json" \
          "${DOTFILES_DIR}/claude/settings.json" \
          "claude/settings.json"

sync_file "${HOME}/.config/ccstatusline/settings.json" \
          "${DOTFILES_DIR}/claude/ccstatusline.json" \
          "claude/ccstatusline.json"

if [[ "${changed}" -eq 0 ]]; then
  echo "  (no changes)"
fi
