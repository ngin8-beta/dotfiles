local status, mason = pcall(require, "mason")
-- プラグインが正常に読み込めなかった場合は、以降の処理を中断
if not status then return end

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
