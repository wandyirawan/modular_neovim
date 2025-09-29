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
				commands = {
					go = "go",
					gomodifytags = "gomodifytags",
					gotests = "gotests",
					impl = "impl",
					iferr = "iferr",
				},
			})
			-- Go-specific keymaps (only for Go files)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					local opts = { buffer = true, silent = true, noremap = true }
					
					-- Struct tags
					vim.keymap.set("n", "<leader>gtj", "<cmd>GoTagAdd json<CR>", 
						vim.tbl_extend("force", opts, { desc = "Add JSON tags" }))
					vim.keymap.set("n", "<leader>gty", "<cmd>GoTagAdd yaml<CR>", 
						vim.tbl_extend("force", opts, { desc = "Add YAML tags" }))
					vim.keymap.set("n", "<leader>gtd", "<cmd>GoTagAdd db<CR>", 
						vim.tbl_extend("force", opts, { desc = "Add DB tags" }))
					vim.keymap.set("n", "<leader>gtr", "<cmd>GoTagRm<CR>", 
						vim.tbl_extend("force", opts, { desc = "Remove tags" }))
					
					-- Code generation
					vim.keymap.set("n", "<leader>gie", "<cmd>GoIfErr<CR>", 
						vim.tbl_extend("force", opts, { desc = "Generate if err" }))
					vim.keymap.set("n", "<leader>gim", "<cmd>GoImpl<CR>", 
						vim.tbl_extend("force", opts, { desc = "Generate interface implementation" }))
					
					-- Tests
					vim.keymap.set("n", "<leader>gtt", "<cmd>GoTestAdd<CR>", 
						vim.tbl_extend("force", opts, { desc = "Generate tests for function" }))
					vim.keymap.set("n", "<leader>gta", "<cmd>GoTestsAll<CR>", 
						vim.tbl_extend("force", opts, { desc = "Generate tests for all functions" }))
					vim.keymap.set("n", "<leader>gte", "<cmd>GoTestsExp<CR>", 
						vim.tbl_extend("force", opts, { desc = "Generate tests for exported functions" }))
					
					-- Go commands
					vim.keymap.set("n", "<leader>gbr", ":!go run %<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run current file" }))
					vim.keymap.set("n", "<leader>gbb", ":!go build<CR>", 
						vim.tbl_extend("force", opts, { desc = "Build project" }))
					vim.keymap.set("n", "<leader>gbt", ":!go test ./...<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run all tests" }))
					vim.keymap.set("n", "<leader>gbv", ":!go test -v ./...<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run tests verbose" }))
					vim.keymap.set("n", "<leader>gbc", ":!go test -cover ./...<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run tests with coverage" }))
					vim.keymap.set("n", "<leader>gbm", ":!go mod tidy<CR>", 
						vim.tbl_extend("force", opts, { desc = "Go mod tidy" }))
				end,
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
