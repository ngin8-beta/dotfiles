local status, cmp = pcall(require, "cmp")
if not status then return end  -- nvim-cmpが正常に読み込めなかった場合は、以降の処理を中断

local status, luasnip = pcall(require, "luasnip")
if not status then return end  -- luasnipが正常に読み込めなかった場合は、以降の処理を中断

local status, lspkind = pcall(require, "lspkind")
if not status then return end  -- lspkindが正常に読み込めなかった場合は、以降の処理を中断

local map = cmp.mapping

cmp.setup({
  mapping = map.preset.insert({
    ['<C-d>'] = map.scroll_docs(-4),
    ['<C-f>'] = map.scroll_docs(4),
    ['<C-Space>'] = map.complete(),
    ['<C-e>'] = map.abort(),
    ['<CR>'] = map.confirm { select = false },
  }),
  sources = cmp.config.sources({
    { name = 'buffer'},
    { name = 'path'},
    { name = 'nvim_lsp'},
    { name = 'nvim_lua'},
    { name = 'luasnip'},
  }),
  snippet = ({
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  }),
  formatting = ({
    format = lspkind.cmp_format({
      mode = 'symbol',          -- シンボルアノテーションのみを表示
      maxwidth = 50,            -- ポップアップが指定した文字数以上表示されないようにする
      ellipsis_char = '...',    -- ポップアップメニューがmaxwidthを超える場合、切り捨てられた部分にellipsis_charを表示（最大幅を先に定義する必要がある）
      show_labelDetails = true, -- メニューにlabelDetailsを表示。デフォルトでは無効
    })
  })
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  },
  {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' }
      }
    }
  })
})
