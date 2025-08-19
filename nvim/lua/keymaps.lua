local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- ================================================
-- ================================================
-- フローティングウィンドウでキーマップの説明を表示
local function display_keymap_info()
	local lines = {
		"キーマップの説明",
		"Normal モード",
		"<Space>w   - 次のウィンドウに移動",
		"<Space>h   - 左のウィンドウに移動",
		"<Space>j   - 下のウィンドウに移動",
		"<Space>k   - 上のウィンドウに移動",
		"<Space>l   - 右のウィンドウに移動",
		"<Space>q   - 強制終了（保存せずに終了）",
		"<Space>e   - ファイルツリーの表示切り替え",
		"<C-a>      - ファイル全体を選択",
		"te         - 新しいタブでファイルを開く",
		"gn         - 新しいタブを開く",
		"gh         - 前のタブに移動",
		"gl         - 次のタブに移動",
		"ss         - 水平分割して新しいウィンドウにフォーカス",
		"sv         - 垂直分割して新しいウィンドウにフォーカス",
		"x          - カーソル位置の文字を削除（クリップボードなし）",
		"dw         - 単語を削除（クリップボードなし）",
		"Y          - カーソル位置から行末までコピー",
		"<Esc><Esc> - 検索ハイライトをオフ",
		"",
		"Visualモード",
		"<          - 選択範囲を左にインデントし、選択を維持",
		">          - 選択範囲を右にインデントし、選択を維持",
		"v          - 行末まで選択（$）してから最後の文字を除外（h）",
		"<C-p>      - クリップボードの内容を貼り付け",
	}

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

vim.api.nvim_create_user_command("KeymapHelp", display_keymap_info, {})
-- ================================================
-- ================================================

-- リーダーキーをスペースにする
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normalモード
-- ウィンドウ間の移動
keymap("n", "<Leader>w", "<C-w>w", opts) -- 次のウィンドウに移動
keymap("n", "<Leader>h", "<C-w>h", opts) -- 左のウィンドウに移動
keymap("n", "<Leader>j", "<C-w>j", opts) -- 下のウィンドウに移動
keymap("n", "<Leader>k", "<C-w>k", opts) -- 上のウィンドウに移動
keymap("n", "<Leader>l", "<C-w>l", opts) -- 右のウィンドウに移動

-- タブ操作
keymap("n", "te", ":tabedit", opts) -- 新しいタブでファイルを開く
keymap("n", "gn", ":tabnew<Return>", opts) -- 新しいタブを開く
keymap("n", "gh", "gT", opts) -- 前のタブに移動
keymap("n", "gl", "gt", opts) -- 次のタブに移動

-- ウィンドウの分割と移動
keymap("n", "ss", ":split<Return><C-w>w", opts) -- 水平分割して新しいウィンドウにフォーカス
keymap("n", "sv", ":vsplit<Return><C-w>w", opts) -- 垂直分割して新しいウィンドウにフォーカス

-- テキストの選択と削除
keymap("n", "<C-a>", "gg<S-v>G", opts) -- ファイル全体を選択
keymap("n", "x", '"_x', opts) -- カーソル位置の文字を削除してクリップボードには保存しない
keymap("n", "dw", 'vb"_d', opts) -- 単語を削除してクリップボードには保存しない
keymap("n", "Y", "y$", opts) -- カーソル位置から行末までをコピー

-- その他の機能
keymap("n", "<Space>q", ":<C-u>q!<Return>", opts) -- 強制終了（保存せずに終了）
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts) -- 検索ハイライトをオフ
vim.api.nvim_set_keymap("n", "<Leader>e", ":NvimTreeToggle<CR>", opts) -- NvimTreeの表示切り替え

-- Insertモード
keymap("i", ",", ",<Space>", opts) -- コンマの後に自動でスペースを挿入

-- Visualモード
keymap("v", "<", "<gv", opts) -- 選択範囲を左にインデントし、選択を維持
keymap("v", ">", ">gv", opts) -- 選択範囲を右にインデントし、選択を維持
keymap("v", "v", "$h", opts) -- 行末まで選択（$）してから最後の文字を除外（h）
keymap("v", "<C-p>", '"0p', opts) -- クリップボードの内容を貼り付け
