-- lua/plugins/init.lua
-- Central plugin manifest - all plugins are automatically loaded from lua/plugins/*.lua
-- This file provides documentation and organization of the plugin ecosystem

return {
    -- ███████ Color Scheme ███████
    -- Tokyo Night theme with multiple variants
    -- File: tokyonight.lua
    
    -- ███████ UI & Interface ███████
    -- alpha.lua: Dashboard/welcome screen
    -- bufferline.lua: Tab/buffer line at the top
    -- lualine.lua: Statusline at the bottom
    -- noice.lua: Enhanced UI for messages, cmdline and popupmenu
    -- indent-blankline.lua: Indent guides
    -- which-key.lua: Keymap hints popup
    
    -- ███████ File Explorer ███████
    -- neo-tree.lua: Modern file explorer with git integration
    
    -- ███████ Fuzzy Finder & Search ███████
    -- telescope.lua: Fuzzy finder for files, buffers, grep, etc.
    
    -- ███████ LSP & Completion ███████
    -- lsp.lua: Language Server Protocol configuration
    --   - Mason: LSP server installer
    --   - nvim-lspconfig: LSP configurations
    --   - lspsaga: Enhanced LSP UI
    --   - nvim-cmp: Autocompletion engine
    
    -- ███████ Syntax & Parsing ███████
    -- nvim-treesitter.lua: Advanced syntax highlighting and parsing
    
    -- ███████ Code Formatting & Linting ███████
    -- none-ls.lua: Formatting and diagnostics (null-ls successor)
    
    -- ███████ Git Integration ███████
    -- gitsigns.lua: Git decorations and integration
    
    -- ███████ Code Editing ███████
    -- comment.lua: Smart commenting
    -- nvim-autopairs.lua: Auto close brackets, quotes, etc.
    -- nvim-surround.lua: Add/change/delete surrounding delimiters
    -- hop.lua: EasyMotion-like navigation
    
    -- ███████ Terminal ███████
    -- toggleterm.lua: Integrated terminal toggling
    
    -- ███████ Language Specific ███████
    -- rust.lua: Rust-specific tools
}
