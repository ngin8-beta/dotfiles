local M = {}

function M.show_floating_window(lines, title)
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	-- vim.o を使用（非推奨API置換）
	local width = math.ceil(vim.o.columns * 0.7)
	local height = math.ceil(vim.o.lines * 0.7)
	local row = math.ceil((vim.o.lines - height) / 2)
	local col = math.ceil((vim.o.columns - width) / 2)

	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = title,
	}

	vim.api.nvim_open_win(bufnr, true, opts)
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr })
	vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = bufnr })
end

return M
