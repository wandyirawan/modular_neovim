return {
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", desc = "Comment toggle current line" },
			{ "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
			{ "gbc", desc = "Comment toggle current block" },
			{ "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
		},
		opts = {
			padding = true,
			sticky = true,
			ignore = nil,
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
			mappings = {
				basic = true,
				extra = true,
			},
		},
	},
	{
		"rhysd/vim-clang-format",
		init = function()
			vim.cmd([[
        autocmd FileType proto ClangFormatAutoEnable
        ]])
		end,
	},
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
			{
				"kristijanhusak/vim-dadbod-ui",
				init = function()
					-- Mapping untuk membuka UI
					vim.g.db_ui_use_nerd_fonts = 1
					vim.g.db_ui_show_database_icon = 1
					vim.keymap.set("n", "<leader>dui", ":DBUIToggle<CR>", { silent = true, desc = "Toggle DB UI" })
				end,
			},
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
			},
		},
		ft = { "sql", "mysql", "plsql" },
		cmd = { "DB", "DBUI", "DBUIToggle" },
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" },
		},
		config = function()
			vim.g.undotree_SetFocusWhenToggle = 1

			vim.g.undotree_WindowLayout = 2 -- atau 3, cobain sesuai selera
			vim.g.undotree_SplitWidth = 40
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Navigate to left pane" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Navigate to bottom pane" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Navigate to top pane" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate to right pane" },
			{ "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", desc = "Navigate to previous pane" },
		},
		config = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
	},
	{
		"derektata/lorem.nvim",
		config = function()
			require("lorem").opts({
				sentence_length = "medium",
				comma_chance = 0.2,
				max_commas = 2,
			})

			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true }
			-- Normal mode
			keymap("n", "<leader>lw", ":LoremIpsum words 100<CR>", opts)
			keymap("n", "<leader>lb", ":LoremIpsum paragraphs 1<CR>", opts)
			keymap("i", "<C-l>w", "<C-o>:LoremIpsum words 100<CR>", opts)
			keymap("i", "<C-l>b", "<C-o>:LoremIpsum paragraphs 1<CR>", opts)
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local chatgpt = require("chatgpt")

			-- Global model setting (mutable)
			local current_model = "gpt-4-0125-preview"

			chatgpt.setup({
				api_key_cmd = "echo $OPENAI_API_KEY",
				openai_params = {
					model = current_model,
					max_tokens = 2000,
					temperature = 0.5,
					top_p = 0.95,
					frequency_penalty = 0,
					presence_penalty = 0,
				},
				chat = {
					welcome_message = "Hello! How can I help you today?",
				},
			})

			-- 🔀 Model selector
			local models = {
				["GPT-4"] = "gpt-4-0125-preview",
				["GPT-3.5"] = "gpt-3.5-turbo-0125",
			}

			local function select_model()
				local choices = vim.tbl_keys(models)

				vim.ui.select(choices, {
					prompt = "Select ChatGPT Model",
				}, function(choice)
					if choice then
						local selected = models[choice]
						require("chatgpt.config").options.openai_params.model = selected
						vim.notify("✅ Model set to: " .. selected, vim.log.levels.INFO)
					else
						vim.notify("❌ No model selected", vim.log.levels.WARN)
					end
				end)
			end
			-- 🔑 Normal Mode
			vim.keymap.set("n", "<leader>cg", "<cmd>ChatGPT<CR>", { desc = "Open ChatGPT UI" })
			vim.keymap.set("n", "<leader>cc", function()
				local buf = vim.api.nvim_get_current_buf()
				vim.api.nvim_buf_set_option(buf, "modifiable", true)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
			end, { desc = "Clear ChatGPT Buffer" })
			vim.keymap.set("n", "<leader>cm", select_model, { desc = "Select ChatGPT Model" })

			-- 🔑 Visual Mode: Explain & Rewrite
			vim.keymap.set("v", "<leader>ce", "<cmd>ChatGPTRun explain_code<CR>", { desc = "Explain Selected Code" })
			vim.keymap.set("v", "<leader>cr", "<cmd>ChatGPTRun rewrite<CR>", { desc = "Rewrite Selected Code" })

			-- 🔑 Visual Mode: Summarize & Fix (pakai model yang dipilih)
			vim.keymap.set("v", "<leader>cs", function()
				require("chatgpt").run_action("summarize", {
					model = current_model,
					max_tokens = 500,
				})
			end, { desc = "Summarize (Short)" })

			vim.keymap.set("v", "<leader>cf", function()
				require("chatgpt").run_action("fix_bugs", {
					model = current_model,
					max_tokens = 2000,
				})
			end, { desc = "Fix Bugs (Long)" })
			vim.keymap.set("n", "<leader>cq", function()
				vim.cmd("bd!") -- force close buffer
			end, { desc = "Close ChatGPT Buffer" })
		end,
	},
	{
		"barrett-ruth/live-server.nvim",
		build = "npm install -g live-server", -- butuh Node.js
		config = true,
		cmd = { "LiveServerStart", "LiveServerStop" },
		keys = {
			{ "<leader>ls", "<cmd>LiveServerStart<CR>", desc = "Start Live Server" },
			{ "<leader>lS", "<cmd>LiveServerStop<CR>", desc = "Stop Live Server" },
		},
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	-- Essential: nvim-surround for text surrounding
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	-- Essential: Color highlighter
	{
		"norcalli/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({
				"*", -- Highlight all files, but customize for specific filetypes
				css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css
				html = { names = false }, -- Disable parsing "names" like Blue or Gray
			})
		end,
	},
	-- Inline diagnostics - show errors directly in code
	{
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		event = "LspAttach",
		config = function()
			require("lsp_lines").setup()
			-- Disable default virtual text to avoid duplication
			vim.diagnostic.config({
				virtual_text = false,
			})
			-- Toggle keybinding
			vim.keymap.set("n", "<leader>ll", require("lsp_lines").toggle, { desc = "Toggle LSP Lines" })
		end,
	},
}
