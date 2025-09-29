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
			"SmiteshP/nvim-navic",
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
					-- gofmt comes with Go installation, not needed in Mason
					"rustfmt", -- Rust formatting  
					"ruff", -- Python all-in-one
					"prettier", -- JS/TS/JSON formatting
					-- Remove: black, isort, mypy, shfmt, djlint, csharpier, sql-formatter, credo
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
				
				-- Auto format on save
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
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
				on_attach = function(client, bufnr)
					-- Disable the base on_attach auto-format to avoid conflicts
					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, bufnr)
					end
					
					-- Go-specific: format and organize imports on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							-- First organize imports
							local params = vim.lsp.util.make_range_params()
							params.context = {only = {"source.organizeImports"}}
							local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
							for _, res in pairs(result or {}) do
								for _, r in pairs(res.result or {}) do
									if r.edit then
										vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
									end
								end
							end
							-- Then format the file
							vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
						end,
					})
				end,
				settings = {
					gopls = {
						gofumpt = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
							unusedwrite = true,
							useany = true,
							unusedvariable = true,
						},
						staticcheck = true,
						semanticTokens = true,
						noSemanticString = true,
						noSemanticNumber = true,
						codelenses = {
							gc_details = false,
							generate = true,
							regenerate_cgo = true,
							run_govulncheck = true,
							test = true,
							tidy = true,
							upgrade_dependency = true,
							vendor = true,
						},
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							compositeLiteralTypes = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
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
				on_attach = function(client, bufnr)
					-- Call the base on_attach function
					on_attach(client, bufnr)
					
					-- Elixir-specific: format on save with mix format
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
						end,
					})
				end,
				cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/elixir-ls") },
				settings = {
					elixirLS = {
						dialyzerEnabled = true,
						fetchDeps = false,
						enableTestLenses = true,
						suggestSpecs = true,
						signatureAfterComplete = true,
						autoInsertRequiredAlias = true,
					},
				},
			})
			-- Global mappings
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
			vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Go to definition" })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "Show references" })
			vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, { desc = "Go to implementation" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
			
			-- Go-specific mappings
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { buffer = true, desc = "Format Go file" })
					vim.keymap.set("n", "<leader>go", ":lua vim.lsp.buf.code_action({context={only={'source.organizeImports'}}})<CR>", 
						{ buffer = true, desc = "Organize imports" })
				end,
			})
			
			-- Elixir-specific mappings
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "elixir", "heex", "eex" },
				callback = function()
					local opts = { buffer = true, silent = true, noremap = true }
					
					-- Elixir development commands
					vim.keymap.set("n", "<leader>er", ":!mix run %<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run current Elixir file" }))
					vim.keymap.set("n", "<leader>et", ":!mix test<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run all tests" }))
					vim.keymap.set("n", "<leader>etf", ":!mix test %<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run tests for current file" }))
					vim.keymap.set("n", "<leader>ec", ":!mix compile<CR>", 
						vim.tbl_extend("force", opts, { desc = "Compile project" }))
					vim.keymap.set("n", "<leader>ef", vim.lsp.buf.format, 
						vim.tbl_extend("force", opts, { desc = "Format Elixir file" }))
					vim.keymap.set("n", "<leader>ed", ":!mix deps.get<CR>", 
						vim.tbl_extend("force", opts, { desc = "Get dependencies" }))
					vim.keymap.set("n", "<leader>es", ":!iex -S mix<CR>", 
						vim.tbl_extend("force", opts, { desc = "Start IEx with mix" }))
					vim.keymap.set("n", "<leader>edc", ":!mix dialyzer<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run Dialyzer" }))
					vim.keymap.set("n", "<leader>ecr", ":!mix credo<CR>", 
						vim.tbl_extend("force", opts, { desc = "Run Credo linter" }))
				end,
			})

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
