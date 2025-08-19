local autocmd = vim.api.nvim_create_autocmd

-- ファイル保存前に行末の空白を削除
autocmd("BufWritePre", {
	pattern = "*", -- すべてのファイル
	callback = function()
		-- filetypeがmarkdown以外であれば行末の空白を削除
		if vim.bo.filetype ~= "markdown" then
			vim.cmd([[%s/\s\+$//e]])
		end
	end,
})

-- 新しい行を入力したときに自動コメントを無効化
autocmd("BufEnter", {
	pattern = "*", -- すべてのファイルタイプに適用
	command = "set fo-=c fo-=r fo-=o", -- 'formatoptions' から 'c', 'r', 'o' を削除
})

-- ファイルを開いたときに前回閉じた時のカーソル位置を復元
autocmd({ "BufReadPost" }, {
	pattern = { "*" }, -- すべてのファイルタイプに適用
	callback = function()
		-- 'silent!' を用いてエラーを抑制し、'normal! g`"zv' でカーソル位置を復元
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

-- Insertモードから離れたら英字にする
autocmd("InsertLeave", {
	pattern = "*",
	command = "call system('fcitx5-remote -c')",
})

-- コマンドラインモードから離れたら英字にする
autocmd("CmdlineLeave", {
	pattern = "*",
	command = "call system('fcitx5-remote -c')",
})
