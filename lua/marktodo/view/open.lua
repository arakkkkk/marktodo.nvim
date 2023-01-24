local M = {}

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "marktodo://*",
	callback = function()
		-- initial set
		vim.cmd("set filetype=marktodo_list")
		-- create buf
		local bufnr = 0
		vim.fn.setbufvar(bufnr, "scratch", "nomodified")
		vim.bo[bufnr]["buftype"] = "nofile"
		vim.bo[bufnr]["modifiable"] = false
	end,
})

function M.open()
	vim.cmd("e marktodo://./")
	require("marktodo.view.render").render(0)
end

return M
