local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	auto_install = false,

	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true,
		disable = { "css" },
		additional_vim_regex_highlighting = true,
	},
	indent = {
		enable = true,
		disable = { "yaml" }
	},
})
