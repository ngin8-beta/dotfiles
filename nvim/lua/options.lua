-- 基本オプション設定
local options = {
    encoding = "utf-8",               -- エンコーディングをUTF-8に設定
    fileencoding = "utf-8",           -- ファイル保存時のエンコーディングをUTF-8に設定
    title = true,                     -- ターミナルのタイトルを設定
    backup = false,                   -- バックアップファイルを作成しない
    clipboard = "unnamedplus",        -- クリップボードを使用
    cmdheight = 2,                    -- コマンドラインの高さ
    completeopt = { "menuone", "noselect" }, -- 補完オプション
    conceallevel = 0,                 -- コンシール機能のレベル設定
    hlsearch = true,                  -- 検索語のハイライト
    ignorecase = true,                -- 検索時に大文字小文字を無視
    mouse = "a",                      -- すべてのモードでマウスを有効化
    pumheight = 10,                   -- ポップアップメニューの高さ
    showmode = false,                 -- モード表示を無効化
    showtabline = 2,                  -- 常にタブラインを表示
    smartcase = true,                 -- スマートケース検索を有効化
    smartindent = true,               -- スマートインデントを有効化
    swapfile = false,                 -- スワップファイルを作成しない
    termguicolors = true,             -- 端末でのGUIカラーを有効化
    timeoutlen = 300,                 -- キー操作のタイムアウト時間
    undofile = true,                  -- アンドゥファイルを有効化
    updatetime = 300,                 -- Vimの内部タイマーの更新頻度
    writebackup = false,              -- 書き込み時バックアップを作成しない
    shell = "zsh",                    -- シェルとしてzshを使用
    backupskip = { "/tmp/*", "/private/tmp/*" }, -- バックアップ除外パス
    expandtab = true,                 -- タブをスペースに展開
    tabstop = 4,                      -- タブの表示幅
    shiftwidth = 0,                   -- インデント幅
    cursorline = true,                -- カーソル行をハイライト
    number = true,                    -- 行番号を表示
    relativenumber = false,           -- 相対行番号を無効化
    numberwidth = 4,                  -- 行番号の幅
    signcolumn = "yes",               -- サインカラムを常に表示
    wrap = false,                     -- ラップを無効化
    winblend = 0,                     -- ウィンドウの透明度
    wildoptions = "pum",              -- コマンドライン補完のスタイル
    pumblend = 5,                     -- ポップアップメニューの透明度
    background = "dark",              -- 背景色をダークに設定
    scrolloff = 8,                    -- スクロールオフセット
    sidescrolloff = 8,                -- 横スクロールのオフセット
    guifont = "monospace:h17",        -- GUIフォント設定
    splitbelow = false,               -- 新しいウィンドウを下に分割
    splitright = false,               -- 新しいウィンドウを右に分割
}

-- 補完関連の冗長なメッセージを省略
vim.opt.shortmess:append("c")

-- 定義されたオプションの適用
for k, v in pairs(options) do
    vim.opt[k] = v
end

-- カーソル移動を行の端で折り返す
vim.cmd("set whichwrap+=<,>,[,],h,l")

-- 単語の定義にハイフン '-' を追加
vim.cmd([[set iskeyword+=-]])  -- プログラミング言語で'-'を含む識別子を正しく扱う

-- 自動フォーマッティングオプションから 'c', 'r', 'o' を削除
vim.cmd([[set formatoptions-=cro]])  -- 自動コメント挿入と継続を防止

-- ファイルタイプ定義
vim.filetype.add({
  extension = {
    yml = 'yaml',
    yaml = 'yaml',
    md = 'markdown',
  },
})

-- ファイルタイプごとにtabstopを設定
local filetype_group = vim.api.nvim_create_augroup('FileTypeSettings', {})

vim.api.nvim_create_autocmd('FileType', {
  group = filetype_group,
  pattern = { 'yaml', 'markdown' },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
