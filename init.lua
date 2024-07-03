return {
	"yourusername/nvim-rubocop-textwidth",
	ft = "ruby", -- Load this plugin for Ruby files only
	config = function()
		require("rubocop_textwidth").setup()
	end,
}
