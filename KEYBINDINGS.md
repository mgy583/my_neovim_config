# Keybindings Reference

This document lists all custom keybindings in this Neovim configuration.

## Leader Key
The leader key is set to `<Space>`.

## General Keybindings

### Insert Mode
- `jk` - Exit insert mode (same as `<ESC>`)

### Normal Mode

#### Window Management
- `<leader>sv` - Split window vertically
- `<leader>sh` - Split window horizontally
- `<leader>nh` - Clear search highlights

#### Clipboard Operations
- `yy` - Yank (copy) line to system clipboard
- `y` (visual) - Yank selection to system clipboard
- `p` - Paste from system clipboard

## Plugin-Specific Keybindings

### File Explorer (Neo-tree)
- `<leader>ee` - Toggle file explorer
- `<leader>ef` - Focus file explorer

Within Neo-tree:
- `<Space>` - Toggle node
- `<CR>` / `<2-LeftMouse>` - Open file
- `<ESC>` - Cancel/close
- `S` - Open in horizontal split
- `s` - Open in vertical split
- `t` - Open in new tab
- `a` - Add file
- `A` - Add directory
- `d` - Delete file/directory
- `r` - Rename
- `y` - Copy to clipboard
- `x` - Cut to clipboard
- `p` - Paste from clipboard
- `R` - Refresh
- `H` - Toggle hidden files
- `?` - Show help

### Telescope (Fuzzy Finder)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Find LSP references
- `<leader>fe` - File explorer (file browser extension)
- `gr` - Go to definition (LSP)

Within Telescope:
- `<C-j>` - Move to next item
- `<C-k>` - Move to previous item
- `<C-q>` - Send selected to quickfix list

### LSP (Language Server Protocol)
- `gh` - LSP Finder (find references, definitions, etc.)
- `<leader>ca` - Code action
- `gd` - Peek definition
- `gr` - Rename symbol
- `<leader>cf` - Format code

### Git (Gitsigns)
- `]c` - Next git hunk
- `[c` - Previous git hunk
- `<leader>gs` - Stage hunk
- `<leader>gr` - Reset hunk
- `<leader>gS` - Stage buffer
- `<leader>gu` - Undo stage hunk
- `<leader>gR` - Reset buffer
- `<leader>gp` - Preview hunk
- `<leader>gb` - Blame line (full)
- `<leader>gtb` - Toggle line blame
- `<leader>gd` - Diff this
- `<leader>gD` - Diff this ~
- `<leader>gtd` - Toggle deleted
- `ih` (visual/operator) - Select hunk

### Code Commenting (Comment.nvim)
- `gcc` - Toggle line comment
- `gbc` - Toggle block comment
- `gc` - Line comment (operator-pending)
- `gb` - Block comment (operator-pending)
- `gcO` - Add comment above
- `gco` - Add comment below
- `gcA` - Add comment at end of line

### Terminal (Toggleterm)
- `<leader>tt` - Toggle terminal
- `<leader>tf` - Toggle floating terminal
- `<leader>th` - Toggle horizontal terminal
- `<leader>tv` - Toggle vertical terminal
- `<leader>tg` - Toggle LazyGit
- `<C-\>` - Toggle terminal (in any mode)

Within Terminal mode:
- `<ESC>` or `jk` - Exit terminal mode to normal mode
- `<C-h/j/k/l>` - Navigate between windows

### Treesitter
- `gnn` - Initialize incremental selection

## Auto-close Windows
For certain file types (help, man, qf, etc.), pressing `q` will close the window.

## Which-key
Press `<leader>` and wait to see available keybindings in a popup.

Key groups:
- `<leader>f` - Find (Telescope)
- `<leader>e` - Explorer
- `<leader>s` - Split/Session
- `<leader>c` - Code
- `<leader>g` - Git
- `<leader>l` - LSP
- `<leader>t` - Terminal/Trouble
- `<leader>b` - Buffer
- `<leader>w` - Window
- `<leader>n` - No Highlight
- `<leader>x` - Diagnostics/Quickfix
