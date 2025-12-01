{
    description = "Neovim configuration with Nix development shell";

    inputs = {
        # Use nixos-unstable for latest Neovim and packages
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
        in
            {
            # Development shell - enter with `nix develop`
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

                            # Lua tooling (optional, for plugin development)
                            lua5_1
                            luajit

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
              echo "Neovim development shell activated!"
              echo "Config directory: $(pwd)"
              echo "Run 'nvim' to start Neovim with this config"
              echo ""
              '';
                    };
                });

            # Optional: Neovim package for standalone use
            # Build with: nix build .#neovim
            packages = forAllSystems (system:
                let
                    pkgs = pkgsFor system;
                in
                    {
                    neovim = pkgs.neovim;

                    default = self.packages.${system}.neovim;
                });

            # Flake checks - validates the flake configuration
            checks = forAllSystems (system:
                let
                    pkgs = pkgsFor system;
                in
                    {
                    # Verify Neovim package builds
                    neovim = self.packages.${system}.neovim;

                    # Verify devShell builds
                    devShell = self.devShells.${system}.default;
                });
        };
}
