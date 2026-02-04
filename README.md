# Dotfiles

My personal dotfiles configuration for macOS.

## What's included

- **zsh** configuration (`.zshrc`, `.zprofile`, `.zshenv`)
- **Homebrew** package list (`Brewfile`)
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
│   └── bootstrap.sh      # Automated setup script
├── brew/
│   └── Brewfile          # Homebrew packages
├── home/                 # Files copied to $HOME
│   ├── zshrc
│   └── zprofile
└── zsh/                  # Additional zsh configs
    ├── zshrc
    ├── zprofile
    └── zshenv
```

## Private Configuration

This repository excludes private configuration files. Create these locally if needed:
- `~/.zshrc.private` - Private zsh configuration
- `~/.zprofile.private` - Private environment variables

These files are automatically sourced if they exist but are never committed to git.

## License

MIT
