local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

-- 文字数カウント処理
local function selectionCount()
	local mode = vim.fn.mode() -- 現在のモードを取得
	local start_line, end_line, start_pos, end_pos

	-- 選択モードでない場合は何も返さない
	if not (mode:find("[vV\22]") ~= nil) then
		return ""
	end
	start_line = vim.fn.line("v") -- 選択開始行
	end_line = vim.fn.line(".") -- 選択終了行

	if mode == "V" then
		-- 行選択モードの場合は、行の全範囲をカウント
		start_pos = 1
		end_pos = vim.fn.strlen(vim.fn.getline(end_line)) + 1
	else
		-- 文字選択/ブロック選択モードの場合は、開始列と終了列を取得
		start_pos = vim.fn.col("v")
		end_pos = vim.fn.col(".")
	end

	local chars = 0
	for i = start_line, end_line do
		local line = vim.fn.getline(i) -- 現在の行のテキストを取得
		local line_len = vim.fn.strlen(line) -- 行の長さを取得
		local s_pos = (i == start_line) and start_pos or 1 -- 選択開始位置
		local e_pos = (i == end_line) and end_pos or line_len + 1 -- 選択終了位置
		chars = chars + vim.fn.strchars(line:sub(s_pos, e_pos - 1)) -- 選択範囲内の文字数を加算
	end

	local lines = math.abs(end_line - start_line) + 1
	return tostring(lines) .. " lines, " .. tostring(chars) .. " characters"
end

lualine.setup({
	options = {
		icons_enabled = true, -- アイコンを有効化
		theme = "palenight",
		section_separators = { left = "", right = "" }, -- セクションの区切り文字
		component_separators = { left = "", right = "" }, -- コンポーネントの区切り文字
		disabled_filetypes = {}, -- 無効にするファイルタイプを指定（空の場合は全て有効）
	},
	sections = {
		lualine_a = { "mode" }, -- モードを表示
		lualine_b = { "branch" }, -- Gitブランチ名を表示
		lualine_c = {
			{
				"filename", -- ファイル名を表示
				file_status = true, -- ファイルの状態を表示
				path = 0, -- ファイル名表示方式：0=ファイル名のみ、1=相対パス、2=絶対パス
			},
		},
		lualine_x = {
			selectionCount,
			{
				"diagnostics", -- 診断情報（エラー、警告など）
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
			},
			"encoding", -- ファイルのエンコーディングを表示
			"filetype", -- ファイルタイプを表示
		},
		lualine_y = { "progress" }, -- ファイルの進捗を表示（行数/総行数）
		lualine_z = { "location" }, -- カーソルの位置を表示（行:列）
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				"filename",
				file_status = true, -- アクティブでない時もファイルの状態を表示
				path = 1, -- アクティブでない時は相対パスで表示
			},
		},
		lualine_x = { "location" }, -- アクティブでない時はカーソルの位置のみ表示
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {}, -- タブラインの設定（ここでは未設定）
	extensions = { "fugitive" }, -- fugitive拡張機能を有効化（Git関連機能の強化）
})
