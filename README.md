# AI Without Bloat
Neovim plugin for quick in-file help. Code or comments are generated from your visual selection and written right under your cursor. If no selection is made the hovered line is used instead. The whole file is always in context.

## Requirements
- plenary.nvim (https://github.com/nvim-lua/plenary.nvim)
- Gemini API KEY

## Setup
```lua
-- init.lua
vim.pack.add({
	{ src = "https://github.com/novrion/aiwb.nvim" }
})

require("aiwb").setup({
    model = "gemini-2.5-flash", -- default (currently only gemini models supported)
    api_key = "<your_api_key>",
})
```

## Keybinds
```
<leader>a    opens prompt dialogue
```
