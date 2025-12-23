local M = {}
local curl = require("plenary.curl")

function M.call_gemini(prompt, context, filetype, config, callback)
	local api_key = config.api_key
	if not api_key or api_key == "" then
		callback(nil, "GEMINI_API_KEY not set")
		return
	end

	local system_prompt = string.format([[You are a concise coding assistant.
- Respond with ONLY code if the user is explicitly asking for code, otherwise respond with ONLY brief comments.
- Keep responses minimal and direct.
- Pay special attention to code highlighted by the user or the line the user is on.

Code rules:
- DO NOT repeat code already present.
- ONLY write the new code the user wants.

Comments rules:
- ALL comments MUST be properly commented out (current file type: %s)
- Use appropriate comment syntax.

Context (current file):
%s]], filetype, context.full_buffer)

	local full_prompt = nil
	if not context.visual_selection or context.visual_selection == "" then
		full_prompt = string.format("Code line user is on:\n```\n%s\n```\n\nRequest: %s",
			context.current_line,
			prompt)
	else
		full_prompt = string.format("Code highligted by user:\n```\n%s\n```\n\nRequest: %s",
			context.visual_selection,
			prompt)
	end

	local url = string.format(
		"https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s",
		config.model or "gemini-2.5-flash",
		api_key
	)

	local body = vim.fn.json_encode({
		contents = { { parts = { { text = full_prompt } } } },
		systemInstruction = { parts = { { text = system_prompt } } },
		generationConfig = { temperature = 0.3, maxOutputTokens = 4096 }
	})

	curl.post(url, {
		body = body,
		headers = { ["Content-Type"] = "application/json" },
		callback = vim.schedule_wrap(function(response)
			if response.status ~= 200 then
				callback(nil, "API error: " .. (response.body or "unknown"))
				return
			end
			local ok, data = pcall(vim.fn.json_decode, response.body)
			if not ok or not data.candidates or not data.candidates[1] then
				callback(nil, "Failed to parse response")
				return
			end
			local text = data.candidates[1].content.parts[1].text or ""
			callback(text, nil)
		end)
	})
end

return M
