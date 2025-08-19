local lspkind = require("lspkind")

lspkind.init({
	symbol_map = {
		Text = "  Text",
		Function = "  Function",
		Method = "  Method",
		Constructor = "  Constructor",
		Field = "  Field",
		Variable = "  Variable",
		Class = "  Class",
		Interface = "  Interface",
		Module = "  Module",
		Property = "  Property",
		Unit = "  Unit",
		Value = "  Value",
		Enum = "  Enum",
		Keyword = "  Keyword",
		Snippet = "  Snippet",
		Color = "  Color",
		File = "  File",
		Reference = "  Reference",
		Folder = "  Folder",
		EnumMember = "  EnumMember",
		Constant = "  Constant",
		Struct = "  Struct",
		Event = "  Event",
		Operator = "  Operator",
		TypeParameter = "  TypeParameter",
		Copilot = "  Copilot",
	},
})

-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
