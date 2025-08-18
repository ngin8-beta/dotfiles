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
    print("Installing packer close and reopen Neovim...") -- Packerのインストール完了後、Neovimを再起動するよう指示
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
    return
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
    use({ "wbthomason/packer.nvim" }) -- Packer自体
    use({ "nvim-lua/plenary.nvim" })  -- 汎用ユーティリティ

    -- カラースキーム
    use({ "EdenEast/nightfox.nvim" })

    -- ステータスライン
    use({ "nvim-lualine/lualine.nvim" })    -- ステータスラインの強化
    use({ "windwp/nvim-autopairs" })        -- 自動括弧補完
    use({ "kyazdani42/nvim-web-devicons" }) -- ファイルアイコン

    -- ファイラー
    use({ "nvim-tree/nvim-tree.lua" })

    -- 補完関連のプラグイン
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind-nvim",
            { "hrsh7th/cmp-buffer",                   after = "nvim-cmp" },
            { "hrsh7th/cmp-path",                     after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline",                  after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua",                 after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip",             after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
            { "hrsh7th/cmp-copilot",                  after = "nvim-cmp" },
        },
        config = [[require('config.cmp')]],
        event = 'InsertEnter',
        wants = 'LuaSnip',
    })

    -- Github Copilot
    use({ "github/copilot.vim" })

    -- スニペット
    use({
        "L3MON4D3/LuaSnip",
        run = "make install_jsregexp"
    }) -- スニペットエンジン

    -- debugger
    use({ "mfussenegger/nvim-dap" }) -- DAP（デバッガーアダプタープロトコル）
    use({ "nvim-neotest/nvim-nio" })
    use({
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
    })
    use({
        "leoluz/nvim-dap-go",
        requires = { "mfussenegger/nvim-dap" }
    }) -- Go言語用のDAP設定


    -- LSP（言語サーバープロトコル）
    use({
        "williamboman/mason.nvim", -- LSP/DAP/リンター/フォーマッターインストーラー
        requires = {
            "neovim/nvim-lspconfig",
            "williamboman/mason-lspconfig.nvim",
            "jay-babu/mason-null-ls.nvim",
        }
    })
    use({
        'nvimdev/lspsaga.nvim', -- LSPのUI強化
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
        config = function()
            require('nvim-maketable').setup({})
        end
    })

    -- Treesitter (syntax highlight)
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use({ "windwp/nvim-ts-autotag" }) -- treesitterを使用してHTMLタグを補完

    -- Indent Blankline
    use({ "lukas-reineke/indent-blankline.nvim" })

    -- tab
    use({
        'akinsho/bufferline.nvim',
        tag = "*",
        requires = 'nvim-tree/nvim-web-devicons',
    })

    -- Packerが自動インストールされた場合に設定を自動でセットアップ
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
