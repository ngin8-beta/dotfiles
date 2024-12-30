local fn = vim.fn

-- Packerがインストールされていなければ自動でインストールする
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")  -- Packerのインストール完了後、Neovimを再起動するよう指示
    vim.cmd([[packadd packer.nvim]])
end

-- plugins.luaファイルを保存時に自動でリロードしてPackerSyncを実行する
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return  -- packerの読み込みに失敗した場合はここで終了
end

-- packerのポップアップウィンドウを設定
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

-- プラグインを定義
return packer.startup(function(use)
    use({ "wbthomason/packer.nvim" })             -- Packer自体
    use({ "nvim-lua/plenary.nvim" })              -- 汎用ユーティリティ

    -- カラースキーム
    use({ "EdenEast/nightfox.nvim" })

    -- ステータスライン
    use({ "nvim-lualine/lualine.nvim" })          -- ステータスラインの強化
    use({ "windwp/nvim-autopairs" })              -- 自動括弧補完
    use({ "kyazdani42/nvim-web-devicons" })       -- ファイルアイコン

    -- ファイラー
    use({ "nvim-tree/nvim-tree.lua" })

    -- 補完関連のプラグイン
    use({
        "hrsh7th/nvim-cmp",
        requires = {
           "hrsh7th/cmp-nvim-lsp"
      }
    })                                            -- 補完プラグイン
    use({ "hrsh7th/cmp-buffer" })                 -- バッファ補完
    use({ "hrsh7th/cmp-path" })                   -- パス補完
    use({ "hrsh7th/cmp-cmdline" })                -- コマンドライン補完
    use({ "hrsh7th/cmp-nvim-lsp" })
    use({ "hrsh7th/cmp-nvim-lua" })
    use({ "onsails/lspkind-nvim" })               -- 補完にピクトグラム埋め込み
    use({ "saadparwaiz1/cmp_luasnip" })           -- スニペット補完

    -- スニペット
    use({
          "L3MON4D3/LuaSnip",
          run = "make install_jsregexp"
    })                                            -- スニペットエンジン

    -- debugger
    use({ "mfussenegger/nvim-dap" })              -- DAP（デバッガーアダプタープロトコル）
    use({ "nvim-neotest/nvim-nio"})
    use({
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
    })
    use({
        "leoluz/nvim-dap-go",
        requires = { "mfussenegger/nvim-dap" }
    })                                            -- Go言語用のDAP設定


    -- LSP（言語サーバープロトコル）
    use({ "neovim/nvim-lspconfig" })              -- LSP設定
    use({
        "williamboman/mason.nvim",                  -- LSP/DAP/リンター/フォーマッターインストーラー
        requires = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        }
    })
    use({ "williamboman/mason-lspconfig.nvim" })  -- mason - nvim-lspconfig間の自動セットアップ
    use ({
        'nvimdev/lspsaga.nvim',                   -- LSPのUI強化
        after = 'nvim-lspconfig',
        config = function()
            require('lspsaga').setup({})
        end,
    })
    use({
        'nvimtools/none-ls.nvim',
        requires = {
            "nvim-lua/plenary.nvim",
        }
    })
    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    })
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end,
    })

    -- フォーマッタ
    use({ "MunifTanjim/prettier.nvim" })
        -- 対象言語
        -- JavaScript (including experimental features)
        -- JSX
        -- Angular
        -- Vue
        -- Flow
        -- TypeScript
        -- CSS, Less, and SCSS
        -- HTML
        -- Ember/Handlebars
        -- JSON
        -- GraphQL
        -- Markdown, including GFM and MDX v1
        -- YAML

    -- Markdown
    use({
        'MeanderingProgrammer/markdown.nvim',
        as = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
        after = { 'nvim-treesitter' },
        config = function()
            require('render-markdown').setup({})
        end,
    })
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use({
        "v8yte/nvim-maketable",
        config = function ()
            require('nvim-maketable').setup({})
        end
    })

    -- Treesitter (syntax highlight)
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use({ "windwp/nvim-ts-autotag" })              -- treesitterを使用してHTMLタグを補完

    -- Github Copilot
    use({ "github/copilot.vim" })

    -- Indent Blankline
    use({ "lukas-reineke/indent-blankline.nvim" })

    -- Packerが自動インストールされた場合に設定を自動でセットアップ
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
