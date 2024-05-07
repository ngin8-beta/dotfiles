local status, luasnip = pcall(require, "luasnip.loaders.from_vscode")
-- プラグインが正常に読み込めなかった場合は、以降の処理を中断
if not status then return end

luasnip.lazy_load()
