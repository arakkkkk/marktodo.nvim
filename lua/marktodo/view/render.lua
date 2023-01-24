local M = {}

local function getSortedColumns()
	local marktodo = require("marktodo")
	local res = {}
	local count = 0
	for _, _ in pairs(marktodo.ops.columns) do
		count = count + 1
		for _, col_ops in pairs(marktodo.ops.columns) do
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

local function getColumnWidth(row, col_number, max_width)
	max_width = max_width or 999
	local width = 0
	for _, cols in pairs(row) do
		local text = cols[col_number]
		assert(text, "Please check setup options in columns in col number " .. tostring(col_number))
		if #text > width then
			width = #text
		end
		if #text > max_width then
			return max_width
		end
	end
	return width
end

local function setColsWidth(cols, widths)
	for i, col in pairs(cols) do
		local width = widths[i].width
		local len = vim.fn.execute("echo strdisplaywidth('" .. col .. "')")
		len = tonumber(len)
		if len > width then
			col = col:sub(1, width)
		else
			for _ = 1, width - len do
				cols[i] = cols[i] .. " "
			end
		end
	end
	return cols
end

function M.render(bufnr)
	local marktodo = require("marktodo")
	local lines = {}
	local row = {}
	-- Get cols
	for _, parser in pairs(marktodo.parsers) do
		local cols = createDisplayers(parser)
		table.insert(row, cols)
	end
	-- Add header label in cols
	local cols_header = {}
	for _, v in pairs(getSortedColumns()) do
		table.insert(cols_header, v.label)
	end
	table.insert(row, 1, cols_header)
	-- Get col width
	local widths = {}
	for col_number, v in pairs(getSortedColumns()) do
		table.insert(widths, { width = getColumnWidth(row, col_number, v.max_width) })
	end
	-- Cols to line
	for i, cols in pairs(row) do
		cols = setColsWidth(cols, widths)
		local line = table.concat(cols, marktodo.ops.separator)
		table.insert(lines, line)
	end
	-- Set header line
	local len = vim.fn.execute("echo strdisplaywidth('" .. lines[1] .. "')")
	table.insert(lines, 2, "")
	for i = 1, len do
		lines[2] = lines[2] .. "-"
	end
	table.insert(lines, 1, "Filter: /" .. marktodo.ops.filter)

	vim.bo[bufnr]["modifiable"] = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
	vim.bo[bufnr]["modifiable"] = false
end

function M.open() end
return M
