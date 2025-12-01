# My Neovim Configuration

A personal Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Features

- **Plugin Management**: Uses lazy.nvim for fast, lazy-loading plugin management
- **LSP Support**: Built-in LSP configuration with Mason for easy language server installation
- **Fuzzy Finding**: Telescope for file navigation and searching
- **Syntax Highlighting**: Tree-sitter for advanced syntax highlighting
- **UI Enhancements**: Tokyo Night theme, bufferline, lualine, and noice.nvim

## Quick Start

### Traditional Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone https://github.com/mgy583/my_neovim_config.git ~/.config/nvim
   ```

2. Open Neovim - lazy.nvim will automatically bootstrap and install plugins:
   ```bash
   nvim
   ```

---

## Nix / NixOS

This repository includes a Nix flake for reproducible development environments. The flake provides:

- A **development shell** with Neovim and all necessary dependencies
- An optional **Neovim package** for standalone builds
- Automatic configuration of `XDG_CONFIG_HOME` so Neovim uses this repo's config

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Enable flakes by adding to `~/.config/nix/nix.conf`:
  ```
  experimental-features = nix-command flakes
  ```

### Using the Development Shell

Enter the development shell which provides Neovim configured to use this repository:

```bash
# Clone the repository
git clone https://github.com/mgy583/my_neovim_config.git
cd my_neovim_config

# Enter the development shell
nix develop

# Run Neovim (it will use this repo's config automatically)
nvim
```

The shell includes:
- Neovim
- ripgrep, fd, git (for Telescope and general usage)
- Build tools (gcc, make, pkg-config) for native plugins
- Lua, Node.js, Python for various plugins and LSP servers
- Tree-sitter CLI for grammar compilation

### Building Neovim Package

Build a standalone Neovim package:

```bash
# Build Neovim
nix build .#neovim

# Run the built Neovim
./result/bin/nvim
```

### Flake Commands Reference

| Command | Description |
|---------|-------------|
| `nix develop` | Enter the development shell |
| `nix build .#neovim` | Build Neovim package |
| `nix flake check` | Validate the flake configuration |
| `nix flake show` | Show available flake outputs |

### Home Manager Integration (Optional)

If you want to manage this configuration with Home Manager, you can reference the flake's Neovim package or create a custom module. Here's a basic example:

```nix
# In your home.nix or home-manager configuration
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    # Use the system Neovim and point to your config
    extraPackages = with pkgs; [
      ripgrep
      fd
      nodejs
    ];
  };

  # Symlink this config to ~/.config/nvim
  xdg.configFile."nvim" = {
    source = /path/to/my_neovim_config;
    recursive = true;
  };
}
```

### Keeping lazy.nvim Plugin Manager

This flake is designed to work alongside lazy.nvim. The plugin manager handles:
- Plugin installation and updates
- Lazy loading optimization
- Plugin lockfile (`lazy-lock.json`)

Nix provides the system dependencies while lazy.nvim manages Neovim plugins. This gives you:
- Reproducible system environment via Nix
- Familiar plugin management workflow
- Easy updates with `:Lazy update`

### Troubleshooting

#### Luarocks / Native Module Issues

This configuration has Luarocks disabled in lazy.nvim:
```lua
rocks = {
    hererocks = false,
    enabled = false
}
```

If you need Luarocks support, you may need to adjust the lazy.nvim configuration and add `luarocks` to the devShell packages.

#### First Run Plugin Installation

On first run, lazy.nvim will clone and install all plugins. Ensure you have internet access and wait for the installation to complete.

#### Permission Issues

If you encounter permission errors:
- Ensure the repository is cloned to a writable location
- Check that `~/.local/share/nvim` is writable (for plugin data)
- The devShell creates a temporary symlink; ensure parent directories exist

#### Headless Installation

To install plugins headlessly (useful for CI/scripts):
```bash
nix develop --command nvim --headless "+Lazy! sync" +qa
```

#### Mason LSP Servers

Mason manages LSP server installations independently. If Mason-installed servers don't work:
1. Ensure the required build tools are available (the devShell provides common ones)
2. Run `:Mason` to check installation status
3. Some servers may need additional system dependencies not in the devShell

---

## Configuration Structure

```
.
├── init.lua              # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua   # Neovim options
│   │   ├── keymaps.lua   # Key mappings
│   │   └── lazy.lua      # Plugin manager setup
│   └── plugins/          # Plugin configurations
├── lazy-lock.json        # Plugin lockfile
└── flake.nix            # Nix flake configuration
```

## License

This configuration is provided as-is for personal use. Feel free to fork and customize.
