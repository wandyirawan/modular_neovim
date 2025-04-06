-- [[ Setting options ]]
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.number = true

vim.opt.relativenumber = true

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.breakindent = true
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- Set colorcolumn at 80 characters
vim.opt.colorcolumn = "80"
vim.cmd([[highlight ColorColumn ctermbg=235 guibg=#303030]])
-- Atur tabline agar hanya muncul jika ada >1 tab
vim.o.showtabline = 1 -- 0=never, 1=hanya jika >1 tab, 2=selalu

-- Fungsi kustom untuk tabline (opsional, bisa disesuaikan)
local function my_tabline()
	local tabs = {}
	for i = 1, vim.fn.tabpagenr("$") do
		local is_active = i == vim.fn.tabpagenr()
		table.insert(tabs, (is_active and "%#TabLineSel#" or "%#TabLine#") .. " " .. i .. " ")
	end
	return table.concat(tabs, "") .. "%#TabLineFill#"
end

vim.o.tabline = "%!v:lua.my_tabline()" -- Set tabline ke fungsi Lua
