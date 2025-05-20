return {
	{
		"numToStr/Comment.nvim",
		opts = {
			---Add a space b/w comment and the line
			padding = true,
			---Whether the cursor should stay at its position
			sticky = true,
			---Lines to be ignored while (un)comment
			ignore = nil,
			---LHS of toggle mappings in NORMAL mode
			toggler = {
				---Line-comment toggle keymap
				line = "gcc",
				---Block-comment toggle keymap
				block = "gbc",
			},
			---LHS of operator-pending mappings in NORMAL and VISUAL mode
			opleader = {
				---Line-comment keymap
				line = "gc",
				---Block-comment keymap
				block = "gb",
			},
			---LHS of extra mappings
			extra = {
				---Add comment on the line above
				above = "gcO",
				---Add comment on the line below
				below = "gco",
				---Add comment at the end of line
				eol = "gcA",
			},
			---Enable keybindings
			---NOTE: If given `false` then the plugin won't create any mappings
			mappings = {
				---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
				basic = true,
				---Extra mapping; `gco`, `gcO`, `gcA`
				extra = true,
			},
			---Function to call before (un)comment
			pre_hook = nil,
			---Function to call after (un)comment
			post_hook = nil,
		},
		lazy = false,
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
		lazy = false, -- Load plugin immediately (not lazy-loaded)
		keys = { -- Define keymaps here
			{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Pindah ke window kiri" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Pindah ke window bawah" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Pindah ke window atas" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Pindah ke window kanan" },
			{ "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", desc = "Pindah ke window sebelumnya" },
		},
		config = function()
			-- Optional: Non-default settings (jika diperlukan)
			vim.g.tmux_navigator_no_mappings = 1 -- Biarkan Lazy.nvim handle keymaps
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
}
