local M = {}

M.defaults = {
	api_key = nil,
	provider = "gemini",
	model = "gemini-2.5-flash",
	keymaps = {
		ask = { "<leader>a", { "n", "v" } },
	},
}

M.current = vim.deepcopy(M.defaults)

function M.setup(opts)
	M.current = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

function M.get()
	return M.current
end

return M
