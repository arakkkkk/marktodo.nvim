local function split(str, seq, max_count)
	local count = 0
	local tab = {}
	while str ~= "" do
		count = count + 1
		local fc = string.find(str, seq)
		if fc == nil or count >= max_count then
			table.insert(tab, str)
			break
		end
		table.insert(tab, str.sub(str, 1, fc - 1))
		str = string.sub(str, fc + #seq)
	end
	return tab
end

return function(path, pattern, ops)
	local res_table = {}
	pattern = pattern:gsub("%%", "\\")
	pattern = pattern:gsub("^-", "\\-")
	pattern = pattern:gsub(" ", "\\s")
	local handle = io.popen("rg " .. ops .. " '" .. pattern .. "' --no-heading -H --vimgrep " .. "'" .. path .. "'")
	assert(handle)
	local io_output = handle:read("*a")
	for line in io_output:gmatch("([^\n]*)\n?") do
		if line ~= "" then
			-- Response line patterns
			-- <file_path>:<line_number>:<col_number>:<matched>
			local cols = split(line, ":", 4)
			table.insert(res_table, {
				file_path = cols[1],
				line_number = tonumber(cols[2]),
				col_number = tonumber(cols[3]),
				matched = cols[4],
			})
		end
	end
	handle:close()

	return res_table
end

--[[

local todo_lies = grep(vim.fn.getcwd(), "- %[[]%] .+", "-tmd")

--]]
