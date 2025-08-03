#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/dotfiles"

echo "🗂️ Stowing dotfiles..."
chmod +x ./install.sh
./install.sh

echo "🐚 Ensuring zsh & oh-my-zsh exists..."
if ! command -v zsh >/dev/null; then sudo apt install -y zsh; fi
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
fi

echo "💬 Installing zsh-autosuggestions..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
grep -q zsh-autosuggestions "$HOME/.zshrc" \
  || sed -i.bak '/plugins=/ s/)/ zsh-autosuggestions)/' "$HOME/.zshrc"

echo "⚙️ Installing uv (Python manager)"...
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
echo "🐍 Installing Python 3.12 (default)..."
uv python install --default --preview-features python-install-default 3.12

echo "🪄 Installing Rust..."
command -v rustup >/dev/null && source "$HOME/.cargo/env" \
  || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source "$HOME/.cargo/env"

echo "🟩 Installing Node.js via nvm..."
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  . "$NVM_DIR/nvm.sh"
  nvm install --lts
fi

if [ "$SHELL" != "$(which zsh)" ]; then
  read -p "Do you want to set Zsh as your default shell? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s "$(which zsh)"
    echo "✅ Zsh set as default. Restart your terminal to apply changes."
  fi
fi

echo "🎉 Setup complete, run 'exec zsh' or restart your terminal to finish."
