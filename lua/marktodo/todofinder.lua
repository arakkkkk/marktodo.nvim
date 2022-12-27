local M = {}

-- TODO: finder
function M.find(filter)
	filter.priotiry = filter.priotiry or "A-Z"
	filter.due = filter.due or "A-Z"
	return {
		{ title = "", priotiry = "", due = "", file_path = "", line_number = "" },
	}
end

return M
