local ok, autopairs = pcall(require, "nvim-autopairs")
if not ok then
	return
end

autopairs.setup({
	-- 特定のファイルタイプで自動ペアの挿入を無効にする
	disable_filetype = { "TelescopePrompt", "vim" },
})
