local M = {}
function M.status_smart(opts)
	local res = {
		label = "S" or opts.label,
		order = opts.order,
		max_width = opts.max_width,
		replacer = function(todo)
			return (todo.completion or " ") .. (todo.priority or " ")
		end,
	}
	return res
end
function M.status(opts)
	local res = {
		label = "S" or opts.label,
		order = opts.order,
		max_width = opts.max_width,
		replacer = function(todo)
			return todo.completion or " "
		end,
	}
	return res
end
function M.priority(opts)
	local res = {
		label = "P" or opts.label,
		order = opts.order,
		max_width = opts.max_width,
		replacer = function(todo)
			return (todo.priority or " ")
		end,
	}
	return res
end
function M.file_smart(opts)
	local res = {
		label = "File" or opts.label,
		order = opts.order,
		max_width = opts.max_width,
		replacer = function(todo)
			local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
			local disp = ""
			for m in abs_path:gmatch("([^/])[^/]+/") do
				disp = disp .. m .. "/"
			end
			local file_name = abs_path:match("^([^/]+)/") or abs_path
			return disp .. file_name
		end,
	}
	return res
end
function M.projects(opts)
	local res = {
		label = "Project" or opts.label,
		order = opts.order,
		max_width = opts.max_width,
		replacer = function(todo)
			-- Separate project tags by comma
			return table.concat(todo.project_tags, " ")
		end,
	}
	return res
end
function M.contexts(opts)
	local res = {
		label = "Context" or opts.label,
		order = opts.order,
		max_width = opts.max_width,
		replacer = function(todo)
			-- Separate project tags by comma
			return table.concat(todo.context_tags, " ")
		end,
	}
	return res
end
function M.due(opts)
	local res = {
		label = "Context" or opts.label,
		order = opts.order,
		max_width = opts.max_width,
		replacer = function(todo)
			if todo.special_keyvalue_tags.due then
				return "due:" .. todo.special_keyvalue_tags.due
			end
			return ""
		end,
	}
	return res
end

return M
