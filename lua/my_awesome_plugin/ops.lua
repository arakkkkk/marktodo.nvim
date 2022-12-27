local M = {}

function M.get_ops(options)
	local ops = {
		ops_defalut_bool = true,
	}
	ops = require("my_awesome_plugin.utils").tableMerge(ops, options)
	return ops
end

return M
