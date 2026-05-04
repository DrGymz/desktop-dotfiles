vim.opt.background = "dark"
vim.cmd.colorscheme("gruvbox")
local function enable_transparency()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
enable_transparency()
require("lualine").setup({
	options = {
		theme = "gruvbox",
	}
})
