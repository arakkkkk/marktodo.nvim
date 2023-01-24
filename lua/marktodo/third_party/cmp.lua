local source = {}
local function get_cmp_projects()
	local handle = io.popen("rg -o -tmd '\\- \\[.\\] .+ \\+\\S+\\b' -IN --trim " .. "'" .. vim.fn.getcwd() .. "'")
	local table = {}
	if handle ~= nil then
		local io_output = handle:read("*a")
		for line in io_output:gmatch("([^\n]*)\n?") do
			if line ~= "" then
				line = string.match(line, "+%S+")
				table[line] = 1
			end
		end
		handle:close()
	end
	return table
end
local function get_cmp_contexts()
	local handle = io.popen("rg -o -tmd '\\- \\[.\\] .+ @\\S+\\b' -IN --trim " .. "'" .. vim.fn.getcwd() .. "'")
	local table = {}
	if handle ~= nil then
		local io_output = handle:read("*a")
		for line in io_output:gmatch("([^\n]*)\n?") do
			if line ~= "" then
				line = string.match(line, "@%S+")
				table[line] = 1
			end
		end
		handle:close()
	end
	return table
end
local function get_cmp_tags()
	local handle = io.popen("rg -o -tmd '\\- \\[.\\] .+ tag:\\S+\\b' -IN --trim " .. "'" .. vim.fn.getcwd() .. "'")
	local table = {}
	if handle ~= nil then
		local io_output = handle:read("*a")
		for line in io_output:gmatch("([^\n]*)\n?") do
			if line ~= "" then
				line = string.match(line, "tag:%S+")
				table[line] = 1
			end
		end
		handle:close()
	end
	return table
end
local function get_cmp_date(trigger)
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
	return table_cmp
end

---Return whether this source is available in the current context or not (optional).
---@return boolean
function source:is_available()
	return true
end
---Return the debug name of this source (optional).
---@return string
function source:get_debug_name()
	return "marktodo"
end
---Return trigger characters for triggering completion (optional).
function source:get_trigger_characters()
	return { ".", "+", "@", "[", " ", ":" }
end
---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
	local line = vim.fn.getline(".")
	local col = vim.fn.charcol(".")
	local trig = string.sub(line, 1, col)
	local cb = {}
	-- Ceckbox
	if trig:match("- $") then
		table.insert(cb, { label = "[ ]" })
	-- Priority
	elseif trig:match("- %[.%] $") then
		table.insert(cb, { label = "(A)" })
		table.insert(cb, { label = "(B)" })
		table.insert(cb, { label = "(C)" })
		table.insert(cb, { label = "(D)" })
		table.insert(cb, { label = "(E)" })
	-- Date first (Creation date if task is not complete or Completion date)
	elseif trig:match("- %[.%] %(.%) $") then
		table.insert(cb, { label = os.date("%Y-%m-%d") })
	-- Date second (Completion date)
	elseif trig:match("- %[.%] %(.%) [%d-]+ $") then
		table.insert(cb, { label = os.date("%Y-%m-%m") })
	-- project
	elseif trig:match("- %[.%] %(.%) .+ %+$") then
		for t, _ in pairs(get_cmp_projects()) do
			table.insert(cb, { label = t })
		end
	-- context
	elseif trig:match("- %[.%] %(.%) .+ @$") then
		for t, _ in pairs(get_cmp_contexts()) do
			table.insert(cb, { label = t })
		end
	-- tag
	elseif trig:match("- %[.%] %(.%) .+ tag:$") then
		for t, _ in pairs(get_cmp_tags()) do
			table.insert(cb, { label = t })
		end
	-- due
	-- elseif trig:match("- %[.%] %(.%) .+ due:%S+$") then
	-- 	local trig_date = trig:match(":%S+$")
	-- 	if trig_date:match("%d+d") then
	-- 		table.insert(cb, { label = trig_date })
	-- 	elseif trig_date:match("^%d%d-%d%d$") then
	-- 		table.insert(cb, { label = trig_date })
	-- 	elseif trig_date:match("^%d%d$") then
	-- 		table.insert(cb, { label = trig_date })
	-- 	elseif
	-- 		trig_date:match("n*su")
	-- 		or trig_date:match("n*mo")
	-- 		or trig_date:match("n*tu")
	-- 		or trig_date:match("n*we")
	-- 		or trig_date:match("n*th")
	-- 		or trig_date:match("n*fr")
	-- 		or trig_date:match("n*sa")
	-- 	then
	-- 		table.insert(cb, { label = trig_date })
	-- 	end
	-- end
	callback(cb)
end
---Resolve completion item (optional). This is called right before the completion is about to be displayed.
---Useful for setting the text shown in the documentation window (`completion_item.documentation`).
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:resolve(completion_item, callback)
	callback(completion_item)
end
---Executed after the item was selected.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
	callback(completion_item)
end
---Register your source to nvim-cmp.
require("cmp").register_source("marktodo", source)

