local status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status then return end

local status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status then return end

local capabilities = cmp_nvim_lsp.default_capabilities()

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
    }
  end,
}
