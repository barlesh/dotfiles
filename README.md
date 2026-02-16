# Dotfiles

My personal dotfiles configuration for macOS.

## What's included

- **zsh** configuration (`.zshrc`, `.zprofile`, `.zshenv`)
- **Homebrew** package list (`Brewfile`)
- **Claude Code** settings and status line (ccstatusline)
- **iTerm2** profiles via Dynamic Profiles (font, colors, themes)
- **Bootstrap script** for automated setup

## Quick Start

```bash
# Clone this repository
git clone https://github.com/barlesh/dotfiles.git ~/dotfiles

# Run the bootstrap script
~/dotfiles/bin/bootstrap.sh
```

## Structure

```
dotfiles/
├── bin/
│   ├── bootstrap.sh        # Automated setup script
│   ├── dotfiles-save.sh    # Sync live configs back to repo
│   └── pre-commit          # Git hook source (auto-syncs on commit)
├── brew/
│   └── Brewfile            # Homebrew packages
├── claude/
│   ├── settings.json       # Claude Code settings (plugins, status line)
│   └── ccstatusline.json   # ccstatusline theme and widget config
├── iterm2/
│   └── profiles.json       # iTerm2 profiles (font, colors, themes)
├── home/                   # Files copied to $HOME
│   ├── zshrc
│   └── zprofile
└── zsh/                    # Additional zsh configs
    ├── zshrc
    ├── zprofile
    └── zshenv
```

## Saving config changes

When you change Claude Code, ccstatusline, or iTerm2 settings, sync them back to the repo:

```bash
~/dotfiles/bin/dotfiles-save.sh
```

A pre-commit hook also runs this automatically before each commit, so you
won't forget.

## Private Configuration

This repository excludes private configuration files. Create these locally if needed:
- `~/.zshrc.private` - Private zsh configuration
- `~/.zprofile.private` - Private environment variables
- `~/.claude/settings.local.json` - Claude Code permissions (machine-specific)

These files are automatically sourced if they exist but are never committed to git.

## License

MIT
