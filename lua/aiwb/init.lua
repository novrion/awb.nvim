local M = {}
local api = require("aiwb.api")
local ui = require("aiwb.ui")
local insert = require("aiwb.insert")

M.config = {
	api_key = nil,
	provider = "gemini",
	model = "gemini-2.5-flash",
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	-- default keybinding
	vim.keymap.set({ "n", "v" }, "<leader>a", M.run, { desc = "AIWB: AI prompt" })
end

function M.get_context()
	local mode = vim.fn.mode()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_line_nr = vim.api.nvim_win_get_cursor(0)[1]

	-- check for visual selection
	local visual_selection = nil
	if mode == "v" or mode == "V" or mode == "\22" then
		vim.cmd('normal! "vy')
		visual_selection = vim.fn.getreg("v")
	end

	-- buffer
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local full_buffer = table.concat(lines, "\n")

	-- current line
	local current_line = lines[cursor_line_nr]

	return {
		visual_selection = visual_selection,
		current_line = current_line,
		full_buffer = full_buffer,
	}
end

function M.run()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1]
	local filetype = vim.bo[bufnr].filetype
	local context = M.get_context()

	-- return to normal mode if in visual mode
	vim.cmd("normal! \27")

	ui.show_prompt(function(prompt)
		-- start spinner at line under cursor
		ui.start_spinner(bufnr, line)

		api.call_gemini(prompt, context, filetype, M.config, function(response, err)
			ui.stop_spinner()

			if err then
				vim.notify("AIWB Error: " .. err, vim.log.levels.ERROR)
				return
			end

			insert.insert_response(bufnr, line, response)
		end)
	end)
end

return M
