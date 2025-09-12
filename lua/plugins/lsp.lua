return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			-- Enable Mason
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", -- Neovim config
					"gopls", -- Go - primary
					"rust_analyzer", -- Rust
					"pyright", -- Python intellisense  
					"ruff", -- Python linting (faster)
					"ts_ls", -- Node.js/TypeScript
					"elixirls", -- Elixir
				},
			})
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Core formatters only
					"stylua", -- Lua config
					"goimports", -- Go import management
					"gofmt", -- Go formatting
					"rustfmt", -- Rust formatting  
					"ruff", -- Python all-in-one
					"prettier", -- JS/TS/JSON formatting
					-- Remove: black, isort, mypy, shfmt, djlint, csharpier, sql-formatter
				},
			})

			-- LSP settings
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			
			-- Setup navic for breadcrumb navigation
			local on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, bufnr)
				end
			end

			-- LSP servers setup
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			-- Go LSP (primary focus)
			lspconfig.gopls.setup({ 
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						gofumpt = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			})

			-- Rust LSP
			lspconfig.rust_analyzer.setup({ 
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						checkOnSave = {
							command = "cargo clippy",
						},
					},
				},
			})

			-- TypeScript/Node.js LSP
			lspconfig.ts_ls.setup({ 
				capabilities = capabilities,
				on_attach = on_attach,
			})
			
			-- Python LSP - pyright untuk intellisense
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
							typeCheckingMode = "basic",
						},
					},
				},
			})

			-- Ruff LSP untuk fast linting/formatting  
			lspconfig.ruff.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					settings = {
						args = {},
					},
				},
			})

			-- Elixir LSP
			lspconfig.elixirls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/elixir-ls") },
			})
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
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 750 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
				},
			})
		end,
	},
}
