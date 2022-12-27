local marktodo = {}

function marktodo.MarktodoSearch()
	local todo_lines = require("marktodo.todofinder").find()
	local parsers = {}
	for _, line in pairs(todo_lines) do
		local parser = require("marktodo.todoparser").new(line.matched, line.file_path, line.line_number)
		parser:parse()
		if parser.completion == "x" or parser.completion == "X" then
		else
			table.insert(parsers, parser)
		end
	end
	parsers = require("marktodo.todosorter").sort(parsers)
	require("marktodo.third_party.telescope")(parsers)
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

	if marktodo.ops.only_top_level_tasks then
		marktodo.marktodo_pattern = "^" .. marktodo.marktodo_pattern
	end


	vim.api.nvim_create_user_command("Marktodo", function()
		marktodo.MarktodoSearch()
	end, {})
end

return marktodo
