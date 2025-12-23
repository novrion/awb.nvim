local M = {}

local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_timer = nil
local spinner_bufnr = nil
local spinner_line = nil

function M.show_prompt(callback)
	vim.ui.input({ prompt = "> " }, function(input)
		if input and input ~= "" then
			vim.schedule(function()
				callback(input)
			end)
		end
	end)
end

function M.start_spinner(bufnr, line)
	spinner_bufnr = bufnr
	spinner_line = line
	local frame = 1

	-- insert placeholder line
	vim.api.nvim_buf_set_lines(bufnr, line, line, false, { spinner_frames[1] })

	spinner_timer = vim.loop.new_timer()
	spinner_timer:start(0, 80, vim.schedule_wrap(function()
		if not spinner_line or not vim.api.nvim_buf_is_valid(bufnr) then
			M.stop_spinner()
			return
		end
		frame = (frame % #spinner_frames) + 1
		pcall(vim.api.nvim_buf_set_lines, bufnr, spinner_line, spinner_line + 1, false,
			{ spinner_frames[frame] })
	end))
end

function M.stop_spinner()
	if spinner_timer then
		spinner_timer:stop()
		spinner_timer:close()
		spinner_timer = nil
	end
	if spinner_bufnr and vim.api.nvim_buf_is_valid(spinner_bufnr) then
		pcall(vim.api.nvim_buf_set_lines, spinner_bufnr, spinner_line, spinner_line + 1, false, {})
	end
	spinner_bufnr = nil
	spinner_line = nil
end

function M.get_spinner_line()
	return spinner_line
end

function M.insert_response(bufnr, line, text)
	if not text or text == "" then return end

	-- clean markdown code blocks if exists
	text = text:gsub("^```%w*\n", ""):gsub("\n```$", ""):gsub("^```%w*", ""):gsub("```$", "")
	text = text:gsub("^\n+", ""):gsub("\n+$", "")

	local lines = vim.split(text, "\n", { plain = true })
	vim.api.nvim_buf_set_lines(bufnr, line, line, false, lines)
end

return M
