# My Neovim Configuration

A personal Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager, with optional Nix-based reproducible builds.

## Features

- **Plugin Management**: Uses lazy.nvim for fast, lazy-loading plugin management
- **LSP Support**: Built-in LSP configuration with Mason for easy language server installation
- **Fuzzy Finding**: Telescope for file navigation and searching
- **Syntax Highlighting**: Tree-sitter for advanced syntax highlighting
- **UI Enhancements**: Tokyo Night theme, bufferline, lualine, and noice.nvim
- **Nix Support**: Flake-based reproducible builds with locked plugin versions

## Quick Start

### Traditional Installation

1. Clone this repository to your Neovim config directory:
   ```bash
   git clone <repository-url> ~/.config/nvim
   ```

2. Open Neovim - lazy.nvim will automatically bootstrap and install plugins:
   ```bash
   nvim
   ```

---

## Nix / NixOS (Flake + Locked Plugins)

This repository includes a comprehensive Nix flake that provides **two workflows**:

1. **Development Shell** (`nix develop`): Traditional lazy.nvim workflow with Nix-provided dependencies
2. **Nix-Built Neovim** (`nix build .#neovim`): Fully reproducible Neovim with plugins baked in via Nix

### Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Enable flakes by adding to `~/.config/nix/nix.conf`:
  ```
  experimental-features = nix-command flakes
  ```

### Quick Commands

```bash
# Enter development shell (lazy.nvim manages plugins)
nix develop

# Build Neovim with plugins baked in
nix build .#neovim

# Run the Nix-built Neovim
./result/bin/nvim

# Validate the flake
nix flake check

# Show all available outputs
nix flake show
```

### Option 1: Development Shell (lazy.nvim Workflow)

The development shell provides Neovim and all system dependencies, while lazy.nvim manages plugins at runtime:

```bash
# Clone and enter the repository
git clone <repository-url>
cd my_neovim_config

# Enter the development shell
nix develop

# Run Neovim (lazy.nvim will install plugins on first run)
nvim
```

**Included tools:**
- Neovim, ripgrep, fd, git
- Build tools (gcc, make, pkg-config)
- Lua 5.1, LuaJIT, Luarocks
- Node.js, Python 3, Tree-sitter CLI

### Option 2: Nix-Built Neovim (Fully Reproducible)

Build a standalone Neovim package with all plugins pre-installed via Nix:

```bash
# Build Neovim with all plugins
nix build .#neovim

# Run the built Neovim
./result/bin/nvim

# Or run directly without building first
nix run .#neovim
```

**Benefits of Nix-built Neovim:**
- 100% reproducible builds
- All plugins locked via nixpkgs pinning
- No network access needed after build
- Fast startup (plugins are pre-compiled)

### Plugin Locking Strategy

Plugins are locked through two mechanisms:

| Mechanism | File | Purpose |
|-----------|------|---------|
| **nixpkgs pin** | `flake.lock` | Locks all `pkgs.vimPlugins.*` versions |
| **lazy.nvim** | `lazy-lock.json` | Locks plugins for traditional workflow |

The Nix plugin list in `nix/neovim-plugins.nix` maps lazy.nvim plugins to their nixpkgs equivalents. All 33+ plugins are available in `pkgs.vimPlugins`.

### Updating Plugin Versions

**For Nix workflow:**
```bash
# Update nixpkgs (updates all plugins)
nix flake update

# Rebuild to get new versions
nix build .#neovim

# Commit the lock file
git add flake.lock && git commit -m "Update nixpkgs"
```

**For lazy.nvim workflow:**
```bash
# Inside nix develop or with Neovim installed
nvim --headless "+Lazy! update" +qa

# Commit the lock file
git add lazy-lock.json && git commit -m "Update plugins"
```

### Home Manager Integration

#### Option A: Import the Home Manager Module

```nix
# In your flake.nix inputs
inputs.my-neovim.url = "github:<owner>/my_neovim_config";

# In your home.nix or home-manager configuration
{ inputs, pkgs, ... }:
{
  imports = [ inputs.my-neovim.homeModules.default ];

  # The module provides:
  # - programs.neovim.enable = true
  # - programs.neovim.plugins = <all plugins from nix/neovim-plugins.nix>
  # - programs.neovim.extraPackages = [ ripgrep fd git tree-sitter nodejs python3 ]
}
```

