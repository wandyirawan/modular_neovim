-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Tambahkan keymaps lainnya di sini
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "N", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "E", ":m '<-2<CR>gv=gv")

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Vim for Colemak
-- map("", "m", "h", {})
map("", "n", "j", {})
map("", "e", "k", {})
map("", "i", "l", {})
map("", "j", "e", {})
map("", "k", "n", {})
map("", "l", "i", {})
map("o", "r", "i", {})

-- Shortcut for quiting and saving
map("", "Q", ":q<cr>", {})
map("", "S", ":w<cr>", {})
