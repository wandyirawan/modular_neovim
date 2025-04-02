-- File ini harus mengembalikan tabel plugin untuk lazy.nvim

return {

	-- Import plugin modules
	{ import = "plugins.lsp" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.formating" },
	{ import = "plugins.dap" },
	{ import = "plugins.harpoon" },
	{ import = "plugins.git" },
	{ import = "plugins.completion" },
	{ import = "plugins.ui" },
	{ import = "plugins.codeutils" },
	-- Plugin lainnya bisa ditambahkan di sini
}
