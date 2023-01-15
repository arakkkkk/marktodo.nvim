local M = {}

function M.get_ops(options)
	local ops = {
		sort = { "priority", "project_tags", "completion" }, -- last is precedence
		filter = { completion = "[ -]", priority = "[A-Z ]" },
		-- exclude_ops = "-g '!./**/.md'",
		-- default_root_path = "path/to/default/root",
		only_top_level_tasks = true,
		telescope = true, -- Only true is supported now.
		telescope_width = vim.o.columns * 0.8,
		description_display = {
			context_tags = true,
			project_tags = false,
			special_keyvalue_tags = false,
		},
		telescope_columns = {
			-- { label = "priority", order = 1 },
			{
				label = "status",
				order = 1,
				replacer = function(todo)
					return todo.priority .. " " .. todo.completion
				end,
			},
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
					local file_name = abs_path:match("^([^/]+)/") or abs_path
					return disp .. file_name
				end,
			},
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
		description_patterns = {
			project_tags = "(%+%S+)",
			context_tags = "(@%S+)",
			special_keyvalue_tags = "(%S+:%S+)",
		},
	}
	ops.telescope_columns = options.telescope_columns and {} or ops.telescope_columns
	ops = require("marktodo.utils").tableMerge(ops, options)
	return ops
end

return M
