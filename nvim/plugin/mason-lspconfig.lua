local status, mason_lspconfig = pcall(require, "mason-lspconfig")
-- プラグインが正常に読み込めなかった場合は、以降の処理を中断
if not status then return end

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
    }
  end,
}
