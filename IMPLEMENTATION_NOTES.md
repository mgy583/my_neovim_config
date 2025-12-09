# Implementation Notes: Neo-tree and Which-Key Integration

## Overview

This implementation adds a LazyVim-style file explorer and keybinding hint system to the Neovim configuration.

## Changes Made

### 1. Replaced nvim-tree with neo-tree.nvim

**File**: `lua/plugins/neo-tree.lua`

The configuration now uses `nvim-neo-tree/neo-tree.nvim` instead of `nvim-tree.lua`, providing:

- **Tree-style appearance**: Indent markers (│ and └) for better visual hierarchy
- **Custom styling**: Dark background (#1a1b26), blue borders (#3d59a1), rounded corners
- **Rich icons**: Folder icons (, , ), file icons, and git status symbols
- **Git integration**: Visual indicators for git status (added, modified, deleted, etc.)
- **Flexible layout**: 35-character width sidebar on the left
- **Multiple views**: Filesystem, buffers, and git status views

#### Key Features:
- Title bar styling with blue background
- Relative line numbers in the tree view
- Smart window closing (closes if last window)
- Diagnostics integration for file errors/warnings
- Extensive keyboard mappings for file operations

### 2. Added which-key.nvim Plugin

**File**: `lua/plugins/whichkey.lua`

Introduces a keybinding discovery system that displays available commands when you press `<leader>` (space):

- **Visual hints**: Shows available keybindings in a popup window
- **Organized groups**: Commands grouped by category (Explorer, Find, LSP, Buffer, etc.)
- **Rounded borders**: Consistent UI styling
- **300ms timeout**: Hints appear after 300ms of inactivity
- **Comprehensive mappings**: Covers all major command groups

#### Registered Command Groups:
- `<leader>e` - **Explorer**: File tree operations
- `<leader>f` - **Find/File**: Telescope fuzzy finding
- `<leader>l` - **LSP**: Language server operations
- `<leader>s` - **Split**: Window splitting
- `<leader>b` - **Buffer**: Buffer management
- `<leader>g` - **Git**: Git operations
- `<leader>w` - **Window**: Window navigation
- `<leader>t` - **Terminal/Tab**: Terminal and tabs
- `<leader>n` - **No/New**: Miscellaneous (e.g., no highlight)

### 3. Updated Documentation

**File**: `README.md`

Added comprehensive documentation including:
- Feature list update mentioning Neo-tree and which-key
- Complete keybinding reference
- Neo-tree navigation guide
- Usage examples

## How to Use

### First Time Setup

1. Open Neovim - lazy.nvim will automatically install the new plugins:
   ```bash
   nvim
   ```

2. Wait for plugin installation to complete (you'll see a lazy.nvim window)

3. Once installation is complete, restart Neovim

### Using Neo-tree

Open the file explorer:
```
<leader>ee  or  <Space>ee
```

Navigate files:
- `<CR>` or `l` - Open file/expand directory
- `<Space>` - Toggle directory node
- `h` - Close directory
- `q` - Close Neo-tree

File operations:
- `a` - Add new file
- `A` - Add new directory
- `d` - Delete file/directory
- `r` - Rename file/directory
- `c` - Copy file
- `m` - Move file
- `y` - Copy to clipboard
- `x` - Cut to clipboard
- `p` - Paste from clipboard

Window splits:
- `s` - Open in vertical split
- `S` - Open in horizontal split
- `t` - Open in new tab

Other features:
- `R` - Refresh tree
- `H` - Toggle hidden files
- `/` - Fuzzy finder
- `?` - Show help with all mappings

### Using Which-Key

Simply press `<leader>` (space bar) and wait 300ms. A popup will appear showing all available commands grouped by category.

Example workflows:
1. Press `<Space>` → see all groups
2. Press `f` → see all file/find commands
3. Press `f` → search for files with Telescope

You can also press:
- `<leader>e` to see Explorer commands
- `<leader>l` to see LSP commands
- `<leader>g` to see Git commands
- etc.

## Styling Details

### Neo-tree Color Scheme

The configuration uses colors that match the Tokyo Night theme:
- **Background**: `#1a1b26` (dark blue-gray)
- **Borders**: `#3d59a1` (blue)
- **Title bar**: Blue background with white text
- **Separators**: Blue vertical lines

### Icons Used

- Folders: ,  (closed), , 󰜌 (open), 󰷏 (empty)
- Files: Default icon
- Expanders:  (collapsed),  (expanded)
- Git status: ✚ (added),  (modified), ✖ (deleted), etc.
- Modified: ● (bullet)

## Dependencies

All required dependencies are automatically installed by lazy.nvim:
- `nvim-lua/plenary.nvim` - Lua utility functions
- `nvim-tree/nvim-web-devicons` - File icons
- `MunifTanjim/nui.nvim` - UI component library

## Testing Notes

To verify the installation:

1. **Check Neo-tree**: `:Neotree toggle` should open the file tree
2. **Check which-key**: Press `<Space>` and wait for the popup
3. **Check styling**: Verify the tree has blue borders and proper icons
4. **Check keybindings**: Try various `<leader>` combinations

## Troubleshooting

### Plugins not loading

If plugins don't load automatically:
```vim
:Lazy sync
```

### Icons not displaying

Ensure you have a Nerd Font installed and configured in your terminal:
- Download from: https://www.nerdfonts.com/
- Popular choices: JetBrains Mono Nerd Font, Fira Code Nerd Font

### Neo-tree not appearing

Check if the command works:
```vim
:Neotree toggle
```

If it fails, check plugin installation:
```vim
:Lazy
```

### Which-key not showing

Verify the timeout setting:
```vim
:echo &timeoutlen
```

Should show `300`. Adjust in `lua/plugins/whichkey.lua` if needed.

## Future Enhancements

Possible improvements:
- Custom title bar with file count (e.g., "Explorer 42/42")
- Additional color schemes for different themes
- More git integration features
- Custom filters and sorting options

## References

- [Neo-tree.nvim Documentation](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [Which-key.nvim Documentation](https://github.com/folke/which-key.nvim)
- [LazyVim Documentation](https://www.lazyvim.org/)
