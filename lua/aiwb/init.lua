local M = {}
local config = require("aiwb.config")
local core = require("aiwb.core")

function M.setup(opts)
	config.setup(opts)

	-- default keybinding
	vim.keymap.set({ "n", "v" }, "<leader>a", core.run, { desc = "AIWB: AI prompt" })
end

-- expose for external use
M.run = core.run

return M
