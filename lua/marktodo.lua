local marktodo = {}

function marktodo.telescope(root_path)
	marktodo.ops.root_path = root_path or marktodo.ops.default_root_path or vim.fn.getcwd()
	marktodo.ops.root_path = marktodo.ops.root_path:gsub("^~", os.getenv("HOME"))
	local todo_lines = require("marktodo.todofinder").find(marktodo.ops.root_path)
	local parsers = {}
	for _, line in pairs(todo_lines) do
		local parser = require("marktodo.todoparser").new(line.matched, line.file_path, line.line_number)
		parser:parse()
		_ = parser:show() and table.insert(parsers, parser)
	end
	marktodo.parsers = require("marktodo.todosorter").sort(parsers)
	require("marktodo.third_party.telescope")()
end

function marktodo.argParser(arg)
	local atab = {}
	-- Restrict json arg
	local json_arg_pattern = "%S+%s*=%s*%{[^{]*%}"
	for json_arg in arg.args:gmatch(json_arg_pattern) do
		arg.args = arg.args:gsub(json_arg_pattern, "")
		json_arg = json_arg:gsub("'", '"')
		local key = json_arg:match("(%S+)%s*=")
		local val = vim.json.decode(json_arg:match("=%s*(%S+)"))
		atab[key] = val
	end
	-- Restrict string arg
	local str_arg_pattern = "%S+%s*=%s*%S+"
	for str_arg in arg.args:gmatch(str_arg_pattern) do
		arg.args = arg.args:gsub(str_arg_pattern, "")
		local key = str_arg:match("(%S+)%s*=")
		local val = str_arg:match("=%s*(%S+)")
		atab[key] = val
	end
	return atab
end

function marktodo.setup(ops)
	ops = ops or {}
	marktodo.ops = require("marktodo.ops").get_ops(ops)

	local status_ok, fault = pcall(require, "marktodo.third_party.cmp")
	require("marktodo.view.open")

	local mp = marktodo.ops.marktodo_patterns
	marktodo.marktodo_pattern = mp.completion
		.. "%s*"
		.. "("
		.. mp.priority
		.. ")?"
		.. "%s*"
		.. "("
		.. mp.completion_date
		.. ")?"
		.. "%s*"
		.. "("
		.. mp.creation_date
		.. ")?"

	marktodo.marktodo_pattern = "^" .. marktodo.marktodo_pattern

	vim.api.nvim_create_user_command("Marktodo", function(arg)
		local args = marktodo.argParser(arg)
		require("marktodo").ops.filter = args.filter or require("marktodo").ops.filter
		if arg.args:match("^%s*full%s*$") then
			require("marktodo.view.open").open(args.root_path, "full")
		elseif arg.args:match("^%s*left%s*$") then
			require("marktodo.view.open").open(args.root_path, "left")
		elseif arg.args:match("^%s*right%s*$") then
			require("marktodo.view.open").open(args.root_path, "right")
		elseif arg.args:match("^%s*top%s*$") then
			require("marktodo.view.open").open(args.root_path, "top")
		elseif arg.args:match("^%s*bottom%s*$") then
			require("marktodo.view.open").open(args.root_path, "bottom")
		elseif arg.args:match("^%s*float%s*$") then
			require("marktodo.view.open").open(args.root_path, "float")
		elseif arg.args:match("^%s*telescope%s*$") then
			marktodo.telescope(args.root_path)
		else
			marktodo.telescope(args.root_path)
		end
	end, { nargs = "*" })
end

return marktodo
