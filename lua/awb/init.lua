local M = {}
local config = require("awb.config")
local core = require("awb.core")

function M.setup(opts)
	config.setup(opts)

	local cfg = config.get()

	if cfg.keymaps and cfg.keymaps.ask then
		local key = cfg.keymaps.ask[1]
		local modes = cfg.keymaps.ask[2] or { "n", "v" }
		vim.keymap.set(modes, key, core.ask, { desc = "prompt AI (Without Bloat)" })
	end
end

-- expose for external use
M.ask = core.ask

return M
