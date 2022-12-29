local marktodo = require("marktodo")
local grep = require("marktodo.third_party.grep")
local M = {}

function M.find(root_path, filter)
	filter = filter or {}
	filter.priotiry = filter.priotiry or "A-Z"
	filter.due = filter.due or "A-Z"

	print(root_path)
	print(root_path)
	print(root_path)
	local todo_lines = grep(root_path, marktodo.marktodo_pattern, "-tmd", marktodo.ops.exclude_ops)
	return todo_lines
end

return M
