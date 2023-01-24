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

function M.char2date(trigger)
	trigger = trigger == "today" and "0d" or trigger
	trigger = trigger == "tommorow" and "1d" or trigger
	local table_cmp = {}
	if not trigger then
		return table_cmp
	end

	-- from day: 1d
	if trigger:match("%d+d") then
		local t = os.time()
		local d = trigger:match("%d+")
		t = t + d * 24 * 60 * 60
		return os.date("%Y-%m-%d", t)
	end

	-- from month: 01-01
	if trigger:match("%d%d%-%d%d$") then
		local t = os.date("*t")
		local _, _, m, d = trigger:find("(%d%d)%-(%d%d)")
		return t.year .. "-" .. m .. "-" .. d
	-- from day: 01
	elseif trigger:match("%d%d$") then
		local t = os.date("*t")
		local d = trigger:match("%d%d")
		return t.year .. "-" .. t.month .. "-" .. d
	-- by week
	elseif string.match(trigger, "n*[a-z][a-z]$") then
		local week_name = string.gsub(trigger, "^n*([a-z][a-z])$", "%1")
		local step_week_num = #string.gsub(trigger, "^(n*)[a-z][a-z]$", "%1")
		local t = os.time()
		t = t - ((os.date("*t").wday - 1) * 24 * 60 * 60) -- return to day of this sunday
		t = t + ((step_week_num * 7) * 24 * 60 * 60) -- step week by count of "n"
		if week_name == "su" then
			t = t
		elseif week_name == "mo" then
			t = t + (1 * 24 * 60 * 60)
		elseif week_name == "tu" then
			t = t + (2 * 24 * 60 * 60)
		elseif week_name == "we" then
			t = t + (3 * 24 * 60 * 60)
		elseif week_name == "th" then
			t = t + (4 * 24 * 60 * 60)
		elseif week_name == "fr" then
			t = t + (5 * 24 * 60 * 60)
		elseif week_name == "sa" then
			t = t + (6 * 24 * 60 * 60)
		else
		end
		return os.date("%Y-%m-%d", t)
	end
	return nil
end

return M
