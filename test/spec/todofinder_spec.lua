local marktodo = require("marktodo")
-- print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

describe("todofinder_find", function()
   it('works!', function()
     local todo_lines = require("marktodo.todofinder").find()
     for _, line in pairs(todo_lines) do
       assert(type(line.file_path) == "string", line.file_path)
       assert(type(line.line_number) == "string", line.line_number)
       assert(type(line.col_number) == "string", line.col_number)
       assert(type(line.matched) == "string", line.matched)
     end
   end)
end)
