local M = {}
local marktodo = require("marktodo")

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "marktodo://*",
	callback = function()
		-- initial set
		vim.cmd("set filetype=marktodo_list")
		-- create buf
		local bufnr = vim.api.nvim_win_get_buf(0)
		vim.fn.setbufvar(bufnr, "scratch", "nomodified")
		vim.bo[bufnr]["buftype"] = "nofile"
		vim.bo[bufnr]["modifiable"] = false

		local todo_lines = require("marktodo.todofinder").find(marktodo.ops.root_path)
		local parsers = {}
		for _, line in pairs(todo_lines) do
			local parser = require("marktodo.todoparser").new(line.matched, line.file_path, line.line_number)
			parser:parse()
			_ = parser:show() and table.insert(parsers, parser)
		end
		marktodo.parsers = require("marktodo.todosorter").sort(parsers)

		require("marktodo.view.commands").create()
		require("marktodo.view.render").render(0)
		require("marktodo.view.keymap").create()
	end,
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "marktodo://*",
	callback = function()
		require("marktodo.view.commands").del()
	end,
})

function M.open()
	vim.cmd("e marktodo://./")
end

return M
