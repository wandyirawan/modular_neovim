return {
	-- Neogit for git operations
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim", -- Optional but recommended

			"nvim-telescope/telescope.nvim", -- Optional
		},
		config = function()
			local neogit = require("neogit")
			neogit.setup({
				kind = "tab", -- or "split", "floating"
				integrations = {

					diffview = true,
					telescope = true,
				},
				-- Customize signs if you like
				signs = {

					section = { ">", "v" },
					item = { ">", "v" },
					hunk = { "", "" },
				},
			})

			-- Keymaps for Neogit
			vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { desc = "Open Neogit" })
			vim.keymap.set("n", "<leader>gci", ":Neogit commit<CR>", { desc = "Neogit commit" })
		end,
	},

	-- Gitsigns for git status in the gutter
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "│" },
					change = { text = "│" },

					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},

				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					-- Navigation between hunks
					vim.keymap.set("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, buffer = bufnr, desc = "Next hunk" })

					vim.keymap.set("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true, buffer = bufnr, desc = "Previous hunk" })

					-- Actions

					vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
					vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })

					vim.keymap.set("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { buffer = bufnr, desc = "Stage selected hunk" })
					vim.keymap.set("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end, { buffer = bufnr, desc = "Reset selected hunk" })
					vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
					vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
					vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
					vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
					vim.keymap.set("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { buffer = bufnr, desc = "Blame line" })
					vim.keymap.set(
						"n",
						"<leader>tb",
						gs.toggle_current_line_blame,
						{ buffer = bufnr, desc = "Toggle line blame" }
					)
					vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Diff this" })
					vim.keymap.set("n", "<leader>hD", function()
						gs.diffthis("~")
					end, { buffer = bufnr, desc = "Diff this ~" })
					vim.keymap.set("n", "<leader>td", gs.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted" })
					-- Open diff
					vim.keymap.set("n", "<leader>hx", function()
						require("gitsigns").diffthis("~1")
					end, { desc = "Diff Against HEAD~1" })

					-- Close diff (just quit the current window)
					vim.keymap.set("n", "<leader>hq", "<cmd>q<CR>", { desc = "Close Diff Window" })
				end,
			})
		end,
	},
}
