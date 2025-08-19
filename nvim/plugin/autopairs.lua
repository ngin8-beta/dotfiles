local status, autopairs = pcall(require, "nvim-autopairs")
-- プラグインが正常に読み込めなかった場合は、以降の処理を中断
if not status then
	return
end

autopairs.setup({
	-- 特定のファイルタイプで自動ペアの挿入を無効にする
	disable_filetype = { "TelescopePrompt", "vim" },
})
