# My Neovim Configuration

A personal Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

## Features

- **Plugin Management**: Uses lazy.nvim for fast, lazy-loading plugin management
- **LSP Support**: Built-in LSP configuration with Mason for easy language server installation
- **File Explorer**: Neo-tree with LazyVim-style appearance (tree view, rounded borders, custom icons)
- **Keybinding Guide**: Which-key for discoverable keybindings and command hints
- **Fuzzy Finding**: Telescope for file navigation and searching
- **Syntax Highlighting**: Tree-sitter for advanced syntax highlighting
- **UI Enhancements**: Tokyo Night theme, bufferline, lualine, and noice.nvim

## Quick Start

### Traditional Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone https://github.com/mgy583/my_neovim_config ~/.config/nvim
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
git clone https://github.com/mgy583/my_neovim_config
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

---

## Nix / NixOS (Flake + Locked Plugins)

This repository also supports **fully reproducible** Neovim builds with all plugins locked and managed by Nix. This approach "bakes in" all plugins at build time, ensuring identical environments across machines.

### How It Works

- Plugins are defined in `nix/neovim-plugins.nix` with pinned versions
- The `flake.lock` file pins the exact nixpkgs revision
- Plugins available in `nixpkgs.vimPlugins` use the stable nixpkgs versions
- Plugins not in nixpkgs can be fetched from GitHub with pinned `rev` and `sha256`

### Building Neovim with Baked-in Plugins

```bash
# Clone the repository
git clone https://github.com/mgy583/my_neovim_config
cd my_neovim_config

# Build Neovim with all plugins pre-installed
nix build .#neovim

# Run the built Neovim
./result/bin/nvim

# Or run directly without building first
nix run .#neovim
```

### Comparing Approaches

| Feature | `nix develop` (lazy.nvim) | `nix build .#neovim` (Nix plugins) |
|---------|---------------------------|-------------------------------------|
| Plugin Manager | lazy.nvim | Nix (vimPlugins) |
| Plugin Updates | `:Lazy update` | Update `nix/neovim-plugins.nix` |
| Lazy Loading | Yes | No (all plugins loaded at start) |
| Reproducibility | Via `lazy-lock.json` | Via `flake.lock` + pinned hashes |
| Internet Required | First run | Only during build |
| Best For | Development | Deployment, CI, NixOS systems |

### Refreshing Plugin Pins

To update the pinned plugins:

1. **Update lazy-lock.json** (if using lazy.nvim for updates):
   ```bash
   nix develop --command nvim --headless "+Lazy! update" +qa
   ```

2. **Update nix/neovim-plugins.nix**:
   - Copy the new commit SHAs from `lazy-lock.json` to the `rev` fields
   - Update the `sha256` hashes (Nix will show the expected hash on mismatch)
   - Or use nixpkgs versions which are automatically updated with nixpkgs

3. **Update nixpkgs** (optional):
   ```bash
   nix flake lock --update-input nixpkgs
   ```

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
    source = /path/to/your/neovim/config;  # Update this path
    recursive = true;
  };
}
```

For a fully Nix-managed approach with baked-in plugins:

```nix
# In your flake.nix inputs:
# inputs.my-neovim-config.url = "github:mgy583/my_neovim_config";

# In your home.nix
{ pkgs, inputs, ... }:
let
  # Reference this repository's flake (must be added to your flake inputs)
  neovim-config = inputs.my-neovim-config;
in
{
  # Use the pre-built Neovim with plugins
  home.packages = [
    neovim-config.packages.${pkgs.system}.neovim
    # Add runtime dependencies
    pkgs.ripgrep
    pkgs.fd
    pkgs.nodejs
    pkgs.python3
  ];
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

## Key Bindings

The configuration uses **which-key** to provide discoverable keybindings. Press `<leader>` (space) to see available commands.

### Main Keybinding Groups

- `<leader>e` - **Explorer**: File tree operations
  - `<leader>ee` - Toggle Neo-tree file explorer
  - `<leader>ef` - Focus Neo-tree
  - `<leader>er` - Reveal current file in Neo-tree

- `<leader>f` - **Find/File**: Fuzzy finding with Telescope
  - `<leader>ff` - Find files
  - `<leader>fg` - Live grep (search in files)
  - `<leader>fb` - Browse open buffers
  - `<leader>fh` - Search help tags
  - `<leader>fr` - Recent files
  - `<leader>fw` - Find word under cursor

- `<leader>l` - **LSP**: Language server operations
  - `<leader>ld` - Go to definition
  - `<leader>lD` - Go to declaration
  - `<leader>lh` - Hover documentation
  - `<leader>li` - Go to implementation
  - `<leader>lr` - Find references
  - `<leader>lR` - Rename symbol
  - `<leader>la` - Code action
  - `<leader>lf` - Format code

- `<leader>s` - **Split**: Window splitting
  - `<leader>sv` - Split vertical
  - `<leader>sh` - Split horizontal

- `<leader>b` - **Buffer**: Buffer management
  - `<leader>bd` - Delete buffer
  - `<leader>bn` - Next buffer
  - `<leader>bp` - Previous buffer

- `<leader>g` - **Git**: Git operations via Telescope
  - `<leader>gs` - Git status
  - `<leader>gc` - Git commits
  - `<leader>gb` - Git branches

- `<leader>w` - **Window**: Window navigation
  - `<leader>wh/j/k/l` - Move to left/down/up/right window
  - `<leader>wc` - Close window
  - `<leader>wo` - Close other windows

- `<leader>t` - **Terminal/Tab**: Terminal and tab management
  - `<leader>tt` - Open terminal
  - `<leader>tn` - New tab
  - `<leader>tc` - Close tab

### Neo-tree Navigation

Once Neo-tree is open, you can use:
- `<CR>` or `l` - Open file/directory
- `<space>` - Toggle directory node
- `a` - Add file
- `A` - Add directory
- `d` - Delete
- `r` - Rename
- `s` - Open in vertical split
- `S` - Open in horizontal split
- `q` - Close Neo-tree
- `?` - Show help

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
├── lazy-lock.json        # Plugin lockfile (lazy.nvim)
├── flake.nix             # Nix flake configuration
├── flake.lock            # Locked nixpkgs version
└── nix/
    └── neovim-plugins.nix  # Pinned plugin definitions for Nix
```

## License

This configuration is provided as-is for personal use. Feel free to fork and customize.
