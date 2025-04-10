-- lua/plugins/ui.lua
return {
	-- Color scheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Load this before other plugins
		config = function()
			require("catppuccin").setup({
				flavour = "mocha", -- Options: latte, frappe, macchiato, mocha

				transparent_background = false,
				term_colors = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					telescope = true,
					treesitter = true,

					harpoon = true,
					which_key = true,
					mason = true,
					-- Add other integrations as needed
				},
			})
			vim.cmd.colorscheme("catppuccin")
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},

	-- devicons
	{
		"nvim-tree/nvim-web-devicons",
		enabled = vim.g.icons_enabled,
		config = function()
			require("nvim-web-devicons").set_icon({
				gql = {
					icon = "",
					color = "#e535ab",
					cterm_color = "199",
					name = "GraphQL",
				},
			})
		end,
	},
	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({

				indent = {
					char = "│",
				},
				scope = {
					enabled = true,
					show_start = false,

					show_end = false,
				},
			})
		end,
	},

	-- Dashboard/start screen
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				"                                                     ",
				"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
				"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
				"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
				"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
				"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
				"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
				"                                                     ",
			}

			dashboard.section.buttons.val = {
				dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
				dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
				dashboard.button("t", "  Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
				dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
			}

			dashboard.section.footer.val = "Happy coding with Neovim!"

			alpha.setup(dashboard.opts)
			vim.keymap.set("n", "<leader>;", ":Alpha<CR>")
		end,
	},

	-- Better UI components
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			-- Simpan fungsi notify asli
			local original_notify = vim.notify

			-- Override notify biar Neo-tree gak ganggu
			vim.notify = function(msg, level, opts)
				if msg:match("neo%-tree") and (level == vim.log.levels.WARN or level == vim.log.levels.INFO) then
					return
				end
				original_notify(msg, level, opts)
			end

			require("notify").setup({

				background_colour = "#1e222a",
			})

			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					signature = {
						enabled = true,
					},
					hover = {
						enabled = true,
					},
				},

				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,

					lsp_doc_border = true,
				},
			})

			-- (opsional) bisa balikin original_notify kalau mau stop filter-nya

			-- vim.notify = original_notify
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			-- Simpan fungsi notify asli
			local original_notify = vim.notify

			-- Override notify biar Neo-tree gak ganggu
			vim.notify = function(msg, level, opts)
				if msg:match("neo%-tree") and (level == vim.log.levels.WARN or level == vim.log.levels.INFO) then
					return
				end
				original_notify(msg, level, opts)
			end

			require("notify").setup({

				background_colour = "#1e222a",
			})

			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					signature = {
						enabled = true,
					},
					hover = {
						enabled = true,
					},
				},

				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,

					lsp_doc_border = true,
				},
			})

			-- (opsional) bisa balikin original_notify kalau mau stop filter-nya

			-- vim.notify = original_notify
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			local original_notify = vim.notify
			vim.notify = function(msg, level, opts)
				if msg:find("Neo%-tree WARN") then
					return
				end
				original_notify(msg, level, opts)
			end

			require("notify").setup({

				background_colour = "#1e222a",
			})

			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					signature = {
						enabled = true,
					},
					hover = {
						enabled = true,
					},
				},

				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,

					lsp_doc_border = true,
				},
			})

			-- (opsional) bisa balikin original_notify kalau mau stop filter-nya

			-- vim.notify = original_notify
		end,
	},

	-- Key binding popup/help
	{
		"folke/which-key.nvim",
		event = "VeryLazy",

		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300

			require("which-key").setup({
				plugins = {
					marks = true,
					registers = true,
					spelling = {
						enabled = true,
						suggestions = 20,
					},
					presets = {
						operators = true,
						motions = true,
						text_objects = true,
						windows = true,
						nav = true,
						z = true,
						g = true,
					},
				},
				window = {
					border = "single",
					padding = { 2, 2, 2, 2 },
				},

				layout = {
					height = { min = 4, max = 25 },
					width = { min = 20, max = 50 },
					spacing = 3,
					align = "center",
				},
			})

			-- Register key group labels
			local wk = require("which-key")
			wk.register({
				{ "", group = "Find/Telescope" },
				{ "", group = "LSP" },
				{ "", group = "Git Hunks" },
				{ "", group = "Git" },
				{ "", group = "Toggle" },
			})
		end,

		-- autoscrol
		{
			"karb94/neoscroll.nvim",
			config = function()
				require("neoscroll").setup({
					mappings = { -- Keys to be mapped to their corresponding default scrolling animation
						"<C-u>",
						"<C-d>",
						"<C-b>",
						"<C-f>",
						"<C-y>",
						"<C-e>",
						"zt",
						"zz",
						"zb",
					},
					hide_cursor = true, -- Hide cursor while scrolling
					stop_eof = true, -- Stop at <EOF> when scrolling downwards
					respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
					cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
					duration_multiplier = 1.0, -- Global duration multiplier
					easing = "linear", -- Default easing function
					pre_hook = nil, -- Function to run before the scrolling animation starts
					post_hook = nil, -- Function to run after the scrolling animation ends

					performance_mode = false, -- Disable "Performance Mode" on all buffers.
					ignored_events = { -- Events ignored while scrolling
						"WinScrolled",
						"CursorMoved",
					},
				})
			end,
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",

			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "<leader>ne", "<cmd>Neotree toggle position=right<CR>", desc = "Toggle Neo-tree (right)" },
			{

				"<leader>pv",
				function()
					require("neo-tree.command").execute({
						source = "filesystem",
						toggle = true,
						reveal = true,
						dir = vim.loop.cwd(),
						position = "float",
					})
				end,
				desc = "Project View (float)",
			},
		},
		init = function()
			-- ⛔ Disable netrw
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			-- 🧩 Replace `:Ex`, `:Vex`, `:Sex` with neo-tree
			vim.api.nvim_create_user_command("Ex", function()
				require("neo-tree.command").execute({ source = "filesystem", toggle = true, position = "float" })
			end, {})

			vim.api.nvim_create_user_command("Vex", function()
				require("neo-tree.command").execute({ source = "filesystem", toggle = true, position = "right" })
			end, {})

			vim.api.nvim_create_user_command("Sex", function()
				require("neo-tree.command").execute({ source = "filesystem", toggle = true, position = "float" })
			end, {})

			-- 🚀 Auto open if started with folder
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.argc() == 1 then
						local arg = vim.fn.argv()[1]
						if vim.fn.isdirectory(arg) == 1 then
							require("neo-tree.command").execute({
								source = "filesystem",
								toggle = true,
								reveal = true,
								position = "float",
								dir = vim.loop.cwd(),
							})
						end
					end
				end,
			})
		end,
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				enable_diagnostics = true,
				default_component_configs = {

					icon = {
						folder_closed = "",

						folder_open = "",
						folder_empty = "",
						default = "",
						highlight = "NeoTreeFileIcon",
					},
				},
				window = {
					mappings = {
						-- Canary movement (E=Up, N=Down)

						["e"] = "up", -- Up (Canary)
						["n"] = "down", -- Down (Canary)

						["i"] = "toggle_node", -- Expand/Collapse (Canary-friendly)
						["l"] = "open", -- Open file/folder
						["h"] = "close_node", -- Close folder
						-- Optional: Keep HJKL-like keys for splits
						["v"] = "open_vsplit", -- Vertical split
						["s"] = "open_split", -- Horizontal split
						-- File operations (Canary-friendly positions)
						["a"] = "add", -- Add file/folder
						["d"] = "delete", -- Delete
						["r"] = "rename", -- Rename
						["y"] = "copy", -- Yank (copy)
						["x"] = "cut_to_clipboard", -- Cut (valid command
						["p"] = "paste_from_clipboard", -- Paste (valid command)

						-- === Search/Splits ===
						["/"] = "fuzzy_finder", -- Correct filter command						-- Other useful mappings
						["?"] = "show_help", -- Tampilkan bantuan
						-- Tambahkan mapping untuk menjalankan command mode
						[":"] = function()
							-- Tutup neo-tree float sementara
							vim.cmd("Neotree close")

							-- Jalankan command mode
							vim.defer_fn(function()
								vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":", true, false, true), "n", true)
							end, 10)
						end,

						-- Tambahkan mapping lain yang mungkin Anda butuhkan
						["!"] = function()
							-- Tutup neo-tree float sementara
							vim.cmd("Neotree close")

							-- Jalankan shell command
							vim.defer_fn(function()
								vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("!", true, false, true), "n", true)
							end, 10)
						end,
					},

					popup = {
						size = {
							height = "100%",
							width = "100%",
						},
						position = "50%",
					},
				},
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
					},
				},
			})
		end,
	},
}
