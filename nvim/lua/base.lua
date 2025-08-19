-- すべての自動コマンドをクリア
vim.cmd("autocmd!")

-- スクリプトのエンコーディングをUTF-8に設定
vim.scriptencoding = "utf-8"

-- 行番号を表示
vim.wo.number = true

-- Memoコマンドの作成
vim.api.nvim_create_user_command("Memo", function()
	local datetime = os.date("%Y-%m-%d %H:%M:%S")
	-- 日付と時刻を含むファイル名を生成
	local filename = string.format("~/memo/memo-%s.md", datetime)
	-- ファイル名内のスペースをアンダースコアに置換
	filename = filename:gsub(" ", "_")
	-- 新しいファイルを編集モードで開く
	vim.cmd("e " .. filename)
end, {})
