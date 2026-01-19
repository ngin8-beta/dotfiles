require("nightfox").setup({
	options = {
		transparent = true,
		styles = {
			comments = "italic",
		},
	},
})

vim.cmd([[
try
  colorscheme carbonfox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])
