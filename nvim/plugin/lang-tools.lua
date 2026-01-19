-- ============================================================================
-- 非推奨警告を抑制（nvim-lspconfig v3.0.0で新APIに移行予定）
-- ============================================================================
local original_deprecate = vim.deprecate
vim.deprecate = function() end

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
	-- Python (Ruff = formatter + linter 統合)
	"ruff",
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
local schemastore = require_ok("schemastore")

-- いずれか欠けていたら終了
if not (mason and mason_lspconfig and lspconfig and cmp_nvim_lsp and null_ls and mason_null_ls and schemastore) then
	return
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

	-- LSPサーバのformatは無効化（外部formatterに寄せる）
	if client.name ~= "null-ls" then
		if client.supports_method and client.supports_method("textDocument/formatting") then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end
	end

	-- null-ls がアタッチしている時だけ保存時format
	if client.name == "null-ls" and client.supports_method("textDocument/formatting") then
		local group = vim.api.nvim_create_augroup(("LspFormat.%d"):format(bufnr), { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({
					bufnr = bufnr,
					async = false,
					timeout_ms = 3000,
					filter = function(c) -- null-ls のみ
						return c.name == "null-ls"
					end,
				})
			end,
		})
	end
end

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
	capabilities = capabilities,
	settings = {
		yaml = {
			schemaStore = { enable = false, url = "" },
			schemas = schemastore.yaml.schemas({
				select = { "docker-compose.yml" },
			}),
		},
	},
})

lspconfig.jsonls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
})

-- ============================================================================
-- Linter/Formatter
-- ============================================================================

null_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	sources = {
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
		-- Python (Ruff: formatter + linter 統合)
		null_ls.builtins.formatting.ruff_format,
		null_ls.builtins.diagnostics.ruff,
		null_ls.builtins.diagnostics.mypy,
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
		null_ls.builtins.hover.printenv,
		-- null_ls.builtins.completion.spell,
		-- null_ls.builtins.completion.luasnip,
		-- null_ls.builtins.completion.tags,
	},
	debug = false,
})

-- ============================================================================
-- Keymap
-- ============================================================================
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- ホバー情報表示
vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts) -- 参照検索
vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- 定義プレビュー
vim.keymap.set("n", "ga", "<cmd>Lspsaga code_action<CR>", opts) -- コードアクション
vim.keymap.set("n", "gn", "<cmd>Lspsaga rename<CR>", opts) -- 変数名変更
vim.keymap.set("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- 診断表示
vim.keymap.set("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- 次の診断へジャンプ
vim.keymap.set("n", "e[", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- 前の診断へジャンプ
vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga term_toggle<CR>", opts) -- ターミナルを開く
-- ============================================================================
-- HELP
-- ============================================================================
local utils = require("utils")

local function display_lsp_keymap_info()
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

	utils.show_floating_window(lines, " LSP キーマップ ")
end

vim.api.nvim_create_user_command("LspKeymapHelp", display_lsp_keymap_info, {})

-- ============================================================================
-- 非推奨警告の抑制を解除
-- ============================================================================
vim.deprecate = original_deprecate
