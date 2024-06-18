local status, null_ls = pcall(require, "null-ls")
if not status then return end

local status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status then return end

local capabilities = cmp_nvim_lsp.default_capabilities()

null_ls.setup({
    capabilities = capabilities,
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.diagnostics.zsh,
        null_ls.builtins.completion.spell,
    },
})
