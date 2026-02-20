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

sync_file "${HOME}/.p10k.zsh" \
          "${DOTFILES_DIR}/zsh/p10k.zsh" \
          "zsh/p10k.zsh"

# iTerm2 profiles: export from plist to Dynamic Profile JSON
ITERM_PLIST="${HOME}/Library/Preferences/com.googlecode.iterm2.plist"
ITERM_DST="${DOTFILES_DIR}/iterm2/profiles.json"
if [[ -f "${ITERM_PLIST}" ]]; then
  mkdir -p "$(dirname "${ITERM_DST}")"
  tmp="$(mktemp)"
  python3 -c "
import plistlib, json, base64, sys

def make_serializable(obj):
    if isinstance(obj, bytes):
        return base64.b64encode(obj).decode('ascii')
    elif isinstance(obj, dict):
        return {k: make_serializable(v) for k, v in obj.items()}
    elif isinstance(obj, list):
        return [make_serializable(v) for v in obj]
    return obj

with open('${ITERM_PLIST}', 'rb') as f:
    data = plistlib.load(f)
profiles = data.get('New Bookmarks', [])
with open('${tmp}', 'w') as f:
    json.dump({'Profiles': [make_serializable(p) for p in profiles]}, f, indent=2)
" 2>/dev/null
  if [[ -f "${tmp}" ]] && ! cmp -s "${tmp}" "${ITERM_DST}" 2>/dev/null; then
    mv "${tmp}" "${ITERM_DST}"
    echo "  synced: iterm2/profiles.json"
    changed=1
  else
    rm -f "${tmp}"
  fi

  # iTerm2 global key bindings
  GKEYMAP_DST="${DOTFILES_DIR}/iterm2/global-keymap.json"
  tmp2="$(mktemp)"
  python3 -c "
import plistlib, json, sys

with open('${ITERM_PLIST}', 'rb') as f:
    data = plistlib.load(f)
gkm = data.get('GlobalKeyMap', {})
if gkm:
    with open('${tmp2}', 'w') as f:
        json.dump(gkm, f, indent=2)
" 2>/dev/null
  if [[ -s "${tmp2}" ]] && ! cmp -s "${tmp2}" "${GKEYMAP_DST}" 2>/dev/null; then
    mv "${tmp2}" "${GKEYMAP_DST}"
    echo "  synced: iterm2/global-keymap.json"
    changed=1
  else
    rm -f "${tmp2}"
  fi
fi

if [[ "${changed}" -eq 0 ]]; then
  echo "  (no changes)"
fi
