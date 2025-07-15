return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			-- Enable Mason
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", -- Lua
					"rust_analyzer", -- Rust
					"ts_ls", -- TypeScript/JavaScript
					"gopls", -- Go
					"pyright", -- Python
					"omnisharp",
					-- dll
				},
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua", -- Lua
					"prettier", -- JS/TS/HTML/CSS
					"ruff", -- Python
					"black", -- Python
					"shfmt", -- Shell
					"djlint",
					"csharpier",
					-- dll
				},
			})

			-- LSP settings
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- LSP servers setup
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			-- Setup other LSP servers

			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({ capabilities = capabilities })
			-- pyright untuk full Python LSP
			-- lspconfig.pyright.setup({
			-- 	capabilities = capabilities,
			-- 	on_attach = on_attach,
			-- })

			-- ruff-lsp hanya untuk diagnostics tambahan
			lspconfig.ruff.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			lspconfig.omnisharp.setup({ capabilities = capabilities })
			-- Global mappings
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
			vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Go to definition" })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "Show references" })
			vim.keymap.set(
				"n",
				"gI",
				require("telescope.builtin").lsp_implementations,
				{ desc = "Go to implementation" }
			)

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

			-- Setup autocompletion
			local cmp = require("cmp")

			local luasnip = require("luasnip")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			})
		end,
	},
}
