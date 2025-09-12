-- [[ Setting options ]]

-- Performance optimizations
vim.opt.updatetime = 100  -- Faster completion (from 250)
vim.opt.timeoutlen = 200  -- Faster which-key (from 300)

-- Disable unused plugins for faster startup
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1  
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

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

-- Enhanced diagnostics display
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.INFO] = "⚬",
			[vim.diagnostic.severity.HINT] = "💡",
		},
	},
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
		severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings and errors
	},
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Show diagnostics in floating window on hover
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = 'rounded',
			source = 'always',
			prefix = ' ',
			scope = 'cursor',
		}
		vim.diagnostic.open_float(nil, opts)
	end
})
