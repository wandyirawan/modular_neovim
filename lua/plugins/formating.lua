return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },

				javascriptreact = { "prettier" },

				typescriptreact = { "prettier" },

				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },

				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "ruff", "autoflake" },
				go = { "goimports-revise", "gofmt", "goline" },
				java = { "google-java-format" },
				rust = { "rustfmt" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				sh = { "shfmt" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
