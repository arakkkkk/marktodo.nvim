local M = {}

function M.complete(file_name, line_numner)
  line_numner = file_name or current_line_number
  file_name = file_name or current_file
end

return M
