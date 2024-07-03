return {
	"nickpoorman/nvim-rubocop-textwidth",
	ft = "ruby", -- Load this plugin for Ruby files only
	rocks = "lyaml",
	config = function()
		require("rubocop_textwidth").setup()
	end,
}
