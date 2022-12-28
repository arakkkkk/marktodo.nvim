local marktodo = require("marktodo")
local M = {}

function M.sort(parsers)
	local function isHead(or_head_parser, compare_parser, target)
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
			print(
				or_head_parser[target] < compare_parser[target],
				":",
				compare_parser[target] .. ", " .. or_head_parser[target]
			)
			return or_head_parser[target] < compare_parser[target]
		end
		assert(target)
	end

	for _, sort_target in pairs(marktodo.ops.sort) do
		for i = 1, #parsers do
			for j = i, #parsers - 1 do
				if isHead(parsers[j + 1], parsers[j], sort_target) then
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
