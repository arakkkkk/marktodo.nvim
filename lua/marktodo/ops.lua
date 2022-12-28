local M = {}

function M.get_ops(options)
	local ops = {
		sort = { "priority", "completion" }, -- last is precedence
		-- exclude_ops = "-g '!./**/.md'",
		only_top_level_tasks = true,
		telescope = true, -- Only true is supported now.
		telescope_width = vim.o.columns * 0.8,
		telescope_columns = {
			-- { label = "priority", order = 1 },
			{
				label = "status",
				order = 1,
				replacer = function(todo)
					return todo.priority .. " " .. todo.completion
				end,
			},
			-- 	local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
			-- { label = "absolute_file_path", order = 2, replacer = function(todo)
			-- 	return todo.file_path:sub(#vim.fn.getcwd() + 2)
			-- end },
			{
				label = "smart_file_path",
				order = 2,
				max_width = 15,
				replacer = function(todo)
					local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
					local disp = ""
					for m in abs_path:gmatch("([^/])[^/]+/") do
						disp = disp .. m .. "/"
					end
					return disp .. todo.file_path:match("/([^/]+).md$")
				end,
			},
			-- { label = "file_name", order = 2, max_width = 10, replacer = function(todo)
			-- 	return todo.file_path:match("/([^/]+).md$")
			-- end },
			-- { label = "dir_name", order = 2, max_width = 10, replacer = function(todo)
			-- 	local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
			-- 	return abs_path:match("^([^/]+)/")
			-- end },
			{ label = "description", order = 3, max_width = 30 },
			{
				label = "project_tags",
				order = 4,
				replacer = function(todo)
					-- Separate project tags by comma
					return table.concat(todo.project_tags, " ")
				end,
			},
			{ label = "context_tags", order = 5 },
			-- creation_date = { order = 3, width = 0.2 },
		},
		separator = "      ",
		marktodo_patterns = {
			completion = "- %[([xX -])%]",
			priority = "%(([A-Z ]?)%)",
			completion_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
			creation_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
			-- description is follor above
		},
		desciption_patterns = {
			project_tags = "(%+%S+)",
			context_tags = "(@%S+)",
			special_keyvalue_tags = "(%S+:%S+)",
		},
	}
	ops = require("marktodo.utils").tableMerge(ops, options)
	return ops
end

return M
