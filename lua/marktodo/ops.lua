local M = {}

function M.get_ops(options)
	local ops = {
		sort = { "priority" }, -- priority, is available
		-- exclude_ops = "-g '!./**/.md'",
		only_top_level_tasks = true,
		telescope = true, -- Only true is supported now.
		telescope_width = vim.o.columns * 0.8,
		telescope_columns = {
			{ label = "priority", order = 1 },
			{ label = "file_path", order = 2, max_width = 15 },
			{ label = "description", order = 3, max_width = 30 },
			{ label = "project_tags", order = 4 },
			{ label = "context_tags", order = 5 },
			-- creation_date = { order = 3, width = 0.2 },
		},
		separator = "      ",
		marktodo_patterns = {
			completion = "- %[([x ])%]",
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
