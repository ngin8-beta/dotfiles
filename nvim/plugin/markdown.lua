-- ================================================ --
--                     HELP
-- ================================================ --
local utils = require("utils")

local function display_markdown_cheatsheet()
	local lines = {}
	for line in io.lines(os.getenv("XDG_CONFIG_HOME") .. "/nvim/markdown-cheat-sheet.jax") do
		table.insert(lines, line)
	end

	utils.show_floating_window(lines, " Markdown チートシート ")
end

vim.api.nvim_create_user_command("MarkdownCheatSheet", display_markdown_cheatsheet, {})
