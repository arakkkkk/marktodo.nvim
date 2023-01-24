local M = {}

function M.to_regexp(regrep)
	regrep = string.gsub(regrep, "%[", "%%[")
	regrep = string.gsub(regrep, "%]", "%%]")
	regrep = string.gsub(regrep, "<.*>", "(.*)")
	return regrep
end

function M.deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		-- tableなら再帰でコピー
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
		end
		setmetatable(copy, M.deepcopy(getmetatable(orig)))
	else
		-- number, string, booleanなどはそのままコピー
		copy = orig
	end
	return copy
end

function M.tableMerge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				M.tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

function M.TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

function M.split(str, seq, max_count)
	max_count = max_count or 99999999999999
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

function M.includes(tab, str)
	for i in pairs(tab) do
		if tab[i] == str then
			return true
		end
	end
	return false
end

function M.input(input_text, default)
	input_text = input_text or ""
	default = default or ""
	local ok, input = pcall(vim.fn.inputdialog, input_text, default)
	if ok == nil then
		return false
	end
	if input == "Keyboard interrupt" then
		return false
	end
	return input
end

return M
