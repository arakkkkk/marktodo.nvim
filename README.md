# Marktodo
# [todotxt](https://ericasadun.com/2019/11/13/lightweight-to-do-list-formatting/) with neovim!!
You can search todo written by [todotxt](https://ericasadun.com/2019/11/13/lightweight-to-do-list-formatting/) format from alll files in your current directory.

## screenshots
![doc](doc/doc.mov)

## Instration
Using packer
```
use({
	"/arakkkkk/marktodo.nvim",
	config = function()
		require("marktodo").setup()
	end,
})
```

## Usage

### Create ToDo
```
1---- 2-- 3--------- 4--------- 5-----------------------------------------------------
- [x] (A) 2022-12-27 2022-12-26 sample todo @context +Project due:2022-12-27 tag:value
                                            6------- 7------- 8------------- 8--------
```
1. Marktodo Picker
2. Priority (Optional)
3. Completion Date (Optional)
4. Creation Date (Optional)
5. Description
6. Context Tag (Optional)
7. Project Tag (Optional)
8. Special key/value tag (Optional)

## Search todo with nvim-telescope
```
:Marktodo
```

Open files contain selected todo with <CR>.

Complete task from telescope window with <C-d>.

## Settings

```
require("marktodo").setup({
	sort = { "priority" }, -- priority, is available
	-- exclude_ops = "-g '!./**/.md'",
	only_top_level_tasks = true,
	telescope = true, -- Only true is supported now.
	telescope_width = vim.o.columns * 0.8,
	telescope_columns = {
		{ label = "priority", order = 1 },
		-- 	local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
		-- { label = "absolute_file_path", order = 2, replacer = function(todo)
		-- 	return todo.file_path:sub(#vim.fn.getcwd() + 2)
		-- end },
		{ label = "smart_file_path", order = 2, max_width = 15, replacer = function(todo)
			local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
			local disp = ""
			for m in abs_path:gmatch("([^/])[^/]+/") do
				disp = disp  .. m .. "/"
			end
			return disp .. todo.file_path:match("/([^/]+).md$")
		end },
		-- { label = "file_name", order = 2, max_width = 10, replacer = function(todo)
		-- 	return todo.file_path:match("/([^/]+).md$")
		-- end },
		-- { label = "dir_name", order = 2, max_width = 10, replacer = function(todo)
		-- 	local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
		-- 	return abs_path:match("^([^/]+)/")
		-- end },
		{ label = "description", order = 3, max_width = 30 },
		{
			label = "project_tags",
			order = 4,
			replacer = function(todo)
				-- Separate project tags by comma
				return table.concat(todo.project_tags, " ")
			end,
		},
		{ label = "context_tags", order = 5 },
		-- creation_date = { order = 3, width = 0.2 },
	},
	separator = "      ",
	marktodo_patterns = {
		completion = "- %[([x ])%]",
		priority = "%(([A-Z ]?)%)",
		completion_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
		creation_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
		-- description is follor above
	},
	desciption_patterns = {
		project_tags = "(%+%S+)",
		context_tags = "(@%S+)",
		special_keyvalue_tags = "(%S+:%S+)",
	},
})
```
### Issues
- [x] todoparser
- [x] todofinder
- [x] cmp
- [X] todoevents
- [ ] Sort by due
- [ ] Sort by created