#### Option B: Use the Package Directly

```nix
{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.my-neovim.packages.${pkgs.system}.neovim
  ];

  # Symlink config files
  xdg.configFile."nvim" = {
    source = inputs.my-neovim;
    recursive = true;
  };
}
```

#### Option C: Custom Plugin Selection

```nix
{ pkgs, ... }:
let
  neovimPlugins = import "${inputs.my-neovim}/nix/neovim-plugins.nix" { inherit pkgs; };
in
{
  programs.neovim = {
    enable = true;
    plugins = neovimPlugins.plugins;
    extraPackages = with pkgs; [ ripgrep fd git ];
  };
}
```

### NixOS Integration

Add to your NixOS configuration:

```nix
# In your flake.nix
{
  inputs.my-neovim.url = "github:<owner>/my_neovim_config";
}

# In configuration.nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.my-neovim.packages.${pkgs.system}.neovim
  ];
}
```

### Flake Commands Reference

| Command | Description |
|---------|-------------|
| `nix develop` | Enter development shell (lazy.nvim workflow) |
| `nix build .#neovim` | Build Neovim with plugins baked in |
| `nix run .#neovim` | Build and run Neovim |
| `nix flake check` | Validate the flake configuration |
| `nix flake show` | Show all available flake outputs |
| `nix flake update` | Update nixpkgs (and all plugins) |

### Plugin Conversion Notes

All plugins from `lazy-lock.json` have been mapped to their nixpkgs equivalents:

| Category | Plugins | Source |
|----------|---------|--------|
| Core | plenary, nvim-web-devicons, nui | `pkgs.vimPlugins` |
| Completion | nvim-cmp, cmp-*, luasnip, friendly-snippets | `pkgs.vimPlugins` |
| LSP | nvim-lspconfig, lspsaga, mason | `pkgs.vimPlugins` |
| Treesitter | nvim-treesitter (with grammars), textobjects, autotag | `pkgs.vimPlugins` |
| Telescope | telescope, fzf-native, file-browser | `pkgs.vimPlugins` |
| UI | tokyonight, alpha, bufferline, lualine, indent-blankline, notify, noice | `pkgs.vimPlugins` |
| Editor | autopairs, surround, hop, nvim-tree | `pkgs.vimPlugins` |
| Language | rust.vim | `pkgs.vimPlugins` |

**Note:** `lazy.nvim` itself is NOT included in the Nix build since Nix manages plugins directly.

### Compatibility Notes

1. **Mason LSP Servers**: Mason-installed LSP servers work in both workflows. The devShell provides necessary build tools.

2. **Treesitter Grammars**: The Nix build includes pre-compiled grammars. The lazy.nvim workflow compiles them on first use.

3. **Native Plugins**: `telescope-fzf-native` requires compilation. Both workflows handle this:
   - Nix: Pre-compiled via nixpkgs
   - lazy.nvim: Compiled on install via `build = "make"`

4. **Luarocks**: Disabled in this config. If needed, enable in `lua/core/lazy.lua` and add `luarocks` to devShell.

### Troubleshooting

#### Build Failures

```bash
# Check flake syntax
nix flake check

# Show detailed build logs
nix build .#neovim -L

# Test in isolation
nix develop -c nvim --version
```

#### Plugin Not Found

If a plugin is missing from nixpkgs, add it to `nix/neovim-plugins.nix`:

```nix
# Use buildVimPlugin for custom plugins
(buildVimPlugin {
  pname = "my-plugin";
  owner = "github-owner";
  repo = "plugin-repo";
  rev = "commit-sha";
  sha256 = ""; # Run nix build, Nix will tell you the correct hash
})
```

#### Config Not Loading

Ensure `XDG_CONFIG_HOME` points to the config directory:

```bash
# In nix develop, this is set automatically
echo $XDG_CONFIG_HOME

# For nix build output, set manually or symlink:
ln -s /path/to/my_neovim_config ~/.config/nvim
./result/bin/nvim
```

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
├── nix/
│   └── neovim-plugins.nix # Nix plugin definitions (converted from lazy-lock.json)
├── lazy-lock.json        # Plugin lockfile (lazy.nvim)
├── flake.nix             # Nix flake configuration
└── flake.lock            # Nixpkgs version lock
```

## License

This configuration is provided as-is for personal use. Feel free to fork and customize.
