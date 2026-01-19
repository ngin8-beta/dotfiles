local utils = require("utils")
local opts = { noremap = true, silent = true }

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
		"<Space>cc  - Claude Code ターミナルを開閉",
		"<Space>cf  - Claude Code にフォーカス",
		"",
		"Visualモード",
		"<          - 選択範囲を左にインデントし、選択を維持",
		">          - 選択範囲を右にインデントし、選択を維持",
		"v          - 行末まで選択（$）してから最後の文字を除外（h）",
		"<C-p>      - クリップボードの内容を貼り付け",
		"<Space>cs  - 選択範囲を Claude に送信",
	}

	utils.show_floating_window(lines, " キーマップ ")
end

vim.api.nvim_create_user_command("KeymapHelp", display_keymap_info, {})
-- ================================================
-- ================================================

-- リーダーキーをスペースにする
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normalモード
-- ウィンドウ間の移動
vim.keymap.set("n", "<Leader>w", "<C-w>w", opts) -- 次のウィンドウに移動
vim.keymap.set("n", "<Leader>h", "<C-w>h", opts) -- 左のウィンドウに移動
vim.keymap.set("n", "<Leader>j", "<C-w>j", opts) -- 下のウィンドウに移動
vim.keymap.set("n", "<Leader>k", "<C-w>k", opts) -- 上のウィンドウに移動
vim.keymap.set("n", "<Leader>l", "<C-w>l", opts) -- 右のウィンドウに移動

-- タブ操作
vim.keymap.set("n", "te", ":tabedit", opts) -- 新しいタブでファイルを開く
vim.keymap.set("n", "gn", ":tabnew<Return>", opts) -- 新しいタブを開く
vim.keymap.set("n", "gh", "gT", opts) -- 前のタブに移動
vim.keymap.set("n", "gl", "gt", opts) -- 次のタブに移動

-- ウィンドウの分割と移動
vim.keymap.set("n", "ss", ":split<Return><C-w>w", opts) -- 水平分割して新しいウィンドウにフォーカス
vim.keymap.set("n", "sv", ":vsplit<Return><C-w>w", opts) -- 垂直分割して新しいウィンドウにフォーカス

-- テキストの選択と削除
vim.keymap.set("n", "<C-a>", "gg<S-v>G", opts) -- ファイル全体を選択
vim.keymap.set("n", "x", '"_x', opts) -- カーソル位置の文字を削除してクリップボードには保存しない
vim.keymap.set("n", "dw", 'vb"_d', opts) -- 単語を削除してクリップボードには保存しない
vim.keymap.set("n", "Y", "y$", opts) -- カーソル位置から行末までをコピー

-- その他の機能
vim.keymap.set("n", "<Space>q", ":<C-u>q!<Return>", opts) -- 強制終了（保存せずに終了）
vim.keymap.set("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts) -- 検索ハイライトをオフ
vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", opts) -- NvimTreeの表示切り替え

-- Insertモード
vim.keymap.set("i", ",", ",<Space>", opts) -- コンマの後に自動でスペースを挿入

-- Visualモード
vim.keymap.set("v", "<", "<gv", opts) -- 選択範囲を左にインデントし、選択を維持
vim.keymap.set("v", ">", ">gv", opts) -- 選択範囲を右にインデントし、選択を維持
vim.keymap.set("v", "v", "$h", opts) -- 行末まで選択（$）してから最後の文字を除外（h）
vim.keymap.set("v", "<C-p>", '"0p', opts) -- クリップボードの内容を貼り付け

-- Claude Code
vim.keymap.set("n", "<Leader>cc", "<cmd>ClaudeCode<CR>", opts) -- Claude Code ターミナルを開閉
vim.keymap.set("n", "<Leader>cf", "<cmd>ClaudeCodeFocus<CR>", opts) -- Claude Code にフォーカス
vim.keymap.set("v", "<Leader>cs", "<cmd>ClaudeCodeSend<CR>", opts) -- 選択範囲を Claude に送信
