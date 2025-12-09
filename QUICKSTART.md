# Quick Start Guide

This guide will help you get started with this Neovim configuration quickly.

## Installation

### Method 1: Traditional Installation

1. **Backup your existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/mgy583/my_neovim_config ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```
   
   On first launch, lazy.nvim will automatically install all plugins. This may take a few minutes.

### Method 2: Nix/NixOS

See the main [README.md](README.md) for Nix-specific installation instructions.

## First Steps

### 1. Wait for Plugin Installation
On first launch, you'll see lazy.nvim installing all plugins. Wait for it to complete.

### 2. Install LSP Servers
After plugins are installed, you'll want to install language servers:

1. Open Neovim and run `:Mason`
2. Press `i` to install a language server
3. Common servers to install:
   - `lua-language-server` (Lua)
   - `pyright` (Python)
   - `typescript-language-server` (TypeScript/JavaScript)
   - `rust-analyzer` (Rust)
   - `clangd` (C/C++)

Or let LSP auto-install when you open a file of a supported language.

### 3. Learn the Keybindings

#### Essential Keybindings
- **Leader key**: `<Space>` (most commands start with this)
- **Exit insert mode**: `jk` or `<ESC>`
- **Save file**: `:w<Enter>`
- **Quit**: `:q<Enter>`

#### File Navigation
- `<leader>ee` - Toggle file explorer (Neo-tree)
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Search in files (Live grep)

#### Code Editing
- `gcc` - Toggle line comment
- `<leader>ca` - Code actions (LSP)
- `<leader>cf` - Format code
- `gd` - Go to definition

#### Terminal
- `<leader>tt` - Toggle terminal
- `<leader>tf` - Float terminal

#### Git
- `]c` / `[c` - Next/previous git hunk
- `<leader>gp` - Preview hunk
- `<leader>gs` - Stage hunk

For a complete list, see [KEYBINDINGS.md](KEYBINDINGS.md).

### 4. Discover More with Which-key
Press `<leader>` (space) and wait a moment. A popup will show you all available keybindings starting with the leader key!

## Customization

### Change Color Scheme
The default theme is Tokyo Night. To change it:
1. Edit `lua/plugins/tokyonight.lua`
2. Or install a different theme plugin in `lua/plugins/`

### Add Language Support
1. Open `:Mason` and install the language server
2. The LSP config in `lua/plugins/lsp.lua` should auto-configure most servers
3. For custom configs, edit `lua/plugins/lsp.lua`

### Adjust Keybindings
Edit `lua/core/keymaps.lua` to add or modify keybindings.

## Troubleshooting

### Plugins Not Loading
- Run `:Lazy sync` to reinstall plugins
- Check `:Lazy` for any error messages

### LSP Not Working
- Make sure the language server is installed via `:Mason`
- Check `:LspInfo` to see active language servers
- Some servers need additional system dependencies

### Terminal Not Working
- Make sure your terminal supports true colors
- Set `$TERM` to `xterm-256color` or similar

### Formatting Not Working
- Install formatters via Mason or system package manager
- Check `lua/plugins/none-ls.lua` for configured formatters
- Run `:NullLsInfo` (or `:NoneLsInfo`) to see active formatters

## Getting Help

### Within Neovim
- `:help` - Neovim help
- `:Lazy` - Plugin manager interface
- `:Mason` - LSP server manager
- `:checkhealth` - System health check

### Documentation
- [README.md](README.md) - Full documentation
- [KEYBINDINGS.md](KEYBINDINGS.md) - Complete keybinding reference
- This file - Quick start guide

## Next Steps

1. **Learn Neovim motions**: Run `vimtutor` in your terminal
2. **Customize**: Adjust settings in `lua/core/options.lua`
3. **Add plugins**: Create new files in `lua/plugins/`
4. **Explore**: Press `<leader>` and explore the which-key popup

Enjoy your new Neovim setup! 🎉
