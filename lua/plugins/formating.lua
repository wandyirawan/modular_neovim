return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		-- Custom sql-formatter definition
		conform.formatters.sql_formatter = {
			command = "sql-formatter",
			args = { "--config", vim.fn.expand("~/.config/nvim/sql_formatter.json") },

			stdin = true,
		}

		-- Conform setup
		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },

				svelte = { "prettier" },
				css = { "prettier" },
				html = { "djlint" },
				htmldjango = { "djlint" },
				jinja = { "djlint" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "ruff", "autoflake" },
				go = { "goimports-revise", "gofmt", "goline" },
				java = { "google-java-format" },
				rust = { "rustfmt" },
				cpp = { "clang-format" },
				sh = { "shfmt" },
				sql = { "sql_formatter" },
				cs = { "csharpier" },
				elixir = { "mix" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,

				quiet = false,
			},
		})

		local function get_wrapped_sql(formatted, filetype)
			if filetype == "lua" then
				return "[[\n" .. formatted .. "]]"
			elseif filetype == "python" then
				return '"""\n' .. formatted .. '\n"""'
			elseif filetype == "javascript" or filetype == "typescript" or filetype == "svelte" then
				return "`\n" .. formatted .. "`"
			else
				return '"""\n' .. formatted .. '\n"""'
			end
		end

		local function format_and_replace(original, start_row, start_col, end_row, end_col)
			local quote_char = original:sub(1, 1)
			if quote_char == "'" or quote_char == '"' or quote_char == "`" then
				original = original:sub(2, -2)
			end

			local Job = require("plenary.job")
			local output = {}
			local job = Job:new({
				command = "sql-formatter",
				args = { "--config", vim.fn.expand("~/.config/nvim/sql_formatter.json") },
				writer = { original },

				on_stdout = function(_, line)
					table.insert(output, line)
				end,

				on_stderr = function(_, line)
					vim.notify("sql-formatter error: " .. line, vim.log.levels.ERROR)
				end,
			})

			job:sync()
			local formatted = table.concat(output, "\n")

			-- Get the base indent (indent of the SQL string start)
			local base_line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]

			local base_indent = base_line:match("^(%s*)") or ""

			-- Add 2 levels of indent (assuming 1 tab = 2 spaces or 1 actual \t)
			local indent_unit = vim.o.expandtab and string.rep(" ", vim.o.shiftwidth) or "\t"
			local extra_indent = base_indent .. indent_unit .. indent_unit

			-- Apply indent to each line
			local indented_lines = {}
			for line in formatted:gmatch("[^\r\n]+") do
				table.insert(indented_lines, extra_indent .. line)
			end

			-- Wrap result again

			local result = table.concat(indented_lines, "\n")
			local wrapped = get_wrapped_sql(result, vim.bo.filetype)
			local result_lines = vim.split(wrapped, "\n", { plain = true })

			vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, result_lines)
			vim.notify("SQL string formatted with proper indentation", vim.log.levels.INFO)
		end

		-- Visual mode SQL formatter
		vim.api.nvim_create_user_command("FormatSQLString", function()
			local start_pos = vim.fn.getpos("'<")
			local end_pos = vim.fn.getpos("'>")
			local start_row = start_pos[2] - 1
			local start_col = start_pos[3] - 1
			local end_row = end_pos[2] - 1
			local end_col = end_pos[3]

			local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
			if #lines == 0 then
				vim.notify("No text selected", vim.log.levels.WARN)

				return
			end

			local original = table.concat(lines, "\n")
			format_and_replace(original, start_row, start_col, end_row, end_col)
		end, { range = true })

		-- Normal mode SQL formatter using Treesitter

		vim.api.nvim_create_user_command("FormatSQLAtCursor", function()
			local ts_utils = require("nvim-treesitter.ts_utils")

			local node = ts_utils.get_node_at_cursor()
			if not node then
				vim.notify("No node found under cursor", vim.log.levels.WARN)
				return
			end

			while node and node:type() ~= "string" and node:type() ~= "string_literal" do
				node = node:parent()
			end

			if not node then
				vim.notify("No string node found under cursor", vim.log.levels.WARN)

				return
			end

			local start_row, start_col, end_row, end_col = node:range()
			local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
			if #lines == 0 then
				vim.notify("String under cursor is empty", vim.log.levels.WARN)
				return
			end

			local original = table.concat(lines, "\n")
			format_and_replace(original, start_row, start_col, end_row, end_col)
		end, {})

		-- Keymaps

		vim.keymap.set(
			"v",
			"<leader>ft",
			":FormatSQLString<CR>",
			{ desc = "Format selected SQL string", silent = true }
		)
		vim.keymap.set("n", "<leader>ft", ":FormatSQLAtCursor<CR>", { desc = "Format SQL under cursor", silent = true })
	end,
}
