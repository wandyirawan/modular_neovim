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
vim.opt.guicursor = {
	"n-v-c:block-blinkon500-blinkoff500-blinkwait500",
	"i-ci-ve:ver25-blinkon500-blinkoff500-blinkwait500",
	"r-cr:hor20-blinkon500-blinkoff500-blinkwait500",
	"o:hor50",
}
