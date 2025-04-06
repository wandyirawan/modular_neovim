return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "typescript", "rust", "sql" },

				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				incremental_selection = { enable = true },
				textobjects = { enable = true },
				-- Make sure injections are enabled
				injections = {
					enable = true,
				},
			})
		end,
	},
}
