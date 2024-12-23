-- nvim_lspconfigのロード
local status, nvim_lsp = pcall(require, "lspconfig")
if not status then return end -- プラグインが正常に読み込めなかった場合は、以降の処理を中断

local opts = { noremap = true, silent = true }

-- LSPがバッファにアタッチされた時の設定
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    -- オムニコンプリート機能を有効化
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- キーマッピング
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)

    -- ファイル保存時に自動フォーマットを実行
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end
end

-- フォーマット
vim.keymap.set('n', '<leader>fm', function()
    vim.lsp.buf.format {
        timeout_ms = 200,
        async = true,
    } end)

-- Lspsagaのキーマップ
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)                  -- ホバー情報表示
vim.keymap.set('n', 'gr', '<cmd>Lspsaga finder<CR>', opts)                    -- 参照検索
vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)           -- 定義プレビュー
vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)               -- コードアクション
vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>", opts)                    -- 変数名変更
vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)     -- 診断表示
vim.keymap.set("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)      -- 次の診断へジャンプ
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)      -- 前の診断へジャンプ
vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga term_toggle<CR>", opts)        -- ターミナルを開く/閉じる

local servers = {
    'lua_ls',
    'marksman',
    'bashls',
    'gopls',
    'pylsp',
    'ansiblels',
    'terraformls'
}
for _, server in ipairs(servers) do
  nvim_lsp[server].setup({
    on_attach = on_attach,
  })
end

nvim_lsp.yamlls.setup {
  on_attach = on_attach,
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        ["http://json.schemastore.org/github-workflow"] = "/.github/workflows/*",
        ["http://json.schemastore.org/github-action"] = "/.github/actions/*",
        ["http://json.schemastore.org/prettierrc"] = "/.prettierrc.yaml",
        ["http://json.schemastore.org/ansible-playbook"] = "/*.playbook.yaml",
        ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/compose.json"] = "docker-compose.y[a]ml",
      }
    }
  }
}

-- ================================================ --
--                     HELP
-- ================================================ --
--フローティングウィンドウでキーマップの説明を表示
local function display_keymap_info()
  local lines = {
    "キーマップの説明",
    "gD         - 宣言にジャンプ",
    "gd         - 定義をプレビュー",
    "K          - 詳細情報を表示",
    "gi         - 実装箇所にジャンプ",
    "gr         - 参照箇所を検索",
    "ga         - 利用可能なコードアクションを表示",
    "gn         - 変数名変更",
    "ge         - 現在行の診断情報を表示",
    "[e         - 次の診断情報にジャンプ",
    "]e         - 前の診断情報にジャンプ",
    "<Space>d   - 統合ターミナルの表示・非表示切り替え",
    "<Space>fm  - フォーマット",
    "q, <Esc>   - このウィンドウを閉じる"
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
    border = "rounded"
  }

  vim.api.nvim_open_win(bufnr, true, opts)

  -- ウィンドウを閉じるキーマップ（'q' と 'Esc'）
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', '<cmd>close<CR>', { noremap = true, silent = true })
end

vim.api.nvim_create_user_command('LspKeymapHelp', display_keymap_info, {})

