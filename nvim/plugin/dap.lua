local dap, dapui = require("dap"), require("dapui")
local dapgo = require("dap-go")
dapui.setup()
dapgo.setup()
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

-- Include the next few lines until the comment only if you feel you need it
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
-- Include everything after this

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

vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
	require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
	require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
	require("dap").set_breakpoint()
end)
vim.keymap.set("n", "<Leader>l", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>r", function()
	require("dap").repl.open()
end)
vim.keymap.set("n", "<Leader>l", function()
	require("dap").run_last()
end)

vim.keymap.set("n", "<Leader>z", function()
	dapui.open()
end)
vim.keymap.set("n", "<Leader>Z", function()
	dapui.close()
end)
