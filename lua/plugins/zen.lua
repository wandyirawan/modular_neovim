return {
	-- Zen Mode (distraction-free writing)
	{
		"folke/zen-mode.nvim",
		dependencies = { "folke/twilight.nvim" }, -- Optional but recommended
		opts = {
			window = {
				width = 0.85, -- 85% of the screen width (vs fullscreen)
				options = {
					number = false, -- Hide line numbers
					relativenumber = false,

					signcolumn = "no", -- Hide signs (diagnostics, git, etc.)
					cursorline = false, -- Hide cursorline
					foldcolumn = "0", -- Hide fold column
					list = false, -- Hide whitespace chars
				},
			},
			plugins = {

				-- Disable some plugins in Zen Mode
				tmux = { enabled = false }, -- No tmux integration
				kitty = { enabled = false }, -- No kitty integration
				alacritty = { enabled = false },
			},
		},
		keys = {
			{ "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
		},
	},

	-- Twilight (dim inactive code)
	{
		"folke/twilight.nvim",
		opts = {
			dimming = {

				alpha = 0.7, -- Amount of dimming (0.5 = 50% dim, 1.0 = no dim)
				color = { "Normal", "#ffffff" }, -- Default dim color
			},
			context = 15, -- Number of lines to keep highlighted around cursor
			treesitter = true, -- Use Treesitter for better accuracy
			expand = { -- Filetypes where Twilight should work

				"function",

				"method",
				"table",
				"if_statement",
			},
		},
		keys = {
			{ "<leader>zt", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
		},
	},
}
