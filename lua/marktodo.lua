local marktodo = {}

function marktodo.MarktodoSearch()
	local todo_lines = require("marktodo.todofinder").find()
	for i, line in pairs(todo_lines) do
		local parser = require("marktodo.todoparser").new(line.matched, line.file_path, line.line_number)
		parser:parse()
		todo_lines[i] = parser
	end
	todo_lines = require("marktodo.todosorter").sort(todo_lines)
	require("marktodo.third_party.telescope")(todo_lines)
end

function marktodo.setup(ops)
	ops = ops or {}
	marktodo.ops = require("marktodo.ops").get_ops(ops)

	local mp = marktodo.ops.marktodo_patterns
	marktodo.marktodo_pattern = mp.completion
		.. "%s*"
		.. "("
		.. mp.priority
		.. ")?"
		.. "%s*"
		.. "("
		.. mp.completion_date
		.. ")?"
		.. "%s*"
		.. "("
		.. mp.creation_date
		.. ")?"

	vim.api.nvim_create_user_command("Marktodo", function()
		marktodo.MarktodoSearch()
	end, {})
end

return marktodo
