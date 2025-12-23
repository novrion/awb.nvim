# aiwb.nvim
AI Without Bloat is a neovim plugin for quick in-file help. Code or comments are generated from your visual selection and written right under your cursor. If no selection is made the hovered line is used instead. The whole file is always in context.

Currently only Gemini models are supported.

## Requirements
- plenary.nvim (https://github.com/nvim-lua/plenary.nvim/tree/master)
- Gemini API KEY

## Setup
init.lua
```lua
vim.pack.add({
	{ src = "https://github.com/novrion/aiwb.nvim" }
})


require("aiwb").setup({
    model = "gemini-2.5-flash", -- default
    api_key = "<your_api_key>",
})
```
