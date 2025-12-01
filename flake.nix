{
  # =============================================================================
  # Neovim Configuration Flake with Locked Plugins
  # =============================================================================
  #
  # This flake provides:
  # 1. A development shell with Neovim and all necessary dependencies
  # 2. A Neovim package with plugins "baked in" for reproducible builds
  # 3. Flake checks to validate the configuration
  #
  # Plugin Management:
  # - Plugins are defined in nix/neovim-plugins.nix
  # - Plugins available in nixpkgs.vimPlugins are referenced directly
  # - Plugins not in nixpkgs are fetched from GitHub with pinned rev and sha256
  # - The lazy-lock.json file serves as the source of truth for plugin versions
  #
  # Usage:
  #   nix develop          - Enter development shell with Neovim configured
  #   nix build .#neovim   - Build Neovim package with plugins baked in
  #   nix flake check      - Validate the flake configuration
  #
  # To refresh plugin pins:
  # 1. Update lazy-lock.json in Neovim with `:Lazy update`
  # 2. Update nix/neovim-plugins.nix with new revs and sha256 hashes
  # 3. Run `nix flake lock --update-input nixpkgs` if needed
  #
  # =============================================================================

  description = "Neovim configuration with Nix development shell and locked plugins";

  inputs = {
    # Pin nixpkgs to nixos-unstable for latest Neovim and packages
    # The flake.lock file contains the exact commit hash for reproducibility
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Supported systems
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Helper to generate attributes for all supported systems
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Nixpkgs instantiated for each system
      pkgsFor = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      # Import plugin definitions
      pluginsFor = system:
        let pkgs = pkgsFor system;
        in import ./nix/neovim-plugins.nix { inherit pkgs; lib = pkgs.lib; };

      # Build Neovim with plugins baked in
      # This creates a reproducible Neovim package with all plugins pre-installed
      neovimWithPlugins = system:
        let
          pkgs = pkgsFor system;
          plugins = pluginsFor system;
        in
        pkgs.neovim.override {
          configure = {
            # Use the plugins from our pinned list
            # The nixpkgsPlugins list uses stable nixpkgs versions
            packages.myPlugins = {
              start = plugins.nixpkgsPlugins;
              # Optional plugins can be added here
              # opt = [ ];
            };

            # Custom Neovim configuration
            # Note: This is a minimal bootstrap config. The full Lua configuration
            # from the repository requires running from the repo directory or copying
            # the lua/ directory. For full config support, use `nix develop` instead.
            customRC = ''
              " Minimal configuration for standalone Neovim package
              " For full configuration, run from the repository directory:
              "   cd /path/to/my_neovim_config && ./result/bin/nvim
              "
              " Or use nix develop for the complete lazy.nvim experience

              lua << EOF
              -- Set basic options if no external config is loaded
              vim.opt.number = true
              vim.opt.relativenumber = true
              vim.opt.expandtab = true
              vim.opt.shiftwidth = 2
              vim.opt.tabstop = 2

              -- Attempt to load the Lua configuration from various locations
              local config_paths = {
                vim.fn.stdpath("config"),
                vim.fn.getcwd(),
                vim.env.NIX_NVIM_CONFIG_DIR and (vim.env.NIX_NVIM_CONFIG_DIR .. "/nvim") or nil,
              }

              for _, path in ipairs(config_paths) do
                if path then
                  local init_lua = path .. "/init.lua"
                  if vim.fn.filereadable(init_lua) == 1 then
                    package.path = path .. "/lua/?.lua;" .. path .. "/lua/?/init.lua;" .. package.path
                    -- Only load if it doesn't try to bootstrap lazy.nvim (plugins are already loaded)
                    local f = io.open(init_lua, "r")
                    if f then
                      local content = f:read("*all")
                      f:close()
                      -- Load config modules directly, skipping lazy.nvim bootstrap
                      if vim.fn.filereadable(path .. "/lua/core/options.lua") == 1 then
                        dofile(path .. "/lua/core/options.lua")
                      end
                      if vim.fn.filereadable(path .. "/lua/core/keymaps.lua") == 1 then
                        dofile(path .. "/lua/core/keymaps.lua")
                      end
                    end
                    break
                  end
                end
              end
              EOF
            '';
          };
        };
    in
    {
      # =========================================================================
      # Development Shell
      # =========================================================================
      # Enter with: nix develop
      #
      # Provides Neovim with all dependencies for plugin development and usage.
      # XDG_CONFIG_HOME is automatically set to use this repository's config.

      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            name = "neovim-dev";

            # Core tools for Neovim development
            packages = with pkgs; [
              # Neovim itself
              neovim

              # Common dependencies used by plugins (telescope, etc.)
              ripgrep
              fd
              git

              # Build dependencies for native plugins
              gnumake
              gcc
              pkg-config

              # Lua tooling (for plugin development)
              lua5_1
              luajit
              luarocks

              # Tree-sitter CLI for grammar compilation
              tree-sitter

              # Node.js for LSP servers that require it
              nodejs

              # Python for some plugins/LSP servers
              python3

              # Additional useful tools
              curl
              unzip
            ];

            # Set XDG_CONFIG_HOME so Neovim uses this repo's config
            shellHook = ''
              # Create a temporary directory structure for XDG_CONFIG_HOME
              # This ensures Neovim finds the config regardless of repo name
              export NIX_NVIM_CONFIG_DIR=$(mktemp -d)
              ln -sfn "$(pwd)" "$NIX_NVIM_CONFIG_DIR/nvim"
              export XDG_CONFIG_HOME="$NIX_NVIM_CONFIG_DIR"

              # Cleanup function for when shell exits
              cleanup() {
                rm -rf "$NIX_NVIM_CONFIG_DIR"
              }
              trap cleanup EXIT

              echo ""
              echo "════════════════════════════════════════════════════════════"
              echo "  Neovim development shell activated!"
              echo "════════════════════════════════════════════════════════════"
              echo ""
              echo "  Config directory: $(pwd)"
              echo "  Run 'nvim' to start Neovim with this config"
              echo ""
              echo "  Available commands:"
              echo "    nvim             - Start Neovim"
              echo "    nix build .#neovim - Build Neovim with plugins"
              echo ""
            '';
          };
        });

      # =========================================================================
      # Neovim Package with Plugins
      # =========================================================================
      # Build with: nix build .#neovim
      # Run with: ./result/bin/nvim
      #
      # This package includes all plugins from nix/neovim-plugins.nix baked in.
      # The plugins are the nixpkgs versions for better stability and integration.
      #
      # Note: This package uses plugins managed by Nix, not lazy.nvim.
      # For the lazy.nvim experience, use `nix develop` instead.

      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          # Neovim with all plugins pre-installed
          neovim = neovimWithPlugins system;

          # Default package
          default = self.packages.${system}.neovim;

          # Plain Neovim without plugins (for comparison/debugging)
          neovim-plain = pkgs.neovim;
        });

      # =========================================================================
      # Flake Checks
      # =========================================================================
      # Run with: nix flake check
      #
      # Validates that all outputs build correctly.

      checks = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          # Verify Neovim package with plugins builds
          neovim = self.packages.${system}.neovim;

          # Verify devShell builds
          devShell = self.devShells.${system}.default;
        });
    };
}
