Neovim config with lazy.nvim, theme sync, and curated plugins

Theme synchronization
- Respects environment variables WARP_THEME or NVIM_THEME (containing "light" or "dark")
- Falls back to macOS system appearance via defaults read -g AppleInterfaceStyle
- Defaults to dark if detection fails

Key plugins
- Theme: tokyonight (auto-selects day or moon variant), optional catppuccin & kanagawa
- UI: lualine, bufferline, which-key, notify, dressing, noice, indent-blankline, gitsigns
- Code: treesitter, autopairs, Comment, surround
- LSP & Completion: mason, mason-lspconfig, lsp-zero (lspconfig + cmp + luasnip), fidget, conform (format on save)
- Fuzzy: telescope (+ fzf-native if make available)
- Files: nvim-tree
- Navigation: flash, harpoon

Usage
1) Start Neovim: nvim
   lazy.nvim will install plugins on first launch.
2) Optional: set theme preference from Warp
   In Warp, set an env var in your shell config:
   export NVIM_THEME=dark   # or light
   Or Warp can export WARP_THEME.
3) Install language servers
   :Mason  (UI) or they’ll be installed on demand via lsp-zero setup.

Key mappings (highlights)
- <leader>ff/fg/fb/fh: Telescope files/grep/buffers/help
- <leader>e: Toggle nvim-tree
- gd/K/rn/ca: LSP goto/hover/rename/actions
- <leader>a / <leader>ha: Harpoon add / menu
- <leader>1..5: Jump to Harpoon mark

