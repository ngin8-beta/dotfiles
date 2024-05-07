local status, prettier = pcall(require, "prettier")
if (not status) then return end

prettier.setup {
  bin = 'prettier',
  -- prettierによる整形を適用するファイルタイプ
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },

  arrow_parens = "always",                -- アロー関数の引数を常に括弧で囲む
  bracket_spacing = true,                 -- オブジェクトリテラルの括弧内にスペースを入れる
  embedded_language_formatting = "auto",  -- 埋め込まれた言語のフォーマットを自動で決定
  end_of_line = "lf",                     -- ファイルの終わりの改行コードをLFにする
  html_whitespace_sensitivity = "css",    -- HTMLの空白の感度をCSSのスタイルに依存させる
  jsx_bracket_same_line = false,          -- JSXの閉じ括弧を同じ行に置くか（falseは改行して置く）
  jsx_single_quote = false,               -- JSX内でシングルクォートを使用しない
  print_width = 80,                       -- 1行の最大幅を80文字に設定
  prose_wrap = "preserve",                -- プローズテキストをどのように折り返すか設定
  quote_props = "as-needed",              -- オブジェクトのプロパティ名を必要に応じて引用符で囲む
  semi = true,                            -- 文の末尾にセミコロンを付ける
  single_quote = false,                   -- シングルクォートを使用しない（ダブルクォートを使用）
  tab_width = 2,                          -- タブ幅を2に設定
  trailing_comma = "es5",                 -- 末尾のカンマのスタイルをes5に設定
  use_tabs = false,                       -- タブを使用せずスペースを使用
  vue_indent_script_and_style = false,    -- Vueファイル内のscriptとstyleタグをインデントしない
}

-- ';' + 'a' キーで非同期でフォーマットを実行するキーマップを設定
vim.keymap.set('n', ';a',
  function()
    vim.lsp.buf.format({ async = true })
  end
)
