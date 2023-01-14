local marktodo = require("marktodo")
-- print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

-- describe("todoparser_pser", function()
-- 	it("works!", function()
-- 		local todo_lines = require("marktodo.todofinder").find(vim.fn.getcwd())
-- 		for _, line in pairs(todo_lines) do
-- 			local parser = require("marktodo.todoparser").new(line.matched, line.file_path, line.line_number)
-- 			assert(type(parser:isComplete()) == "boolean")
-- 			parser:parse()
-- 			assert(type(parser:getProjectTags()) == "table")
-- 			assert(type(parser:getContextTags()) == "table")
-- 			assert(type(parser:getSpecialKeyvalueTags()) == "table")
-- 		end
-- 	end)
-- end)
