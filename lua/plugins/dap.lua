return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim", -- Menambahkan integrasi Mason dengan DAP
		},

		config = function()
			local dap = require("dap")

			local ui = require("dapui")

			-- Konfigurasi DapUI dengan opsi tambahan
			ui.setup({
				icons = {
					expanded = "▾",
					collapsed = "▸",
					current_frame = "→",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
			})

			-- Konfigurasi DAP untuk Go
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			require("dap-go").setup({
				-- Tambahan konfigurasi untuk dlv
				delve = {
					initialize_timeout_sec = 20,
					port = "${port}",
				},
			})

			-- Setup integrasi Mason dengan DAP
			require("mason-nvim-dap").setup({
				automatic_installation = true,
				ensure_installed = { "delve", "codelldb" }, -- Adapter untuk Go dan C/C++/Rust
			})

			-- Virtual text yang ditingkatkan
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				virt_text_pos = "eol",
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
				-- Callback untuk menutupi informasi sensitif
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)
					if
						name:match("secret")
						or name:match("token")
						or name:match("api")
						or name:match("password")
						or name:match("key")
						or value:match("secret")
						or value:match("api")
					then
						return "*****"
					end
					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end
					return " " .. variable.value
				end,
			})

			-- Konfigurasi untuk Elixir
			local elixir_ls_debugger = vim.fn.exepath("elixir-ls-debugger")
			if elixir_ls_debugger ~= "" then
				dap.adapters.mix_task = {
					type = "executable",
					command = elixir_ls_debugger,
				}
				dap.configurations.elixir = {
					{
						type = "mix_task",
						name = "phoenix server",
						task = "phx.server",
						request = "launch",

						projectDir = "${workspaceFolder}",

						exitAfterTaskReturns = false,
						debugAutoInterpretAllModules = false,
					},
					{
						type = "mix_task",
						name = "mix test",
						task = "test",
						request = "launch",

						projectDir = "${workspaceFolder}",

						startApps = true,
						exitAfterTaskReturns = true,
					},
				}
			end

			-- Tambahkan adapter untuk Python
			dap.adapters.python = {
				type = "executable",
				command = "python",
				args = { "-m", "debugpy.adapter" },
			}

			dap.configurations.python = {
				{
					type = "python",

					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return vim.fn.exepath("python")
					end,
				},
			}

			-- Tambahkan adapter untuk Node.js
			dap.adapters.node2 = {
				type = "executable",
				command = "node",
				args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
			}

			dap.configurations.javascript = {
				{
					type = "node2",
					request = "launch",
					name = "Launch",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.typescript = dap.configurations.javascript

			-- Keymaps yang ditingkatkan
			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end)

			vim.keymap.set("n", "<space>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			-- Eval var under cursor (dengan pengaturan popup)
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)
			vim.keymap.set("v", "<space>e", function()
				require("dapui").eval()
			end)

			-- Debug navigation keys
			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F5>", dap.step_back)
			vim.keymap.set("n", "<F6>", function()
				require("dap").run({
					type = "go",
					name = "Debug",
					request = "launch",
					program = "${file}",
				})
			end)
			vim.keymap.set("n", "<F12>", function()
				require("dap").terminate()

				require("dapui").close()
				-- Opsional: Hapus breakpoints jika ingin bersih total
				-- require('dap').clear_breakpoints()
			end)
			vim.keymap.set("n", "<F13>", dap.restart)

			-- Tambahkan key untuk toggle UI

			vim.keymap.set("n", "<space>du", ui.toggle)

			-- Listeners untuk UI
			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end

			-- Atur tanda breakpoint dan debugging dengan signs yang lebih terlihat

			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

			vim.fn.sign_define("DapBreakpointCondition", { text = "🔍", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "➡️", texthl = "", linehl = "DebugBreakpointLine", numhl = "" }
			)
			vim.fn.sign_define("DapBreakpointRejected", { text = "⚠️", texthl = "", linehl = "", numhl = "" })
		end,
	},
}
