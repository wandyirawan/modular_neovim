-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Tambahkan keymaps lainnya di sini
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "N", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "E", ":m '<-2<CR>gv=gv")
-- Shortcut untuk manajemen tab
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New Tab" }) -- Buat tab baru
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" }) -- Tutup tab saat ini
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Close Other Tabs" }) -- Tutup semua tab kecuali yang aktif

-- Navigasi tab
vim.keymap.set("n", "<Tab>", "gt", { desc = "Next Tab" }) -- Pindah ke tab berikutnya (gt)
vim.keymap.set("n", "<S-Tab>", "gT", { desc = "Previous Tab" }) -- Pindah ke tab sebelumnya (gT)
vim.keymap.set("n", "<leader>1", "1gt", { desc = "Go to Tab 1" }) -- Pindah ke Tab 1
vim.keymap.set("n", "<leader>2", "2gt", { desc = "Go to Tab 2" }) -- Pindah ke Tab 2
-- ... dan seterusnya hingga <leader>9
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
