return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			-- Tambahkan plugin untuk ikon
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					-- Tampilan modern
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					border = true,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					use_less = true,
					path_display = { "truncate" },
					winblend = 0,
					set_env = { ["COLORTERM"] = "truecolor" },

					-- Mappings untuk navigasi lebih baik
					mappings = {
						i = {
							["<C-n>"] = actions.move_selection_next,
							["<C-e>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<esc>"] = actions.close,
							["<CR>"] = actions.select_default,
							["<C-x>"] = actions.select_horizontal,
							["<C-v>"] = actions.select_vertical,
							["<C-t>"] = actions.select_tab,
							["<C-u>"] = actions.preview_scrolling_up,
							["<C-d>"] = actions.preview_scrolling_down,
						},
						n = {
							["<C-n>"] = actions.move_selection_next,
							["<C-e>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["q"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
					},
					git_files = {
						theme = "dropdown",
						previewer = false,
					},
					buffers = {
						theme = "dropdown",
						previewer = false,
						initial_mode = "normal",
						sort_lastused = true,
					},
					help_tags = {
						theme = "ivy",
					},
					live_grep = {
						theme = "ivy",
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Load extension
			pcall(require("telescope").load_extension, "fzf")

			-- Keybindings
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find by Grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
			vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
			vim.keymap.set("n", "<C-p>", builtin.git_files, {})
			vim.keymap.set("n", "<leader>ps", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
		end,
	},
}
