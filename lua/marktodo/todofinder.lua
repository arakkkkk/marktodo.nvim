local marktodo = require("marktodo")
local grep = require("marktodo.third_party.grep")
local M = {}

function M.find(filter)
	filter = filter or {}
	filter.priotiry = filter.priotiry or "A-Z"
	filter.due = filter.due or "A-Z"

	local todo_lines = grep(vim.fn.getcwd(), marktodo.marktodo_pattern, "-tmd", marktodo.ops.exclude_ops)
	return todo_lines
end

return M
