local status, cmp = pcall(require, "cmp")
if not status then
	return
end -- nvim-cmpが正常に読み込めなかった場合は、以降の処理を中断

local status, luasnip = pcall(require, "luasnip")
if not status then
	return
end -- luasnipが正常に読み込めなかった場合は、以降の処理を中断

local status, lspkind = pcall(require, "lspkind")
if not status then
	return
end -- lspkindが正常に読み込めなかった場合は、以降の処理を中断

local map = cmp.mapping

cmp.setup({
	mapping = map.preset.insert({
		["<C-d>"] = map.scroll_docs(-4),
		["<C-f>"] = map.scroll_docs(4),
		["<C-Space>"] = map.complete(),
		["<C-e>"] = map.abort(),
		-- Enter キーの動作
		["<CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if luasnip.expandable() then
					-- 1) スニペットを展開
					luasnip.expand()
				else
					-- 2) スニペットが展開できない場合は補完を確定
					cmp.confirm({ select = true })
				end
			else
				-- 3) 補完ウィンドウが出ていない場合は通常の Enter
				fallback()
			end
		end, { "i", "s" }), -- インサートモード・スニペットモードで有効

		-- Tab キーの動作
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- 1) 補完ウィンドウが表示されていれば次の候補を選択
				cmp.select_next_item()
			elseif luasnip.locally_jumpable(1) then
				-- 2) スニペット中なら次のタブ停止位置へ
				luasnip.jump(1)
			else
				-- 3) どちらでもなければ通常の Tab
				fallback()
			end
		end, { "i", "s" }),

		-- Shift+Tab キーの動作
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				-- 補完ウィンドウが表示されていれば閉じる
				cmp.close()
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	-- completion = {
	--     keyword_length = 2,
	-- },
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	preselect = cmp.PreselectMode.None,
	sources = {
		{ name = "luasnip", priority = 100 },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "copilot" },
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol", -- シンボルアノテーションのみを表示
			maxwidth = 50, -- ポップアップが指定した文字数以上表示されないようにする
			ellipsis_char = "...", -- ポップアップメニューがmaxwidthを超える場合、切り捨てられた部分にellipsis_charを表示（最大幅を先に定義する必要がある）
			show_labelDetails = true, -- メニューにlabelDetailsを表示。デフォルトでは無効
		}),
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "nvim_lsp_document_symbol" },
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{
			name = "cmdline",
			option = {
				ignore_cmds = { "Man", "!" },
			},
		},
	}),
})
