local M = {}

function M.insert_response(bufnr, line, text)
	if not text or text == "" then return end

	-- clean markdown code blocks if exists
	text = text:gsub("^```%w*\n", ""):gsub("\n```$", ""):gsub("^```%w*", ""):gsub("```$", "")
	text = text:gsub("^\n+", ""):gsub("\n+$", "")

	local lines = vim.split(text, "\n", { plain = true })
	vim.api.nvim_buf_set_lines(bufnr, line, line, false, lines)
end

return M
