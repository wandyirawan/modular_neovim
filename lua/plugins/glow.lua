return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	config = function()
		-- Configure markdown-preview options
		vim.g.mkdp_auto_start = 0 -- Don't open preview automatically
		vim.g.mkdp_auto_close = 1 -- Close preview when leaving buffer
		vim.g.mkdp_refresh_slow = 0 -- Refresh on save or leave insert mode
		vim.g.mkdp_command_for_global = 0 -- Only for markdown files
		vim.g.mkdp_open_to_the_world = 0 -- Only for local use
		vim.g.mkdp_open_ip = "" -- Default use localhost

		vim.g.mkdp_browser = "" -- Default browser
		vim.g.mkdp_echo_preview_url = 0 -- Don't echo preview URL
		vim.g.mkdp_browserfunc = "" -- Custom function to open browser
		vim.g.mkdp_preview_options = {
			mkit = {},
			katex = {},
			uml = {},
			maid = {},

			disable_sync_scroll = 0,
			sync_scroll_type = "middle",
			hide_yaml_meta = 1,

			sequence_diagrams = {},
			flowchart_diagrams = {},
			content_editable = false,
			disable_filename = 0,
			toc = {},
		}
		vim.g.mkdp_markdown_css = "" -- Custom CSS
		vim.g.mkdp_highlight_css = "" -- Custom highlight CSS

		vim.g.mkdp_port = "" -- Custom port
		vim.g.mkdp_page_title = "「${name}」" -- Page title format
		vim.g.mkdp_theme = "dark" -- Preview theme

		-- Setup keymaps for markdown files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				vim.keymap.set("n", "<leader>prv", ":MarkdownPreview<CR>", {
					buffer = true,
					silent = true,
					noremap = true,
					desc = "Preview markdown in browser",
				})

				vim.keymap.set("n", "<leader>prs", ":MarkdownPreviewStop<CR>", {
					buffer = true,
					silent = true,
					noremap = true,
					desc = "Stop markdown preview",
				})
				vim.keymap.set("n", "<leader>prt", ":MarkdownPreviewToggle<CR>", {
					buffer = true,
					silent = true,
					noremap = true,
					desc = "Toggle markdown preview",
				})
			end,
		})
	end,
}
