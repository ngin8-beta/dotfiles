local status, builtin = pcall(require, "telescope.builtin")
-- プラグインが正常に読み込めなかった場合は、以降の処理を中断
if not status then return end


vim.keymap.set("n", "<leader>ff", builtin.find_files, {})                      -- ファイル検索
vim.keymap.set("n", "<leader>fd", ":Telescope find_files hidden=true<cr>", {}) -- ファイル検索(.ファイルあり)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})                       -- テキスト検索
vim.keymap.set("n", "<leader>gs", builtin.git_status, {})                      -- git status
vim.keymap.set("n", "<leader>gl", builtin.git_commits, {})                     -- git log
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})                         -- バッファの操作
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})                        -- 履歴の操作
vim.keymap.set("n", "<leader>fv", builtin.vim_options, {})                     -- vim_optionsの一覧
vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})                         -- keymapの一覧
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})                       -- help tagの一覧

-- HELP関数の定義
local function display_telescope_help()
  local lines = {
    "Telescope キーマップの説明",
    "<space>ff   - 通常のファイル検索",
    "<space>fd   - 隠しファイルを含むファイル検索",
    "<space>fg   - ファイル内のテキスト検索",
    "<space>gs   - Gitステータスの表示",
    "<space>gl   - Gitログの表示",
    "<space>fb   - 開いているバッファの一覧",
    "<space>fo   - 最近開いたファイルの一覧",
    "<space>fv   - Vimのオプション設定の一覧",
    "<space>fk   - キーマップの一覧",
    "<space>fh   - ヘルプタグの検索",
    "q, <Esc>    - このウィンドウを閉じる"
  }

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  local width = math.ceil(vim.api.nvim_get_option("columns") * 0.75)
  local height = math.ceil(vim.api.nvim_get_option("lines") * 0.75)
  local row = math.ceil((vim.api.nvim_get_option("lines") - height) / 2)
  local col = math.ceil((vim.api.nvim_get_option("columns") - width) / 2)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
  }

  vim.api.nvim_open_win(bufnr, true, opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', '<cmd>close<CR>', { noremap = true, silent = true })
end

vim.api.nvim_create_user_command('TelescopeHelp', display_telescope_help, {})

