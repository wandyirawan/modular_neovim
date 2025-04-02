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
			require("noice").setup({
				background_colour = "#1e222a",
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
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
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
			})
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
}
