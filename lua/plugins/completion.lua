return {
	-- Autopairs (moved from your existing file)
	{

		"windwp/nvim-autopairs",
		event = { "InsertEnter" },

		dependencies = {

			"hrsh7th/nvim-cmp",
		},

		config = function()
			-- import nvim-autopairs
			local autopairs = require("nvim-autopairs")
			-- configure autopairs
			autopairs.setup({
				check_ts = true, -- enable treesitter
				ts_config = {
					lua = { "string" }, -- don't add pairs in lua string treesitter nodes
					javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes

					java = false, -- don't check treesitter on java
				},
			})
			-- import nvim-autopairs completion functionality
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			-- import nvim-cmp plugin (completions plugin)
			local cmp = require("cmp")
			-- make autopairs and completion work together
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- LuaSnip for snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets", -- Optional: pre-made snippet collection
			"saadparwaiz1/cmp_luasnip", -- For nvim-cmp integration
		},
		version = "v2.*",
		build = "make install_jsregexp", -- For regex support

		config = function()
			local luasnip = require("luasnip")

			-- Load friendly-snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			-- You can also load your custom snippets
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })

			-- Keymaps for snippet navigation
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { silent = true, desc = "Expand snippet or jump to next placeholder" })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { silent = true, desc = "Jump to previous placeholder" })

			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { silent = true, desc = "Cycle through choices" })
		end,
	},

	-- nvim-cmp (assuming you already have it but adding for completeness)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer", -- buffer completions
			"hrsh7th/cmp-path", -- path completions

			"hrsh7th/cmp-cmdline", -- cmdline completions
			"hrsh7th/cmp-nvim-lsp", -- lsp completions
			"hrsh7th/cmp-nvim-lua", -- neovim Lua API completions
			"saadparwaiz1/cmp_luasnip", -- snippet completions
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "nvim_lua" },
					{ name = "buffer" },
					{ name = "path" },
				}),

				formatting = {
					format = function(entry, vim_item)
						-- Set the source name in the menu
						vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
							nvim_lua = "[Lua]",
						})[entry.source.name]

						return vim_item
					end,
				},
				experimental = {
					ghost_text = true, -- Shows ghost text hint
				},
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
