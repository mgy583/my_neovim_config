# nix/neovim-plugins.nix
#
# This file contains all Neovim plugins pinned with their exact commit SHA and hash.
# These plugins are converted from the lazy-lock.json file for reproducible builds.
#
# Plugin Mapping:
# - Plugins available in nixpkgs vimPlugins are referenced directly when possible
# - Plugins not in nixpkgs are fetched from GitHub with pinned rev and sha256
#
# To update plugins:
# 1. Update lazy-lock.json using `:Lazy update` in Neovim
# 2. Run the update script or manually update the revs and hashes below
# 3. Run `nix flake lock --update-input nixpkgs` to update nixpkgs if needed
#
# Note: Some plugins may need manual attention if they have native dependencies
# or require special build steps.

{ pkgs, lib, ... }:

let
  # Helper function to build a plugin from GitHub
  buildPlugin = { owner, repo, rev, sha256, ... }@args:
    pkgs.vimUtils.buildVimPlugin ({
      pname = repo;
      version = rev;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
    } // (builtins.removeAttrs args [ "owner" "repo" "rev" "sha256" ]));

  # Helper for plugins that need to skip build steps
  buildPluginNoCheck = args: buildPlugin (args // { doCheck = false; });

in
{
  # ============================================================================
  # PLUGINS AVAILABLE IN NIXPKGS
  # ============================================================================
  # These plugins are available in pkgs.vimPlugins and will use nixpkgs versions
  # for better integration. Consider using these for stability.

  nixpkgsPlugins = with pkgs.vimPlugins; [
    # Core dependencies
    plenary-nvim
    nvim-web-devicons

    # Telescope ecosystem
    telescope-nvim
    telescope-fzf-native-nvim
    telescope-file-browser-nvim

    # Treesitter ecosystem
    nvim-treesitter.withAllGrammars
    nvim-treesitter-textobjects

    # LSP ecosystem
    nvim-lspconfig
    lspsaga-nvim

    # Completion ecosystem
    nvim-cmp
    cmp-buffer
    cmp-path
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp_luasnip
    luasnip
    friendly-snippets

    # UI plugins
    tokyonight-nvim
    bufferline-nvim
    lualine-nvim
    alpha-nvim
    indent-blankline-nvim
    noice-nvim
    nui-nvim
    nvim-notify

    # Editor enhancements
    nvim-autopairs
    nvim-surround
    hop-nvim

    # File explorer
    nvim-tree-lua

    # Language specific
    rust-vim

    # Auto tags
    nvim-ts-autotag

    # Mason (for LSP server management)
    mason-nvim
  ];

  # ============================================================================
  # PINNED PLUGINS FROM LAZY-LOCK.JSON
  # ============================================================================
  # These are pinned to exact commits from lazy-lock.json for reproducibility.
  # Use these when you need exact version matching with your lazy.nvim setup.

  pinnedPlugins = [
    # lazy.nvim - Plugin manager (usually not needed in Nix-managed setup)
    # Included for reference but typically bootstrapped by lazy.nvim itself
    (buildPluginNoCheck {
      owner = "folke";
      repo = "lazy.nvim";
      rev = "85c7ff3711b730b4030d03144f6db6375044ae82";
      sha256 = "sha256-KH4DNMFP5cWryV22iGaHTp21NjaxGJEUhFtjhB/JD6M=";
    })

    # plenary.nvim - Lua utility functions
    (buildPluginNoCheck {
      owner = "nvim-lua";
      repo = "plenary.nvim";
      rev = "857c5ac632080dba10aae49dba902ce3abf91b35";
      sha256 = "sha256-06Bo9/C/46K7t9OXaGzIgPOW/qcH8cEEcrPXt76QhCU=";
    })

    # nvim-web-devicons - File icons
    (buildPluginNoCheck {
      owner = "nvim-tree";
      repo = "nvim-web-devicons";
      rev = "1fb58cca9aebbc4fd32b086cb413548ce132c127";
      sha256 = "sha256-y3VzIMgPW4G7Nz8I7HxBqjBkWqDWGm2aCf/fMTt4yf4=";
    })

    # telescope.nvim - Fuzzy finder
    (buildPluginNoCheck {
      owner = "nvim-telescope";
      repo = "telescope.nvim";
      rev = "a0bbec21143c7bc5f8bb02e0005fa0b982edc026";
      sha256 = "sha256-7rsfqpHqHLV38u1IEaRqVcpDRW6RNPkPUpVDk0DRUeg=";
    })

    # telescope-fzf-native.nvim - FZF sorter for telescope
    (buildPluginNoCheck {
      owner = "nvim-telescope";
      repo = "telescope-fzf-native.nvim";
      rev = "1f08ed60cafc8f6168b72b80be2b2ea149813e55";
      sha256 = "sha256-pNLYnsvAwgb4IvqIptGpKE/M/qIoAzZ6/Q5U04ubgZg=";
      # Note: This plugin requires native compilation
      # The nixpkgs version handles this automatically
      buildPhase = "make";
    })

    # telescope-file-browser.nvim - File browser extension
    (buildPluginNoCheck {
      owner = "nvim-telescope";
      repo = "telescope-file-browser.nvim";
      rev = "626998e5c1b71c130d8bc6cf7abb6709b98287bb";
      sha256 = "sha256-eLPB58jB2jcBaWCEzlOjLZzpDCdjBuL/B6jHHj+q33E=";
    })

    # nvim-treesitter - Syntax highlighting and parsing
    (buildPluginNoCheck {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "42fc28ba918343ebfd5565147a42a26580579482";
      sha256 = "sha256-r+HjWC+s6xb+BoHI7pzYEZNvGE6OggOmXd4XIfxh8+A=";
    })

    # nvim-treesitter-textobjects - Treesitter text objects
    (buildPluginNoCheck {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter-textobjects";
      rev = "0f051e9813a36481f48ca1f833897210dbcfffde";
      sha256 = "sha256-i16M8fsCxEELMz85LLu2/tY0UJLYu9nX9rLqTlXKKQQ=";
    })

    # nvim-ts-autotag - Auto close and rename HTML tags
    (buildPluginNoCheck {
      owner = "windwp";
      repo = "nvim-ts-autotag";
      rev = "a1d526af391f6aebb25a8795cbc05351ed3620b5";
      sha256 = "sha256-Lak/cGqJB2nD5n8sOFJPAMvqqNKkOgdxYl3B6cOmA54=";
    })

    # nvim-lspconfig - LSP configuration
    (buildPluginNoCheck {
      owner = "neovim";
      repo = "nvim-lspconfig";
      rev = "a182334ba933e58240c2c45e6ae2d9c7ae313e00";
      sha256 = "sha256-Y6GQnVVGOJhLXZdKTN/gVKJMiW31PZvp/E8uf2gkz5E=";
    })

    # lspsaga.nvim - LSP UI enhancements
    (buildPluginNoCheck {
      owner = "glepnir";
      repo = "lspsaga.nvim";
      rev = "920b1253e1a26732e53fac78412f6da7f674671d";
      sha256 = "sha256-8+yqfPe5G6W0DQaGFfW5eF7uGVGbE0Yjd8a+nKJq7T8=";
    })

    # mason.nvim - LSP/DAP/Linter/Formatter manager
    (buildPluginNoCheck {
      owner = "williamboman";
      repo = "mason.nvim";
      rev = "8024d64e1330b86044fed4c8494ef3dcd483a67c";
      sha256 = "sha256-h+YP4+CQKjnECR+n8j6d0vpDV8n6/m+J2mJnpLlb+Eg=";
    })

    # nvim-cmp - Completion engine
    (buildPluginNoCheck {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "b5311ab3ed9c846b585c0c15b7559be131ec4be9";
      sha256 = "sha256-D6L7FXF7ZnSk0n9xhEy/1+2LqbLMBjVYcQMdkwL67JY=";
    })

    # cmp-buffer - Buffer completion source
    (buildPluginNoCheck {
      owner = "hrsh7th";
      repo = "cmp-buffer";
      rev = "b74fab3656eea9de20a9b8116afa3cfc4ec09657";
      sha256 = "sha256-3UDsZCWR7gb+IqLzL44sCAbYl8f/0q9djmFsLfaWwo4=";
    })

    # cmp-path - Path completion source
    (buildPluginNoCheck {
      owner = "hrsh7th";
      repo = "cmp-path";
      rev = "c6635aae33a50d6010bf1aa756ac2398a2d54c32";
      sha256 = "sha256-kJFdYbPUVgkHvN6OJQdVLlz2tIX4PF+F7kFn4fRnuSw=";
    })

    # cmp-nvim-lsp - LSP completion source
    (buildPluginNoCheck {
      owner = "hrsh7th";
      repo = "cmp-nvim-lsp";
      rev = "a8912b88ce488f411177fc8aed358b04dc246d7b";
      sha256 = "sha256-J9LYT3hVB2V3WN1i/RD0sVlNlVfF4WdHAXLT6kCmYfg=";
    })

    # cmp-nvim-lua - Neovim Lua API completion source
    (buildPluginNoCheck {
      owner = "hrsh7th";
      repo = "cmp-nvim-lua";
      rev = "f12408bdb54c39c23e67cab726264c10db33ada8";
      sha256 = "sha256-VDLBk5t35tn6YXGg3pXYyE6dFGGM3Z5z1Yv5i2HKY2E=";
    })

    # cmp_luasnip - LuaSnip completion source
    (buildPluginNoCheck {
      owner = "saadparwaiz1";
      repo = "cmp_luasnip";
      rev = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90";
      sha256 = "sha256-UdJz9CwAdMkFGr8n11qICnVTbA+DXOQyeZJbG0drgYc=";
    })

    # LuaSnip - Snippet engine
    (buildPluginNoCheck {
      owner = "L3MON4D3";
      repo = "LuaSnip";
      rev = "5271933f7cea9f6b1c7de953379469010ed4553a";
      sha256 = "sha256-lmYJQJixSmJv67A1K1vWi2R3f1Z8cKu99YjLzM8l8So=";
    })

    # friendly-snippets - Snippet collection
    (buildPluginNoCheck {
      owner = "rafamadriz";
      repo = "friendly-snippets";
      rev = "572f5660cf05f8cd8834e096d7b4c921ba18e175";
      sha256 = "sha256-1XOQsB+JOW8o9LVBH5Ee0zs2nEuLqHR2TQGZ3RxM3QA=";
    })

    # tokyonight.nvim - Color scheme
    (buildPluginNoCheck {
      owner = "folke";
      repo = "tokyonight.nvim";
      rev = "057ef5d260c1931f1dffd0f052c685dcd14100a3";
      sha256 = "sha256-J6RH5oy7Y8b8eU+0VeLGKP8nNTuLqdCdBLfJP/V5fOM=";
    })

    # bufferline.nvim - Buffer line
    (buildPluginNoCheck {
      owner = "akinsho";
      repo = "bufferline.nvim";
      rev = "655133c3b4c3e5e05ec549b9f8cc2894ac6f51b3";
      sha256 = "sha256-dXE8xpBaBHD6Qy6Yg9qwH7f+o/4LGWvJKdLFqJUVZX8=";
    })

    # lualine.nvim - Status line
    (buildPluginNoCheck {
      owner = "nvim-lualine";
      repo = "lualine.nvim";
      rev = "a94fc68960665e54408fe37dcf573193c4ce82c9";
      sha256 = "sha256-h4MK1mMwPyEL7DZMYr0VGAoMwj2VfP8a5RprZwsHyoA=";
    })

    # alpha-nvim - Dashboard
    (buildPluginNoCheck {
      owner = "goolord";
      repo = "alpha-nvim";
      rev = "a35468cd72645dbd52c0624ceead5f301c566dff";
      sha256 = "sha256-Rh7kKQzT2Rjn5iCLg9Cr1eXXmZJJk4aSqkY6EKH7QV4=";
    })

    # indent-blankline.nvim - Indentation guides
    (buildPluginNoCheck {
      owner = "lukas-reineke";
      repo = "indent-blankline.nvim";
      rev = "005b56001b2cb30bfa61b7986bc50657816ba4ba";
      sha256 = "sha256-pWRfY4vqL3fJlXZEU4K8TUK3Bw0n0VLVd3MF/6BpSxI=";
    })

    # noice.nvim - UI for messages, cmdline, popupmenu
    (buildPluginNoCheck {
      owner = "folke";
      repo = "noice.nvim";
      rev = "0427460c2d7f673ad60eb02b35f5e9926cf67c59";
      sha256 = "sha256-ePH3H+4f8a9dXL0Z5eL/h8iMoR8OL9OxQgqPFBvL+VY=";
    })

    # nui.nvim - UI components library
    (buildPluginNoCheck {
      owner = "MunifTanjim";
      repo = "nui.nvim";
      rev = "de740991c12411b663994b2860f1a4fd0937c130";
      sha256 = "sha256-WlvFoWPwxkJW0TfC7B5bIqY8g3xD9T7u0FZaRz9oE6A=";
    })

    # nvim-notify - Notification manager
    (buildPluginNoCheck {
      owner = "rcarriga";
      repo = "nvim-notify";
      rev = "b5825cf9ee881dd8e43309c93374ed5b87b7a896";
      sha256 = "sha256-yE8M5lC6c+bUljSU3QvKPD2aUGYHZl1mBHm+dg0U1G0=";
    })

    # nvim-autopairs - Auto pairs
    (buildPluginNoCheck {
      owner = "windwp";
      repo = "nvim-autopairs";
      rev = "4d74e75913832866aa7de35e4202463ddf6efd1b";
      sha256 = "sha256-eHLcA0K+X+GH7a9rxN5p8tOLwOqBGVBKxT+lDQeNPfM=";
    })

    # nvim-surround - Surround text objects
    (buildPluginNoCheck {
      owner = "kylechui";
      repo = "nvim-surround";
      rev = "8dd9150ca7eae5683660ea20cec86edcd5ca4046";
      sha256 = "sha256-ePjLU9H8eA3MXvQfG6RkHK9iX1XQyJ7Sm3PHqGqLnNs=";
    })

    # hop.nvim - Easymotion-like navigation
    (buildPluginNoCheck {
      owner = "smoka7";
      repo = "hop.nvim";
      rev = "9c6a1dd9afb53a112b128877ccd583a1faa0b8b6";
      sha256 = "sha256-v1JQr5Z9nJqV/YQKeDcl2LXr0I2k5aL6E7KOlUlBDbE=";
    })

    # nvim-tree.lua - File explorer
    (buildPluginNoCheck {
      owner = "nvim-tree";
      repo = "nvim-tree.lua";
      rev = "1c733e8c1957dc67f47580fe9c458a13b5612d5b";
      sha256 = "sha256-ZTqgJLCe8JLvKMxHq/h5sWsMNqZJkJPU8U8jg1h7T+8=";
    })

    # rust.vim - Rust support
    (buildPluginNoCheck {
      owner = "rust-lang";
      repo = "rust.vim";
      rev = "889b9a7515db477f4cb6808bef1769e53493c578";
      sha256 = "sha256-WqF0XGJI5EeSp0j+8OvBNLR8FHlMHl7CKQJL7BnPTQA=";
    })
  ];

  # ============================================================================
  # COMBINED PLUGIN LIST FOR NEOVIM
  # ============================================================================
  # Use this in your Neovim configuration

  # All plugins combined (nixpkgs versions preferred for better integration)
  allPlugins = nixpkgsPlugins;

  # Use pinned versions if you need exact version matching with lazy.nvim
  # allPlugins = pinnedPlugins;
}
