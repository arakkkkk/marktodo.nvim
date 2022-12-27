TodoParser = {}

TodoParser.new = function(todo_line, file_path, line_number)
	local obj = {}
	obj.todo_line = todo_line
	obj.file_path = file_path
	obj.line_number = line_number

	obj.getPriotiry = function(self)
		return self.todo_line
	end

	return obj
end

return TodoParser
