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
			local lualine = require("lualine")

    -- Color table for highlights
    -- stylua: ignore
    local colors = {
      bg       = '#202328',
      fg       = '#bbc2cf',
      yellow   = '#ECBE7B',
      cyan     = '#008080',
      darkblue = '#081633',
      green    = '#98be65',
      orange   = '#FF8800',
      violet   = '#a9a1e1',
      magenta  = '#c678dd',
      blue     = '#51afef',
      red      = '#ec5f67',
    }

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			-- Config
			local config = {
				options = {
					-- Disable sections and component separators
					component_separators = "",
					section_separators = "",
					theme = {
						-- We are going to use lualine_c an lualine_x as left and
						-- right section. Both are highlighted by c theme .  So we
						-- are just setting default looks o statusline
						normal = { c = { fg = colors.fg, bg = colors.bg } },
						inactive = { c = { fg = colors.fg, bg = colors.bg } },
					},
					globalstatus = true,
				},
				sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					-- These will be filled later
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
			}

			-- Inserts a component in lualine_c at left section
			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			-- Inserts a component in lualine_x at right section
			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			ins_left({
				function()
					return "▊"
				end,
				color = { fg = colors.blue }, -- Sets highlighting of component
				padding = { left = 0, right = 1 }, -- We don't need space before this
			})

			ins_left({
				-- mode component
				function()
					return ""
				end,
				color = function()
					-- auto change color according to neovims mode
					local mode_color = {
						n = colors.red,
						i = colors.green,
						v = colors.blue,
						[""] = colors.blue,
						V = colors.blue,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						[""] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { right = 1 },
			})

			ins_left({
				-- filesize component
				"filesize",
				cond = conditions.buffer_not_empty,
			})

			ins_left({
				"filename",
				cond = conditions.buffer_not_empty,
				color = { fg = colors.magenta, gui = "bold" },
			})

			ins_left({ "location" })

			ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

			ins_left({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				diagnostics_color = {
					error = { fg = colors.red },
					warn = { fg = colors.yellow },
					info = { fg = colors.cyan },
				},
			})

			-- Insert mid section. You can make any number of sections in neovim :)
			-- for lualine it's any number greater then 2
			ins_left({
				function()
					return "%="
				end,
			})

			ins_left({
				-- Lsp server name
				function()
					local msg = "No Active Lsp"
					local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
					local clients = vim.lsp.get_clients()
					if next(clients) == nil then
						return msg
					end
					for _, client in ipairs(clients) do
						local filetypes = client.config.filetypes
						if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
							return client.name
						end
					end
					return msg
				end,
				icon = " LSP:",
				color = { fg = "#ffffff", gui = "bold" },
			})

			-- Add components to right sections
			ins_right({
				"o:encoding", -- option component same as &encoding in viml
				fmt = string.upper,
				cond = conditions.hide_in_width,
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"fileformat",
				fmt = string.upper,
				icons_enabled = false,
				color = { fg = colors.green, gui = "bold" },
			})

			ins_right({
				"branch",
				icon = "",
				color = { fg = colors.violet, gui = "bold" },
			})

			ins_right({
				"diff",
				symbols = { added = " ", modified = "󰝤 ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			})

			ins_right({
				function()
					return "▊"
				end,
				color = { fg = colors.blue },
				padding = { left = 1 },
			})

			-- Now initialize lualine
			lualine.setup(config)
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
