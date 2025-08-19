-- ================================================ --
--                     HELP
-- ================================================ --
--フローティングウィンドウでキーマップの説明を表示
local function display_keymap_info()
	local lines = {}
	for line in io.lines(os.getenv("XDG_CONFIG_HOME") .. "/nvim/markdown-cheat-sheet.jax") do
		table.insert(lines, line)
	end

	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	-- ウィンドウサイズと位置の計算
	local width = math.ceil(vim.api.nvim_get_option("columns") * 0.7)
	local height = math.ceil(vim.api.nvim_get_option("lines") * 0.7)
	local row = math.ceil((vim.api.nvim_get_option("lines") - height) / 2)
	local col = math.ceil((vim.api.nvim_get_option("columns") - width) / 2)

	-- フローティングウィンドウの設定
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	}

	vim.api.nvim_open_win(bufnr, true, opts)

	-- ウィンドウを閉じるキーマップ（'q' と 'Esc'）
	vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("MarkdownCheatSheet", display_keymap_info, {})
