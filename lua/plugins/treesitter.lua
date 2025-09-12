return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" }, -- Lazy load on buffer events
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			require("nvim-treesitter.configs").setup({
				-- Only install essential parsers by default
				ensure_installed = { 
					"lua", "vim", "vimdoc", "query", -- Core Neovim
					"go", "gomod", "gowork", "gosum", -- Go ecosystem
					"rust", -- Rust
					"python", -- Python for pandas/polars
					"javascript", "typescript", "tsx", "json", -- Node.js ecosystem
					"elixir", "heex", "eex", -- Elixir ecosystem
				},
				
				-- Install parsers on demand for better startup
				auto_install = true,
				sync_install = false, -- Install parsers asynchronously
				
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { 
					enable = true,
					-- Disable for problematic languages if needed
					disable = {},
				},
				incremental_selection = { 
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				-- Disable heavy features for performance
				textobjects = { enable = false }, -- Enable only if you use it
				injections = { enable = true },
			})
		end,
	},
}
