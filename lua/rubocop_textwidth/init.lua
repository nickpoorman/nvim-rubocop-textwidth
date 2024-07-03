local M = {}

local ok, lyaml = pcall(require, "lyaml")
if not ok then
	vim.api.nvim_err_writeln("Failed to load lyaml: " .. lyaml)
	return M
end

-- Function to set textwidth from rubocop --show-cops
local function set_textwidth_from_rubocop()
	local cwd = vim.fn.getcwd()
	local rubocop_path = cwd .. "/.rubocop.yml"

	if vim.fn.filereadable(rubocop_path) == 1 then
		local handle = io.popen("bundle exec rubocop --show-cops")
		local result = handle:read("*all")
		handle:close()

		if result then
			local config = lyaml.load(result)
			if config and config["Layout/LineLength"] and config["Layout/LineLength"].Max then
				local max_line_length = config["Layout/LineLength"].Max
				vim.opt.textwidth = max_line_length
			end
		end
	end
end

function M.setup()
	-- Call the function when a Ruby file is opened
	vim.api.nvim_create_autocmd("BufReadPost", {
		pattern = "*.rb",
		callback = set_textwidth_from_rubocop,
	})
end

return M
