-- ============================================================================
-- Install servers
-- ============================================================================
local lsp_servers = {
    "lua_ls",
    "bashls",
    "jsonls",
    "yamlls",
    "pylsp",
    "gopls",
    "ansiblels",
    "docker_compose_language_service",
    "dockerls",
    "terraformls",
    "markdown_oxide",
}

-- Mason/null-ls で管理したい外部ツール（formatter + linter まとめ）
local external_tools = {
    -- Web/Markdown
    "prettier",
    "markdownlint",
    -- Lua
    "stylua",
    -- Go
    "gofumpt",
    "goimports",
    "golangci-lint",
    -- Python
    "black",
    "isort",
    "pylint",
    "mypy",
    -- Shell
    "shfmt",
    -- Dockerfile
    "hadolint",
    -- YAML
    "yamlfmt",
    "yamllint",
    -- Other
    "dotenv-linter",
}

-- ============================================================================
-- Helper
-- ============================================================================
local function require_ok(mod)
    local ok, lib = pcall(require, mod)
    if not ok then
        return nil
    end
    return lib
end

local mason = require_ok("mason")
local mason_lspconfig = require_ok("mason-lspconfig")
local mason_null_ls = require_ok("mason-null-ls")
local null_ls = require_ok("null-ls")
local lspconfig = require_ok("lspconfig")
local cmp_nvim_lsp = require_ok("cmp_nvim_lsp")

-- いずれか欠けていたら終了
if not (mason and mason_lspconfig and lspconfig and cmp_nvim_lsp and null_ls and mason_null_ls) then
    return
end

-- ============================================================================
-- 共通設定: capabilities / on_attach / diagnostics
-- ============================================================================

-- nvim-cmp 連携のための capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

local opts = { noremap = true, silent = true }

local on_attach = function(client, bufnr)
    -- omnifunc
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- キーマップ（バッファローカル）
    local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
    end

    map("n", "gD", vim.lsp.buf.declaration, "LSP: 宣言へ")
    map("n", "gi", vim.lsp.buf.implementation, "LSP: 実装へ")

    -- 保存時フォーマット（バッファ専用 augroup）
    if client.server_capabilities.documentFormattingProvider then
        local group = vim.api.nvim_create_augroup(("LspFormat.%d"):format(bufnr), { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    async = false,
                    timeout_ms = 3000,
                    filter = function(c)
                        return c.name == "null_ls" or c.name == client.name
                    end,
                })
            end,
        })
    end
end

-- ============================================================================
-- Mason 初期化 & 自動インストール
-- ============================================================================

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})

mason_lspconfig.setup({
    ensure_installed = lsp_servers,
    automatic_enable = false,
})

mason_null_ls.setup({
    ensure_installed = external_tools,
    automatic_installation = true,
})

-- ============================================================================
-- 共通設定を適用するLSPサーバー + 個別上書き
-- ============================================================================
for _, server in ipairs(lsp_servers) do
    lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

lspconfig.yamlls.setup({
    on_attach = on_attach,
    settings = {
        yaml = {
            schemaStore = { enable = true, url = "" },
            schemas = {
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =
                "/*.k8s.yaml",
                ["https://json.schemastore.org/github-workflow"] = "/.github/workflows/*",
                ["https://json.schemastore.org/github-action"] = "/.github/actions/*",
                ["https://json.schemastore.org/prettierrc"] = "/.prettierrc.yaml",
                -- ["https://json.schemastore.org/ansible-playbook"] = "/*.playbook.yaml",
                ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] =
                "/*.playbook.yaml",
                ["https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/schemas/json/compose.json"] =
                "docker-compose.y[a]ml",
            },
        },
    },
})

-- ============================================================================
-- Linter/Formatter
-- ============================================================================

null_ls.setup({
    capabilities = capabilities,
    sources = {
        -- null_ls.builtins.completion.spell,
        -- null_ls.builtins.completion.luasnip,
        -- null_ls.builtins.completion.tags,
        null_ls.builtins.formatting.prettier,
        -- Markdown
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.formatting.markdownlint,
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- Go
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.diagnostics.golangci_lint,
        -- Python
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.diagnostics.pylint.with({
            diagnostics_postprocess = function(diagnostic)
                diagnostic.code = diagnostic.message_id
            end,
        }),
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.black,
        -- bash
        null_ls.builtins.formatting.shfmt,
        -- Dockerfile
        null_ls.builtins.diagnostics.hadolint,
        -- yaml
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.diagnostics.yamllint,
        -- Terraform
        null_ls.builtins.diagnostics.terraform_validate,
        null_ls.builtins.formatting.terraform_fmt,
        -- Other
        null_ls.builtins.diagnostics.dotenv_linter,
        null_ls.builtins.hover.dictionary,
        null_ls.builtins.hover.printenv,
    },
    debug = false,
})

-- ============================================================================
-- Keymap
-- ============================================================================
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)              -- ホバー情報表示
vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)                -- 参照検索
vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)       -- 定義プレビュー
vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)           -- コードアクション
vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>", opts)                -- 変数名変更
vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- 診断表示
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)  -- 次の診断へジャンプ
vim.keymap.set("n", "e[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)  -- 前の診断へジャンプ
vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga term_toggle<CR>", opts)    -- ターミナルを開く
-- ============================================================================
-- HELP
-- ============================================================================
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
        "]e         - 次の診断情報にジャンプ",
        "e[         - 前の診断情報にジャンプ",
        "<Space>d   - 統合ターミナルの表示",
        "q, <Esc>   - このウィンドウを閉じる",
    }

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

    -- ウィンドウサイズと位置の計算
    local width = math.ceil(vim.api.nvim_get_option("columns") * 0.7)
    local height = math.ceil(vim.api.nvim_get_option("lines") * 0.7)
    local row = math.ceil((vim.api.nvim_get_option("lines") - height) / 2)
    local col = math.ceil((vim.api.nvim_get_option("columns") - width) / 2)

    -- フローティングウィンドウの設定
    local floatopts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    }

    vim.api.nvim_open_win(bufnr, true, floatopts)

    -- ウィンドウを閉じるキーマップ（'q' と 'Esc'）
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", "<cmd>close<CR>", { noremap = true, silent = true })
end

vim.api.nvim_create_user_command("LspKeymapHelp", display_keymap_info, {})
