return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
		{
			"luukvbaal/statuscol.nvim", -- Optional: Better fold column display
			config = function()
				require("statuscol").setup({
					configuration = {
						foldfunc = "builtin",
						setopt = true,
					},
				})
			end,
		},
	},
	config = function()
		-- Recommended: Enable treesitter folding
		vim.o.foldcolumn = "1" -- Show fold column
		vim.o.foldlevel = 99 -- Start with all folds open
		vim.o.foldenable = true

		vim.o.foldlevelstart = 99

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				-- Use treesitter for these filetypes
				local ft = { "python", "lua", "javascript", "typescript", "go" }
				if vim.tbl_contains(ft, filetype) then
					return { "treesitter", "indent" }
				end
				return { "indent" } -- Fallback to indent-based
			end,

			preview = {
				win_config = {

					border = "rounded", -- Nice preview window

					winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
				},
			},
			enable_get_fold_virt_text = true, -- Show custom fold text
		})

		-- Better keymaps
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		vim.keymap.set("n", "zp", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover() -- Fallback to LSP hover
			end
		end, { desc = "Peek fold or hover" })
	end,
}
