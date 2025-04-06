return {
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("gopher").setup({
				-- You can customize the gopher settings here
				-- These are the defaults
				commands = {
					go = "go",
					gomodifytags = "gomodifytags",
					gotests = "gotests",
					impl = "impl",
					iferr = "iferr",
				},
			})
			-- Add JSON tags
			vim.keymap.set("n", "<leader>gt", "<cmd>GoTagAdd json<CR>", {
				buffer = true,
				silent = true,
				noremap = true,
				desc = "Add JSON tags to struct",
			})

			-- Add YAML tags
			vim.keymap.set("n", "<leader>gy", "<cmd>GoTagAdd yaml<CR>", {
				buffer = true,
				silent = true,
				noremap = true,
				desc = "Add YAML tags to struct",
			})

			-- Remove tags
			vim.keymap.set("n", "<leader>gr", "<cmd>GoTagRm<CR>", {
				buffer = true,
				silent = true,
				noremap = true,
				desc = "Remove tags from struct",
			})
		end,
		build = function()
			-- Check if Go tools are installed
			vim.cmd([[silent! !which gotests || go install github.com/cweill/gotests/gotests@latest]])

			vim.cmd([[silent! !which gomodifytags || go install github.com/fatih/gomodifytags@latest]])
			vim.cmd([[silent! !which impl || go install github.com/josharian/impl@latest]])
			vim.cmd([[silent! !which iferr || go install github.com/koron/iferr@latest]])
		end,
	},
}
