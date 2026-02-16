#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dotfiles"

echo "==> Dotfiles dir: ${DOTFILES_DIR}"

# 0) Sanity
if [[ ! -d "${DOTFILES_DIR}" ]]; then
  echo "ERROR: ${DOTFILES_DIR} does not exist. Clone your repo to ~/dotfiles first."
  exit 1
fi

# 1) Backup existing shell configs (never overwrite blindly)
ts="$(date +%Y%m%d_%H%M%S)"
backup_dir="${HOME}/dotfiles_backup_${ts}"
mkdir -p "${backup_dir}"

for f in .zshrc .zprofile .zshenv .p10k.zsh; do
  if [[ -f "${HOME}/${f}" ]]; then
    cp -a "${HOME}/${f}" "${backup_dir}/"
  fi
done

echo "==> Backed up existing configs to: ${backup_dir}"

# 2) Ensure Homebrew exists (macOS)
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "==> Homebrew already installed."
fi

# 3) Ensure brew is on PATH for this script run (Apple Silicon + Intel)
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "==> brew: $(command -v brew)"

# 4) Install Brewfile packages if present
BREWFILE="${DOTFILES_DIR}/brew/Brewfile"
if [[ -r "${BREWFILE}" ]]; then
  echo "==> Installing packages from Brewfile..."
  brew bundle --file "${BREWFILE}"
else
  echo "==> No Brewfile at ${BREWFILE} (skipping packages)."
  echo "    (We'll add this next: dotfiles/brew/Brewfile)"
fi

# 5) Install home loaders (copy, not symlink: safest)
for pair in zshrc:.zshrc zprofile:.zprofile; do
  src="${DOTFILES_DIR}/home/${pair%%:*}"
  dst="${HOME}/${pair##*:}"

  if [[ ! -r "${src}" ]]; then
    echo "ERROR: missing ${src}"
    exit 1
  fi

  cp -f "${src}" "${dst}"
  echo "==> Installed ${dst} from ${src}"
done

# 6) Claude Code configuration
echo "==> Setting up Claude Code configs..."

mkdir -p "${HOME}/.claude"
mkdir -p "${HOME}/.config/ccstatusline"

CLAUDE_SETTINGS="${DOTFILES_DIR}/claude/settings.json"
CCSTATUSLINE_SETTINGS="${DOTFILES_DIR}/claude/ccstatusline.json"

if [[ -r "${CLAUDE_SETTINGS}" ]]; then
  cp -f "${CLAUDE_SETTINGS}" "${HOME}/.claude/settings.json"
  echo "==> Installed ~/.claude/settings.json"
fi

if [[ -r "${CCSTATUSLINE_SETTINGS}" ]]; then
  cp -f "${CCSTATUSLINE_SETTINGS}" "${HOME}/.config/ccstatusline/settings.json"
  echo "==> Installed ~/.config/ccstatusline/settings.json"
fi

# 7) Install pre-commit hook for auto-syncing configs
HOOK_SRC="${DOTFILES_DIR}/bin/pre-commit"
HOOK_DST="${DOTFILES_DIR}/.git/hooks/pre-commit"
if [[ -r "${HOOK_SRC}" ]]; then
  cp -f "${HOOK_SRC}" "${HOOK_DST}"
  chmod +x "${HOOK_DST}"
  echo "==> Installed pre-commit hook"
fi

echo "==> Done."
echo "Next: open a NEW terminal window and verify:"
echo "  - autosuggestions, fzf-tab"
echo "  - 'command -v brew'"
echo "  - 'command -v claude'"
