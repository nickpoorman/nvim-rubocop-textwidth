local M = {}

local function debug_require(module_name)
	local success, result = pcall(require, module_name)
	if not success then
		vim.notify("Failed to load " .. module_name .. ": " .. tostring(result), vim.log.levels.ERROR)
		vim.notify("package.path: " .. package.path, vim.log.levels.DEBUG)
		vim.notify("package.cpath: " .. package.cpath, vim.log.levels.DEBUG)
	else
		vim.notify(module_name .. " loaded successfully", vim.log.levels.INFO)
	end
	return success, result
end

local lyaml_ok, lyaml = debug_require("lyaml")
if not lyaml_ok then
	return M
end

function M.setup()
	vim.notify("rubocop_textwidth.setup called", vim.log.levels.INFO)
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

	-- Call the function when a Ruby file is opened
	vim.api.nvim_create_autocmd("BufReadPost", {
		pattern = "*.rb",
		callback = set_textwidth_from_rubocop,
	})
end

return M
