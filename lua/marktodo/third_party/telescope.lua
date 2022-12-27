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

local function getColumnWidth(parsers, label, max_width)
	max_width = max_width or 9999
	local width = 0
	for _, parser in pairs(parsers) do
		local text = type(parser[label]) == "string" and parser[label] or table.concat(parser[label], ",")
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
	-- opts.layout_strategy = "vertical"
	-- opts.layout_config = { height = 0.8, width = 0.8 }
	-- opts.previewer = require("telescope.config").values.grep_previewer({})

	local widths = {}
	for _, v in pairs(getSortedColumns()) do
		table.insert(widths, { width = getColumnWidth(parsers, v.label, v.max_width) })
	end

	local displayer = entry_display.create({
		separator = marktodo.ops.separator,
		items = widths,
	})

	local make_display = function(parser)
		local displayers = {}
		for _, v in pairs(getSortedColumns()) do
			if type(parser[v.label]) == "string" then
				table.insert(displayers, parser[v.label])
			else
				table.insert(displayers, table.concat(parser[v.label], ","))
			end
		end
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
					actions.close(prompt_bufnr)
					local parser = action_state.get_selected_entry()
					vim.cmd(":e " .. parser.file_path)
					vim.cmd(":" .. parser.line_number)
				end)
				return true
			end,
			sorter = conf.generic_sorter(opts),
			-- previewer = conf.file_previewer({}),
			-- previewer = require('telescope.config').values.grep_previewer({})
		})
		:find()
end
