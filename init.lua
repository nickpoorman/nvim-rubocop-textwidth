return {
	"nickpoorman/nvim-rubocop-textwidth",
	ft = "ruby", -- Load this plugin for Ruby files only
	dependencies = {
		{ "https://github.com/lubyk/yaml" }, -- Add the yaml library as a dependency
	},
	config = function()
		require("rubocop_textwidth").setup()
	end,
}
