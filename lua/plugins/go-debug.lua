return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"leoluz/nvim-dap-go",
		},
		ft = "go",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local dap_go = require("dap-go")

			-- Setup DAP for Go
			dap_go.setup({
				delve = {
					detached = vim.fn.has("win32") == 0,
				},
			})

			-- Setup DAP UI
			dapui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			-- Setup virtual text
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
			})

			-- Auto open/close UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Go-specific debug keymaps
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function()
					local opts = { buffer = true, silent = true, noremap = true }
					
					-- Debug controls
					vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, 
						vim.tbl_extend("force", opts, { desc = "Toggle breakpoint" }))
					vim.keymap.set("n", "<leader>dB", function() 
						dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) 
					end, vim.tbl_extend("force", opts, { desc = "Set conditional breakpoint" }))
					
					vim.keymap.set("n", "<leader>dc", dap.continue, 
						vim.tbl_extend("force", opts, { desc = "Continue" }))
					vim.keymap.set("n", "<leader>ds", dap.step_over, 
						vim.tbl_extend("force", opts, { desc = "Step over" }))
					vim.keymap.set("n", "<leader>di", dap.step_into, 
						vim.tbl_extend("force", opts, { desc = "Step into" }))
					vim.keymap.set("n", "<leader>do", dap.step_out, 
						vim.tbl_extend("force", opts, { desc = "Step out" }))
					
					-- Debug UI
					vim.keymap.set("n", "<leader>du", dapui.toggle, 
						vim.tbl_extend("force", opts, { desc = "Toggle debug UI" }))
					vim.keymap.set("n", "<leader>dr", dap.repl.open, 
						vim.tbl_extend("force", opts, { desc = "Open REPL" }))
					
					-- Go-specific debug commands
					vim.keymap.set("n", "<leader>dt", dap_go.debug_test, 
						vim.tbl_extend("force", opts, { desc = "Debug test" }))
					vim.keymap.set("n", "<leader>dl", dap_go.debug_last_test, 
						vim.tbl_extend("force", opts, { desc = "Debug last test" }))
				end,
			})
		end,
	},
}