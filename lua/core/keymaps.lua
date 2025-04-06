-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Tambahkan keymaps lainnya di sini

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "N", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "E", ":m '<-2<CR>gv=gv")
-- Shortcut untuk manajemen tab
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "New Tab" }) -- Buat tab baru
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" }) -- Tutup tab saat ini
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { desc = "Close Other Tabs" }) -- Tutup semua tab kecuali yang aktif

-- Navigasi tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "Previous Tab" })
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
