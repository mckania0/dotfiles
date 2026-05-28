#!/bin/bash
set -euo pipefail

echo "==> MacBook Bootstrap Start"

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
  eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null || true
fi
echo "==> Homebrew OK ($(brew --version | head -1))"

# 2. chezmoi
if ! command -v chezmoi &>/dev/null; then
  echo "==> Installing chezmoi..."
  brew install chezmoi
fi
echo "==> chezmoi OK ($(chezmoi --version))"

# 3. Dotfiles — SSH key musi być skonfigurowany przed uruchomieniem
# Setup: ssh-keygen -t ed25519 -C "your@email.com" && add to GitHub
echo "==> Applying dotfiles from mckania0/dotfiles..."
chezmoi init --apply github-personal:mckania0/dotfiles.git

# 4. Brew packages
echo "==> Installing packages from Brewfile..."
brew bundle --file="$HOME/.local/share/chezmoi/Brewfile"

echo ""
echo "==> Bootstrap complete!"
echo "    Remaining manual steps:"
echo "    - Restore credentials (.vmgateway, .jira, .datadog, etc.) from 1Password"
echo "    - gh auth login"
