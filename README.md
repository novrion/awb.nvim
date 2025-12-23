# Ask Without Bloat
Neovim plugin for quick in-file AI help. Code or comments are generated from your visual selection and written right under your cursor. If no selection is made the hovered line is used instead. The whole file is always in context.

## Requirements
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- Gemini API Key

## Setup
```lua
-- init.lua
vim.pack.add({
	{ src = "https://github.com/novrion/awb.nvim" }
})

require("awb").setup({
    model = "gemini-2.5-flash", -- optional, default (currently only gemini models supported)
    api_key = "<your_api_key>",
    keymaps = {
		run = { "<leader>a", { "n", "v" } }, -- optional
	},
})
```

## Default Keybindings
```
<leader>a    opens prompt dialogue
```
