local function require_ok(mod)
	local ok, lib = pcall(require, mod)
	if not ok then
		return nil
	end
	return lib
end

local dap = require_ok("dap")
local dapui = require_ok("dapui")
local dapgo = require_ok("dap-go")

if not (dap and dapui and dapgo) then
	return
end

dapui.setup({
	icons = { expanded = "", collapsed = "" },
	layouts = {
		{
			elements = {
				{
					id = "scopes",
					size = 0.25,
				},
				{
					id = "breakpoints",
					size = 0.25,
				},
				{
					id = "stacks",
					size = 0.25,
				},
				{
					id = "watches",
					size = 0.25,
				},
			},
			size = 64,
			position = "right",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 0.20,
			position = "bottom",
		},
	},
})

dapgo.setup()

-- ========================================================
-- キーマップ
-- ========================================================
local map = vim.keymap.set
local opts = { silent = true }

-- 基本操作（Fキー）
map("n", "<F5>", dap.continue, vim.tbl_extend("force", opts, { desc = "DAP Continue" }))
map("n", "<F10>", dap.step_over, vim.tbl_extend("force", opts, { desc = "DAP Step Over" }))
map("n", "<F11>", dap.step_into, vim.tbl_extend("force", opts, { desc = "DAP Step Into" }))
map("n", "<F12>", dap.step_out, vim.tbl_extend("force", opts, { desc = "DAP Step Out" }))

-- ブレークポイント
map("n", "<Leader>b", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "DAP Toggle Breakpoint" }))
map("n", "<Leader>B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, vim.tbl_extend("force", opts, { desc = "DAP Conditional Breakpoint" }))
map("n", "<Leader>lp", function()
	dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, vim.tbl_extend("force", opts, { desc = "DAP Log Point" }))

-- REPL / 直前の実行
map("n", "<Leader>dr", dap.repl.open, vim.tbl_extend("force", opts, { desc = "DAP REPL Open" }))
map("n", "<Leader>dl", dap.run_last, vim.tbl_extend("force", opts, { desc = "DAP Run Last" }))

-- UI操作
map("n", "<Leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "DAP UI Toggle" }))
map("n", "<Leader>z", dapui.open, vim.tbl_extend("force", opts, { desc = "DAP UI Open" }))
map("n", "<Leader>Z", dapui.close, vim.tbl_extend("force", opts, { desc = "DAP UI Close" }))

-- Go
map("n", "<Leader>dt", function()
	dapgo.debug_test()
end, vim.tbl_extend("force", opts, { desc = "DAP-Go Debug Test" }))
map("n", "<Leader>dT", function()
	dapgo.debug_last_test()
end, vim.tbl_extend("force", opts, { desc = "DAP-Go Debug Last Test" }))
