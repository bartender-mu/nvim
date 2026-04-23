# AGENTS.md

## What this repo is

Personal NeoVim 0.12+ configuration (single `init.lua` file). Not a software project.

## Commands

```bash
luacheck .
```

## Dependencies

- NeoVim 0.12+ (AUR: `neovim-git`)
- tree-sitter-cli via cargo (runtime, not for config editing)
- golang (for efm-langserver)
- lua-jsregexp
- Standard tools: git, ripgrep, fzf, fd

## Setup

Copy `init.lua` to `~/.config/nvim/init.lua`.