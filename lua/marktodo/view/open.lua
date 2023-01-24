local M = {}
local marktodo = require("marktodo")

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "marktodo://*",
	callback = function()
		-- create buf
		local bufnr = vim.api.nvim_win_get_buf(0)
		vim.fn.setbufvar(bufnr, "scratch", "nomodified")
		vim.bo[bufnr]["filetype"] = "marktodo_list"
		vim.bo[bufnr]["bufhidden"] = "delete"
		vim.bo[bufnr]["swapfile"] = false
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
		require("marktodo.view.syntax").set()
	end,
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "marktodo://*",
	callback = function()
		require("marktodo.view.commands").del()
	end,
})

function M.open(root_path, window_type)
	marktodo.ops.root_path = root_path or marktodo.ops.default_root_path or vim.fn.getcwd()
	marktodo.ops.root_path = marktodo.ops.root_path:gsub("^~", os.getenv("HOME"))

	if window_type == "right" then
		vim.cmd("vsplit")
		vim.cmd("wincmd L")
	elseif window_type == "left" then
		vim.cmd("vsplit")
		vim.cmd("wincmd H")
	elseif window_type == "top" then
		vim.cmd("split")
		vim.cmd("wincmd K")
	elseif window_type == "bottom" then
		vim.cmd("split")
		vim.cmd("wincmd J")
	elseif window_type == "float" then
		local win_conf = {
			relative = "editor",
			row = 5,
			col = 10,
			width = vim.o.columns - 10 * 2,
			height = vim.fn.winheight(0) - 5 * 2,
			border = { "x", "═", "x", "║", "x", "═", "x", "║" },
			style = "minimal",
			zindex = 10,
		}
		local win = vim.api.nvim_open_win(0, true, win_conf)
		vim.api.nvim_win_set_option(win, "winhighlight", "NormalFloat:Normal")
	end
	vim.cmd("e marktodo://./")
	vim.cmd(":4")
	marktodo.bufnr = vim.api.nvim_win_get_buf(0)
end

return M
