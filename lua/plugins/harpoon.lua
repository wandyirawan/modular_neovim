return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2", -- pastikan ini
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup({

			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
			},
		})

		-- keymaps contoh
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add file to Harpoon" })
		vim.keymap.set("n", "<leader>h", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle Harpoon UI" })

		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<C-t>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<C-m>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<C-g>", function()
			harpoon:list():select(4)
		end)
	end,
}
