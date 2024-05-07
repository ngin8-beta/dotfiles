local status, treesitter = pcall(require, "nvim-treesitter.configs")
-- プラグインが正常に読み込めなかった場合は、以降の処理を中断
if not status then return end

treesitter.setup {
  highlight = {
    enable = true,    -- syntax highlightを有効にする
    disable = {},     -- 一部の言語では無効にする
    indent = {
      enable = true,  -- treesitterによるインデントを有効
    }
  },
  autotag = {
    enable = true,    -- HTMLタグの補完
  }
}
