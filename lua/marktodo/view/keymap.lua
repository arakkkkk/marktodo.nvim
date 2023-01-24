local M = {}

function M.create()
	local ops = { silent = true, buffer = vim.api.nvim_win_get_buf(0) }

	vim.keymap.set("n", "f", "<cmd>TodoFilter<cr>", ops)
	vim.keymap.set("n", "<cr>", "<cmd>TodoOpen<cr>", ops)
	vim.keymap.set("n", "d", "<cmd>TodoComplete<cr>", ops)
	vim.keymap.set("n", "-", "<cmd>TodoProgress<cr>", ops)
	vim.keymap.set("n", "p", "<cmd>TodoSetPriority<cr>", ops)
	vim.keymap.set("n", "+", "<cmd>TodoSetProject<cr>", ops)
	vim.keymap.set("n", "d", "<cmd>TodoSetDue<cr>", ops)
	vim.keymap.set("n", "m", "<cmd>TodoModify<cr>", ops)
end

return M
