{
    description = "Neovim configuration with Nix development shell and locked plugins";

    # ============================================================================
    # INPUTS
    # ============================================================================
    # nixpkgs is pinned via flake.lock for reproducible builds.
    # The flake.lock file locks the exact nixpkgs revision, ensuring all plugins
    # from pkgs.vimPlugins are at consistent versions.
    #
    # To update nixpkgs (and thus plugin versions):
    #   nix flake update
    #   git add flake.lock && git commit -m "Update nixpkgs"
    # ============================================================================

    inputs = {
        # Use nixos-unstable for latest Neovim and packages
        # Pin is managed by flake.lock for reproducibility
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

            # ============================================================================
            # PLUGIN CONFIGURATION
            # ============================================================================
            # Plugins are defined in nix/neovim-plugins.nix and mapped from lazy-lock.json.
            # Most plugins are available in pkgs.vimPlugins; others are built from source.
            #
            # Plugin sources:
            # - pkgs.vimPlugins.*: Official nixpkgs plugin set (preferred)
            # - buildVimPlugin: For plugins not in nixpkgs (uses fetchFromGitHub)
            #
            # To add a new plugin:
            # 1. Check if it exists in nixpkgs: nix search nixpkgs vimPlugins.<name>
            # 2. If yes, add to plugins list in nix/neovim-plugins.nix
            # 3. If no, use buildVimPlugin with owner, repo, rev, sha256
            # ============================================================================
            neovimPluginsFor = system:
                let pkgs = pkgsFor system;
                in import ./nix/neovim-plugins.nix { inherit pkgs; };

            # Build Neovim with plugins baked in
            # This creates a standalone Neovim package with all plugins pre-installed
            neovimWithPluginsFor = system:
                let
                    pkgs = pkgsFor system;
                    pluginConfig = neovimPluginsFor system;

                    # Configure Neovim with plugins
                    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
                        plugins = pluginConfig.plugins;
                        # Don't include default plugins that might conflict
                        withPython3 = true;
                        withNodeJs = true;
                        withRuby = false;
                    };
                in
                    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig // {
                        # Allow the user's init.lua to load
                        # The XDG_CONFIG_HOME should point to this repo for the config
                        wrapperArgs = neovimConfig.wrapperArgs ++ [
                            # Add runtime dependencies to PATH
                            "--prefix" "PATH" ":" "${pkgs.lib.makeBinPath [
                                pkgs.ripgrep
                                pkgs.fd
                                pkgs.git
                                pkgs.tree-sitter
                            ]}"
                        ];
                    });
        in
            {
            # ============================================================================
            # DEVELOPMENT SHELL
            # ============================================================================
            # Enter with: nix develop
            #
            # This shell provides Neovim and all dependencies for the traditional
            # lazy.nvim-based workflow. Plugins are managed by lazy.nvim, not Nix.
            # Use this for day-to-day development with hot-reload plugin updates.
            # ============================================================================
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

                            # Lua tooling (for plugin development and luarocks)
                            lua5_1
                            luajit
                            luarocks

                            # Tree-sitter CLI for grammar compilation
                            tree-sitter

                            # Node.js for LSP servers that require it
                            nodejs

                            # Python for some plugins/LSP servers
                            python3
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
              echo "╔════════════════════════════════════════════════════════════════╗"
              echo "║           Neovim Development Shell Activated                   ║"
              echo "╠════════════════════════════════════════════════════════════════╣"
              echo "║ Config directory: $(pwd)"
              echo "║ Run 'nvim' to start Neovim with this config (lazy.nvim mode)   ║"
              echo "║                                                                ║"
              echo "║ For Nix-managed plugins, build with:                           ║"
              echo "║   nix build .#neovim                                           ║"
              echo "╚════════════════════════════════════════════════════════════════╝"
              echo ""
              '';
                    };
                });

            # ============================================================================
            # NEOVIM PACKAGES
            # ============================================================================
            # Build with: nix build .#neovim
            # Run with: ./result/bin/nvim
            #
            # This builds Neovim with all plugins from nix/neovim-plugins.nix baked in.
            # Plugins are locked via nixpkgs pinning in flake.lock.
            #
            # Two packages are available:
            # - neovim: Neovim with plugins pre-installed
            # - neovim-unwrapped: Base Neovim without plugins (for custom builds)
            # ============================================================================
            packages = forAllSystems (system:
                let
                    pkgs = pkgsFor system;
                in
                    {
                    # Neovim with plugins baked in
                    neovim = neovimWithPluginsFor system;

                    # Base Neovim for reference/custom builds
                    neovim-unwrapped = pkgs.neovim-unwrapped;

                    default = self.packages.${system}.neovim;
                });

            # ============================================================================
            # FLAKE CHECKS
            # ============================================================================
            # Run with: nix flake check
            #
            # Validates that all outputs build successfully.
            # CI uses this to ensure the flake is valid.
            # ============================================================================
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

            # ============================================================================
            # HOME-MANAGER MODULE (Optional)
            # ============================================================================
            # This module can be imported into a Home Manager configuration to use
            # the Nix-managed plugins with programs.neovim.
            #
            # Usage in home.nix:
            #   imports = [ inputs.my-neovim.homeModules.default ];
            #   programs.neovim = {
            #     enable = true;
            #     # Additional configuration...
            #   };
            # ============================================================================
            homeModules = {
                default = { pkgs, ... }: {
                    programs.neovim = {
                        enable = true;
                        plugins = (import ./nix/neovim-plugins.nix { inherit pkgs; }).plugins;
                        extraPackages = with pkgs; [
                            ripgrep
                            fd
                            git
                            tree-sitter
                            nodejs
                            python3
                        ];
                    };
                };
            };
        };
}
