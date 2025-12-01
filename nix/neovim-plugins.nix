# Nix-managed Neovim plugins
#
# This file contains the plugin list converted from lazy-lock.json.
# Plugins are pinned to specific commits for reproducible builds.
#
# Plugin Mapping Strategy:
# - Plugins available in nixpkgs.vimPlugins are referenced directly (e.g., pkgs.vimPlugins.telescope-nvim)
# - Plugins not in nixpkgs are fetched from GitHub with pinned commits using buildVimPlugin
#
# To update plugin versions:
# 1. Update the lazy-lock.json using :Lazy update in Neovim
# 2. Re-run the conversion script or manually update rev values below
# 3. Update sha256 hashes by running: nix build .#neovim (Nix will report the correct hash)
#
# NOTE: Some plugins may require manual intervention if they have special build requirements.
# These are marked with TODO comments below.

{ pkgs }:

let
  # Helper function to build a vim plugin from GitHub
  buildVimPlugin = { pname, owner, repo, rev, sha256 }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname;
      version = builtins.substring 0 7 rev;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
    };

  # Plugins from lazy-lock.json mapped to nixpkgs or built from source
  # Last synced: lazy-lock.json commit hashes
in
{
  # Returns a list of plugins for use with programs.neovim.plugins or wrapNeovim
  plugins = [
    # ============================================
    # Core Utilities (available in nixpkgs)
    # ============================================
    pkgs.vimPlugins.plenary-nvim           # Lua utility library (dep for many plugins)
    pkgs.vimPlugins.nvim-web-devicons      # Icons support
    pkgs.vimPlugins.nui-nvim               # UI components library

    # ============================================
    # Completion & Snippets (available in nixpkgs)
    # ============================================
    pkgs.vimPlugins.nvim-cmp               # Completion engine
    pkgs.vimPlugins.cmp-nvim-lsp           # LSP completion source
    pkgs.vimPlugins.cmp-buffer             # Buffer completion source
    pkgs.vimPlugins.cmp-path               # Path completion source
    pkgs.vimPlugins.cmp-nvim-lua           # Neovim Lua API completion
    pkgs.vimPlugins.cmp_luasnip            # LuaSnip completion source
    pkgs.vimPlugins.luasnip                # Snippet engine (LuaSnip)
    pkgs.vimPlugins.friendly-snippets      # Snippet collection

    # ============================================
    # LSP & Language Support (available in nixpkgs)
    # ============================================
    pkgs.vimPlugins.nvim-lspconfig         # LSP configurations
    pkgs.vimPlugins.lspsaga-nvim           # LSP UI enhancements
    pkgs.vimPlugins.mason-nvim             # LSP/DAP/Linter installer

    # ============================================
    # Treesitter (available in nixpkgs)
    # ============================================
    # nvim-treesitter with all grammars for Nix builds
    (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
      p.lua p.vim p.vimdoc p.python
      p.javascript p.typescript p.html
      p.css p.json p.yaml p.bash
      p.markdown p.sql p.rust p.cpp
      p.nix  # Added nix grammar for completeness
    ]))
    pkgs.vimPlugins.nvim-treesitter-textobjects  # Treesitter text objects
    pkgs.vimPlugins.nvim-ts-autotag        # Auto close/rename HTML tags

    # ============================================
    # Fuzzy Finding (available in nixpkgs)
    # ============================================
    pkgs.vimPlugins.telescope-nvim         # Fuzzy finder
    pkgs.vimPlugins.telescope-fzf-native-nvim  # FZF sorter (native build)
    pkgs.vimPlugins.telescope-file-browser-nvim  # File browser extension

    # ============================================
    # UI & Theme (available in nixpkgs)
    # ============================================
    pkgs.vimPlugins.tokyonight-nvim        # Tokyo Night theme
    pkgs.vimPlugins.alpha-nvim             # Start screen
    pkgs.vimPlugins.bufferline-nvim        # Buffer tabs
    pkgs.vimPlugins.lualine-nvim           # Status line
    pkgs.vimPlugins.indent-blankline-nvim  # Indentation guides
    pkgs.vimPlugins.nvim-notify            # Notification manager
    pkgs.vimPlugins.noice-nvim             # UI for messages, cmdline, popupmenu

    # ============================================
    # Editor Enhancements (available in nixpkgs)
    # ============================================
    pkgs.vimPlugins.nvim-autopairs         # Auto pairs
    pkgs.vimPlugins.nvim-surround          # Surround text objects
    pkgs.vimPlugins.hop-nvim               # Easy motion
    pkgs.vimPlugins.nvim-tree-lua          # File explorer

    # ============================================
    # Language Specific (available in nixpkgs)
    # ============================================
    pkgs.vimPlugins.rust-vim               # Rust support

    # ============================================
    # Plugin Manager (NOT included in Nix build)
    # lazy.nvim is not included because:
    # 1. In Nix builds, plugins are managed by Nix, not lazy.nvim
    # 2. The existing lua config still uses lazy.nvim for the non-Nix workflow
    # ============================================
  ];

  # Optional: Export individual plugins for custom configurations
  inherit buildVimPlugin;

  # Plugin metadata for reference (from lazy-lock.json)
  # This can be used for tracking versions or generating updates
  pluginVersions = {
    # Core utilities
    plenary-nvim = "857c5ac632080dba10aae49dba902ce3abf91b35";
    nvim-web-devicons = "1fb58cca9aebbc4fd32b086cb413548ce132c127";
    nui-nvim = "de740991c12411b663994b2860f1a4fd0937c130";

    # Completion
    nvim-cmp = "b5311ab3ed9c846b585c0c15b7559be131ec4be9";
    cmp-nvim-lsp = "a8912b88ce488f411177fc8aed358b04dc246d7b";
    cmp-buffer = "b74fab3656eea9de20a9b8116afa3cfc4ec09657";
    cmp-path = "c6635aae33a50d6010bf1aa756ac2398a2d54c32";
    cmp-nvim-lua = "f12408bdb54c39c23e67cab726264c10db33ada8";
    cmp_luasnip = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90";
    luasnip = "5271933f7cea9f6b1c7de953379469010ed4553a";
    friendly-snippets = "572f5660cf05f8cd8834e096d7b4c921ba18e175";

    # LSP
    nvim-lspconfig = "a182334ba933e58240c2c45e6ae2d9c7ae313e00";
    lspsaga-nvim = "920b1253e1a26732e53fac78412f6da7f674671d";
    mason-nvim = "8024d64e1330b86044fed4c8494ef3dcd483a67c";

    # Treesitter
    nvim-treesitter = "42fc28ba918343ebfd5565147a42a26580579482";
    nvim-treesitter-textobjects = "0f051e9813a36481f48ca1f833897210dbcfffde";
    nvim-ts-autotag = "a1d526af391f6aebb25a8795cbc05351ed3620b5";

    # Telescope
    telescope-nvim = "a0bbec21143c7bc5f8bb02e0005fa0b982edc026";
    telescope-fzf-native-nvim = "1f08ed60cafc8f6168b72b80be2b2ea149813e55";
    telescope-file-browser-nvim = "626998e5c1b71c130d8bc6cf7abb6709b98287bb";

    # UI
    tokyonight-nvim = "057ef5d260c1931f1dffd0f052c685dcd14100a3";
    alpha-nvim = "a35468cd72645dbd52c0624ceead5f301c566dff";
    bufferline-nvim = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3";
    lualine-nvim = "a94fc68960665e54408fe37dcf573193c4ce82c9";
    indent-blankline-nvim = "005b56001b2cb30bfa61b7986bc50657816ba4ba";
    nvim-notify = "b5825cf9ee881dd8e43309c93374ed5b87b7a896";
    noice-nvim = "0427460c2d7f673ad60eb02b35f5e9926cf67c59";

    # Editor
    nvim-autopairs = "4d74e75913832866aa7de35e4202463ddf6efd1b";
    nvim-surround = "8dd9150ca7eae5683660ea20cec86edcd5ca4046";
    hop-nvim = "9c6a1dd9afb53a112b128877ccd583a1faa0b8b6";
    nvim-tree-lua = "1c733e8c1957dc67f47580fe9c458a13b5612d5b";

    # Language specific
    rust-vim = "889b9a7515db477f4cb6808bef1769e53493c578";

    # Plugin manager (not used in Nix build)
    lazy-nvim = "85c7ff3711b730b4030d03144f6db6375044ae82";
  };
}
