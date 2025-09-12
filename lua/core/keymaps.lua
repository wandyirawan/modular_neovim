-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Tambahkan keymaps lainnya di sini

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "Z", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Shortcut untuk manajemen tab
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

-- Global var: layout saat ini (load from file)
vim.g.keyboard_layout = read_layout()

-- Bersihkan mapping sebelumnya (improved efficiency)
local function unmap_keys(keys)
	for _, key in ipairs(keys) do
		for _, mode in ipairs({ "n", "o", "v" }) do
			pcall(vim.keymap.del, mode, key)
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
	map({ "n", "v" }, "l", "a", {}) -- l = append after cursor
	map({ "n", "v" }, "L", "A", {}) -- L = append at end of line
	map({ "o", "v" }, "u", "i", {})
	-- i tetap sebagai insert mode (tidak diremap)
	map({ "n", "v" }, ",", "p", {})
	map({ "n", "v" }, "<", "P", {})
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

-- Enhanced error navigation
vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostic to location list" })
vim.keymap.set("n", "<leader>df", function()
	vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
end, { desc = "Show diagnostic in float" })

-- Better file path display in command line
vim.keymap.set("n", "<leader>fp", function()
	local filepath = vim.fn.expand("%:p")
	local relative = vim.fn.expand("%:~:.")
	vim.notify("Full path: " .. filepath .. "\nRelative: " .. relative, vim.log.levels.INFO)
end, { desc = "Show file path" })

-- Save/quit shortcut
map("", "Q", ":q<cr>", {})
map("", "S", ":w<cr>", {})
