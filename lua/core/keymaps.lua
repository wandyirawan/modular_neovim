-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Tambahkan keymaps lainnya di sini

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "N", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "E", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "Z", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

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
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Global var: layout saat ini
vim.g.keyboard_layout = vim.g.keyboard_layout or "canary"

-- Bersihkan mapping sebelumnya
local function unmap_keys(keys)
	for _, key in ipairs(keys) do
		for _, mode in ipairs({ "n", "o", "v" }) do
			local existing = vim.fn.maparg(key, mode)
			if existing ~= "" then
				pcall(vim.keymap.del, mode, key)
			end
		end
	end
end

-- Canary layout
local function setup_canary()
	unmap_keys({ "p", "h", "a", "e", "i" }) -- galium keys
	map({ "n", "o", "v" }, "m", "h", {})
	map({ "n", "o", "v" }, "n", "j", {})
	map({ "n", "o", "v" }, "e", "k", {})
	map({ "n", "o", "v" }, "i", "l", {})
	map({ "n", "o", "v" }, "j", "e", {})
	map({ "n", "o", "v" }, "k", "n", {})
	map({ "n", "o", "v" }, "l", "i", {})
	map({ "o", "v" }, "u", "i", {})
	map({ "n", "o", "v" }, "h", "<Nop>", {}) -- disable `h`
end

-- Galium layout
local function setup_galium()
	unmap_keys({ "m", "n", "e", "i", "h" }) -- canary keys
	map({ "n", "o", "v" }, "p", "h", {})
	map({ "n", "o", "v" }, "h", "j", {})
	map({ "n", "o", "v" }, "a", "k", {})
	map({ "n", "o", "v" }, "e", "l", {})
	map({ "n", "o", "v" }, "j", "e", {})
	map({ "n", "o", "v" }, "k", "n", {})
	map({ "n", "o", "v" }, "l", "i", {})
	map({ "o", "v" }, "u", "i", {})
	-- khusus di galium: remap insert key
	map({ "n", "v" }, "i", "a", {})
	map({ "n", "v" }, "I", "A", {})
	map({ "n", "v" }, ",", "p", {})
	map({ "n", "v" }, "<", "P", {})
end

local layout_file = vim.fn.stdpath("cache") .. "/nvim_layout"

-- Baca layout terakhir dari file (kalau ada)
local function read_layout()
	local f = io.open(layout_file, "r")
	if f then
		local layout = f:read("*l")
		f:close()
		if layout == "canary" or layout == "galium" then
			return layout
		end
	end
	return "canary" -- default fallback
end

-- Simpan layout ke file
local function write_layout(layout)
	local f = io.open(layout_file, "w")
	if f then
		f:write(layout)
		f:close()
	end
end

-- Layout switcher
local function apply_layout()
	if vim.g.keyboard_layout == "canary" then
		setup_canary()
	else
		setup_galium()
	end
end

-- Toggle layout
local function toggle_layout()
	if vim.g.keyboard_layout == "canary" then
		vim.g.keyboard_layout = "galium"
	else
		vim.g.keyboard_layout = "canary"
	end
	write_layout(vim.g.keyboard_layout)
	print("Switched to " .. vim.g.keyboard_layout .. " layout")
	apply_layout()
end

-- Apply saat startup
apply_layout()

-- Tambahkan command dan keymap
vim.api.nvim_create_user_command("ToggleLayout", toggle_layout, {})
map("n", "<leader>kl", toggle_layout, { desc = "Toggle Keyboard Layout" })

-- Save/quit shortcut
map("", "Q", ":q<cr>", {})
map("", "S", ":w<cr>", {})
