local M = {}

function M.create()
	local marktodo = require("marktodo")
	local ops = require("marktodo").ops
	local utils = require("marktodo.utils")
	local function get_cur_task()
		if vim.fn.line(".") < 4 then
			return nil
		else
			return marktodo.parsers[vim.fn.line(".") - 3]
		end
	end

	vim.api.nvim_create_user_command("TodoFilter", function()
		local filter_param = utils.input("Filter: /", ops.filter)
		ops.filter = filter_param
		vim.bo[0]["modifiable"] = true
		vim.api.nvim_buf_set_lines(0, 0, 1, true, { "Filter: /" .. filter_param })
		vim.bo[0]["modifiable"] = false
		vim.cmd("e")
	end, {})
	vim.api.nvim_create_user_command("TodoOpen", function()
		local parser = get_cur_task()
		if not parser then
			return
		end
		vim.cmd("e " .. parser.file_path)
		vim.cmd(":" .. parser.line_number)
	end, {})
	vim.api.nvim_create_user_command("TodoComplete", function()
		local parser = get_cur_task()
		if not parser then
			return
		end
		io.popen('sed -i "" -e "' .. parser.line_number .. 's/\\[.\\]/[x]/g" ' .. parser.file_path)
		vim.cmd("e")
	end, {})
	vim.api.nvim_create_user_command("TodoProgress", function()
		local parser = get_cur_task()
		if not parser then
			return
		end
		io.popen('sed -i "" -e "' .. parser.line_number .. 's/\\[.\\]/[-]/g" ' .. parser.file_path)
		vim.cmd("e")
	end, {})
	vim.api.nvim_create_user_command("TodoSetPriority", function()
		local parser = get_cur_task()
		if not parser then
			return
		end
		local priority = utils.input("Project: ")
		if priority then
			io.popen(
				'sed -i "" -e "'
					.. parser.line_number
					.. "s/\\([A-Za-z0-9]\\)/["
					.. priority
					.. ']/g" '
					.. parser.file_path
			)
		end
		vim.cmd("e")
	end, {})
	vim.api.nvim_create_user_command("TodoSetProject", function()
		local parser = get_cur_task()
		if not parser then
			return
		end
		local project = utils.input("Project: ")
		if project then
			io.popen('sed -i "" -e "' .. parser.line_number .. "s/$/ +" .. project .. '/g" ' .. parser.file_path)
		end
		vim.cmd("e")
	end, {})
	vim.api.nvim_create_user_command("TodoSetDue", function()
		local parser = get_cur_task()
		if not parser then
			return
		end
		local due = utils.input("Project: ")
		if due then
			io.popen('sed -i "" -e "' .. parser.line_number .. "s/$/ due:" .. due .. '/g" ' .. parser.file_path)
		end
		vim.cmd("e")
	end, {})
	vim.api.nvim_create_user_command("TodoModify", function()
		local parser = get_cur_task()
		if not parser then
			return
		end
		local modify = utils.input("Modify: ", parser.todo_line)
		if modify then
			io.popen('sed -i "" -e "' .. parser.line_number .. "s/^.*$/" .. modify .. '/g" ' .. parser.file_path)
		end
		vim.cmd("e")
	end, {})
end

function M.del() end

return M
