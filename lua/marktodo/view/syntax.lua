local M = {}

function M.set()
	local marktodo = require("marktodo")
	local hi = vim.api.nvim_buf_add_highlight
	hi(0, 0, "marktodoFilterHead", 0, 0, 9)
	hi(0, 0, "marktodoFilterBody", 0, 9, -1)
	hi(0, 0, "marktodoHeader", 1, 0, -1)
	hi(0, 0, "marktodoHeaderline", 2, 0, -1)
	vim.cmd("syntax match marktodoProjects '+[a-zA-Z0-9_-]\\+'")
	vim.cmd("syntax match marktodoContexts '@[a-zA-Z0-9_-]\\+'")
	vim.cmd("syntax match marktodoDueToday 'due:" .. os.date("%Y-%m-%d") .. "'")
	for i, parser in pairs(marktodo.parsers) do
		if parser.completion == "-" then
			hi(0, 0, "marktodoProgress", i + 2, 0, -1)
		end
	end

	vim.api.nvim_set_hl(0, "marktodoFilterHead", {
		fg = "#de8c92",
	})
	vim.api.nvim_set_hl(0, "marktodoFilterBody", {
		fg = "#3b4252",
	})
	vim.api.nvim_set_hl(0, "marktodoHeader", {
		bold = true,
	})
	vim.api.nvim_set_hl(0, "marktodoHeaderline", {
		-- bold = true,
	})
	vim.api.nvim_set_hl(0, "marktodoProgress", {
		bg = "#434c5e",
	})
	vim.api.nvim_set_hl(0, "marktodoContexts", {
		fg = "#61afef",
	})
	vim.api.nvim_set_hl(0, "marktodoProjects", {
		fg = "#ebae34",
	})
	vim.api.nvim_set_hl(0, "marktodoDueToday", {
		fg = "#f9d71c",
		bold = true,
	})
end
return M
