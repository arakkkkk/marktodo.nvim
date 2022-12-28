local pickers = require("telescope.pickers")
local themes = require("telescope.themes")
local previewers = require("telescope.previewers")
local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local marktodo = require("marktodo")

local function getSortedColumns()
	local res = {}
	local count = 0
	for _, _ in pairs(marktodo.ops.telescope_columns) do
		count = count + 1
		for _, col_ops in pairs(marktodo.ops.telescope_columns) do
			if tostring(col_ops.order) == tostring(count) then
				table.insert(res, col_ops)
				break
			end
		end
	end
	return res
end


local function createDisplayers(parser)
	-- Create list of column title of target parser(todo)
	local displayers = {}
	for _, v in pairs(getSortedColumns()) do
		if type(parser[v.label]) == "table" then
			local disp = v.replacer and v.replacer(parser) or table.concat(parser[v.label], " ")
			table.insert(displayers, disp)
		else
			local disp = v.replacer and v.replacer(parser) or parser[v.label]
			table.insert(displayers, disp)
		end
	end
	return displayers
end

local function getColumnWidth(parsers, col_number, max_width)
	max_width = max_width or 999
	-- if parser[label]
	local width = 0
	for _, parser in pairs(parsers) do
		local text = createDisplayers(parser)[col_number]
		if #text > width then
			width = #text
		end
		if #text > max_width then
			return max_width
		end
	end
	return width
end

return function(parsers, opts)
	opts = opts or {}

	local widths = {}
	for col_number, v in pairs(getSortedColumns()) do
		table.insert(widths, { width = getColumnWidth(parsers, col_number, v.max_width) })
	end

	local displayer = entry_display.create({
		separator = marktodo.ops.separator,
		items = widths,
	})

	local make_display = function(parser)
		local displayers = createDisplayers(parser)
		return displayer(displayers)
	end

	pickers
		.new(opts, {
			prompt_title = "Marktodo",
			finder = finders.new_table({
				results = parsers,
				entry_maker = function(parser)
					parser.value = parser.description
					parser.ordinal = parser.description
					parser.display = make_display
					parser.path = parser.file_path
					parser.lnum = parser.line_number
					return parser
				end,
			}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local parser = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.cmd(":e " .. parser.file_path)
					vim.cmd(":" .. parser.line_number)
				end)
				map("i", "<C-d>", function()
					actions.close(prompt_bufnr)
					local parser = action_state.get_selected_entry()
					io.popen('sed -i -e "' .. parser.line_number .. 's/\\[[ -]\\]/[X]/g" ' .. parser.file_path)
					vim.cmd("Marktodo")
				end)
				map("i", "<C-o>", function()
					actions.close(prompt_bufnr)
					local parser = action_state.get_selected_entry()
					io.popen('sed -i -e "' .. parser.line_number .. 's/\\[ \\]/[-]/g" ' .. parser.file_path)
					vim.cmd("Marktodo")
				end)
				map("n", "<C-d>", function()
					actions.close(prompt_bufnr)
					local parser = action_state.get_selected_entry()
					io.popen('sed -i -e "' .. parser.line_number .. 's/\\[[ -]\\]/[X]/g" ' .. parser.file_path)
					vim.cmd("Marktodo")
				end)
				map("i", "<C-o>", function()
					actions.close(prompt_bufnr)
					local parser = action_state.get_selected_entry()
					io.popen('sed -i -e "' .. parser.line_number .. 's/\\[ \\]/[-]/g" ' .. parser.file_path)
					vim.cmd("Marktodo")
				end)
				return true
			end,
			previewer = require("telescope.config").values.grep_previewer({}),
		})
		:find()
end
