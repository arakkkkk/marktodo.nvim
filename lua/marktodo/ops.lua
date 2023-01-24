local M = {}

function M.get_ops(options)
	local ops = {
		sort = { "priority", "project_tags", "completion" }, -- last is precedence
		-- filter = { completion = "[ -]", priority = "[A-Z ]" },
		filter = "completion:[%s-] and priority:[A-Z]",
		-- exclude_ops = "-g '!./**/.md'",
		-- default_root_path = "path/to/default/root",
		telescope_width = vim.o.columns * 0.8,
		description_display = {
			context_tags = true,
			project_tags = false,
			special_keyvalue_tags = false,
		},
		columns = {
			require("marktodo.view.column_set").status({ order = 1 }),
			require("marktodo.view.column_set").priority({ order = 2 }),
			require("marktodo.view.column_set").file_smart({ order = 3, max_width = 15 }),
			{ label = "description", order = 4, max_width = 30 },
			require("marktodo.view.column_set").projects({ order = 5 }),
			require("marktodo.view.column_set").contexts({ order = 6 }),
			require("marktodo.view.column_set").due_day_count({ order = 7 }),
		},
		separator = "      ",
		marktodo_patterns = {
			completion = "- %[([xX -])%]",
			priority = "%(([A-Z ]?)%)",
			completion_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
			creation_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
			-- description is follow above
		},
		description_patterns = {
			project_tags = "(%+%S+)",
			context_tags = "(@%S+)",
			special_keyvalue_tags = "((%S+):(%S+))",
		},
	}
	ops.columns = options.columns and {} or ops.columns
	ops = require("marktodo.utils").tableMerge(ops, options)
	return ops
end

return M
