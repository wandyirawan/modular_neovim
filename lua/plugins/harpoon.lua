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
		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file" })
		vim.keymap.set("n", "<leader>hm", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Menu" })

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
