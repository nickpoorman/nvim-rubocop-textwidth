return {
	"nickpoorman/nvim-rubocop-textwidth",
	ft = "ruby", -- Load this plugin for Ruby files only
	dependencies = {
		{ "nvim-lua/plenary.nvim", rocks = "lyaml" },
	},
	config = function()
		require("rubocop_textwidth").setup()
	end,
}
