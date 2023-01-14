local marktodo = require("marktodo")
local M = {}

function M.count_date(line)
	local t = os.date("*t")
	local y = string.gsub(line, "^(%d%d%d%d)-%d%d-%d%d$", "%1")
	local m = string.gsub(line, "^%d%d%d%d/(%d%d)-%d%d$", "%1")
	local d = string.gsub(line, "^%d%d%d%d-%d%d-(%d%d)$", "%1")
	local due_time = os.time({ year = y, month = m, day = d, hour = 0, min = 0, sec = 0 })
	local due_days = due_time / (60 * 60 * 24)
	local now_time = os.time() - t.hour * 3600 - t.min * 60 - t.sec
	local now_days = now_time / (60 * 60 * 24)
	return due_days - now_days
end

function M.sort(parsers)
	local function swhich(or_head_parser, compare_parser, target)
		if type(or_head_parser[target]) ~= "string" then
			return false
		end
		if or_head_parser[target]:match("^%s*$") then
			return false
		end
		if target == "priority" then
			return compare_parser[target]:match("^%s*$") or or_head_parser[target] < compare_parser[target]
		elseif target == "completion" then
			return or_head_parser[target] == "-"
		elseif target == "completion_date" or target == "creation_date" then
			return compare_parser[target]:match("^%s*$") or M.count_date(or_head_parser[target]) < M.count_date(compare_parser[target])
		elseif target == "file_name" then
			return compare_parser[target]:match("^%s*$") or or_head_parser[target]:sub(1, 1) < compare_parser[target](1, 1)
		elseif target == "project_tags" then
			return compare_parser[target]:match("^%s*$") or or_head_parser[target][1]:sub(1, 1) < compare_parser[target][1](1, 1)
		end
		return false
	end

	for _, sort_target in pairs(marktodo.ops.sort) do
		for i = #parsers, 1, -1 do
			for j = 1, i - 1 do
				if swhich(parsers[j + 1], parsers[j], sort_target) then
					local tail = parsers[j]
					parsers[j] = parsers[j + 1]
					parsers[j + 1] = tail
				end
			end
		end
	end

	return parsers
end

return M
