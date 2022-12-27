local M = {}

function M.get_ops(options)
	local ops = {
		sort = {"priority"}, -- priority, is available
		telescope = true, -- Only true is supported now.
		telescope_width = vim.o.columns * 0.8,
		telescope_columns = {
			{ label = "priority", order = 1 },
			{ label = "description", order = 2, width = 0.5 },
			{ label = "project_tags", order = 3, width = 0.2 },
			{ label = "context_tags", order = 4, width = 0.2 },
			-- creation_date = { order = 3, width = 0.2 },
		},
		separator = "      ",
		-- TODO: max_width
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
