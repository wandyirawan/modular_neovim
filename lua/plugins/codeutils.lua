return {
	{
		"numToStr/Comment.nvim",
		opts = {
			---Add a space b/w comment and the line
			padding = true,
			---Whether the cursor should stay at its position
			sticky = true,
			---Lines to be ignored while (un)comment
			ignore = nil,
			---LHS of toggle mappings in NORMAL mode
			toggler = {
				---Line-comment toggle keymap
				line = "gcc",
				---Block-comment toggle keymap
				block = "gbc",
			},
			---LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				---Line-comment keymap
				line = "gc",
				---Block-comment keymap
				block = "gb",
			},
			---LHS of extra mappings
			extra = {
				---Add comment on the line above
				above = "gcO",
				---Add comment on the line below
				below = "gco",
				---Add comment at the end of line
				eol = "gcA",
			},
			---Enable keybindings
			---NOTE: If given `false` then the plugin won't create any mappings
			mappings = {
				---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
				basic = true,
				---Extra mapping; `gco`, `gcO`, `gcA`
				extra = true,
			},
			---Function to call before (un)comment
			pre_hook = nil,
			---Function to call after (un)comment
			post_hook = nil,
		},
		lazy = false,
	},
	{
		"rhysd/vim-clang-format",
		init = function()
			vim.cmd([[
        autocmd FileType proto ClangFormatAutoEnable
        ]])
		end,
	},
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",

			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
			{
				"kristijanhusak/vim-dadbod-ui",
				init = function()
					-- Mapping untuk membuka UI
					vim.g.db_ui_use_nerd_fonts = 1
					vim.g.db_ui_show_database_icon = 1
					vim.keymap.set("n", "<leader>dui", ":DBUIToggle<CR>", { silent = true, desc = "Toggle DB UI" })
				end,
			},
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
			},
		},
		ft = { "sql", "mysql", "plsql" },
		cmd = { "DB", "DBUI", "DBUIToggle" },
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
		},
		config = function()
			vim.g.undotree_SetFocusWhenToggle = 1

			vim.g.undotree_WindowLayout = 2 -- atau 3, cobain sesuai selera
			vim.g.undotree_SplitWidth = 40
		end,
		{
			"christoomey/vim-tmux-navigator",
			lazy = false, -- Load plugin immediately (not lazy-loaded)
			keys = { -- Define keymaps here
				{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Pindah ke window kiri" },
				{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Pindah ke window bawah" },
				{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Pindah ke window atas" },
				{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Pindah ke window kanan" },
				{ "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", desc = "Pindah ke window sebelumnya" },
			},
			config = function()
				-- Optional: Non-default settings (jika diperlukan)
				vim.g.tmux_navigator_no_mappings = 1 -- Biarkan Lazy.nvim handle keymaps
			end,
		},
	},
}
