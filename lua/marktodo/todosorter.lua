local marktodo = require("marktodo")
local M = {}

function M.sort(parsers)
	local function swhich(or_head_parser, compare_parser, target)
		if type(or_head_parser[target]) ~= "string" then
			return false
		end
		if or_head_parser[target]:match("^%s*$") then
			return false
		end
		if compare_parser[target]:match("^%s*$") then
			return true
		end
		if target == "priority" then
			return or_head_parser[target] < compare_parser[target]
		end
		assert(target)
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
