local marktodo = require("marktodo")
-- print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

describe("marktodo", function()
	it("works!", function()
		local todo_lines = require("marktodo.todofinder").find()
		for i, line in pairs(todo_lines) do
			local parser = require("marktodo.todoparser").new(line.matched, line.file_path, line.line_number)
			parser:parse()
			todo_lines[i] = parser
		end
		todo_lines = require("marktodo.todosorter").sort(todo_lines)
		for _, line in pairs(todo_lines) do
			print(line.todo_line)
		end
	end)
end)
