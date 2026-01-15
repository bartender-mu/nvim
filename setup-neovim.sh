#!/bin/bash

# Neovim Setup Script for Arch Linux
# This script installs all required system packages, LSP servers, formatters, and tools
# for seamless Neovim operation with Groovy/Jenkinsfile support.

set -e # Exit on any error

echo "Starting Neovim setup script..."

# Function to check if a package is installed
is_installed() {
	pacman -Q "$1" &>/dev/null
}

# Function to install packages
install_packages() {
	local packages=("$@")
	local to_install=()

	for pkg in "${packages[@]}"; do
		if ! is_installed "$pkg"; then
	 to_install+=("$pkg")
		else
	 echo "$pkg is already installed."
		fi
	done

	if [ ${#to_install[@]} -gt 0 ]; thenhere are some issues with your config. Run :LualineNotices for details
		echo "Installing: ${to_install[*]}"
		sudo pacman -S --noconfirm "${to_install[@]}"
	else
		echo "All packages are already installed."
	fi
}

# 1. Install system packages
echo "Installing system packages..."
SYSTEM_PACKAGES=(
	nodejs
	python
	go
	rust
	jdk-openjdk
	clang
	llvm
	ripgrep
	fzf
	lazygit
	base-devel
)

install_packages "${SYSTEM_PACKAGES[@]}"

# 2. Install Node.js global packages (formatters, linters)
echo "Installing Node.js global packages..."
sudo npm install -g npm-groovy-lint prettier eslint_d prettier_d

# 3. Install Python packages
echo "Installing Python packages..."
pip install black

# 4. Install Go tools
echo "Installing Go tools..."
go install golang.org/x/tools/cmd/goimports@latest
go install mvdan.cc/gofumpt@latest
go install github.com/mgechev/revive@latest

# 5. Install Rust tools (rustfmt is included with rust, but ensure)
echo "Rust tools: rustfmt is included with rust package."

# 6. Install Lua tools (stylua via cargo or mason)
echo "Installing Lua tools..."
cargo install stylua

# 7. Install LSP servers and formatters via Mason (requires Neovim)
echo "Installing LSP servers and additional formatters via Mason..."
# Note: This requires Neovim to be set up. Run after Neovim is configured.
nvim --headless -c "MasonInstall groovy-language-server gopls pyright lua_ls jsonls ts_ls bashls clangd dockerls emmet_ls yamlls tailwindcss solidity_ls_nomicfoundation efm" -c "qa"

# Additional formatters that Mason might handle or need manual install
echo "Additional formatters: prettier, black, rustfmt, goimports, shfmt should be handled by conform or installed above."

# 8. Verify installations
echo "Verifying installations..."
command -v node || echo "Node.js not found"
command -v python || echo "Python not found"
command -v go || echo "Go not found"
command -v rustc || echo "Rust not found"
command -v java || echo "Java not found"
command -v clang || echo "Clang not found"
command -v rg || echo "ripgrep not found"
command -v fzf || echo "fzf not found"
command -v lazygit || echo "lazygit not found"

echo "Neovim setup complete! Restart Neovim to load configurations."
