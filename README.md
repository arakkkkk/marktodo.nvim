# Marktodo
> [todotxt](https://ericasadun.com/2019/11/13/lightweight-to-do-list-formatting/) with neovim!!

You can search todo written by [todotxt](https://ericasadun.com/2019/11/13/lightweight-to-do-list-formatting/) format from alll files in your current directory.

You can search and list tasks created in multiple files with markdown files using Telescope.

The listed tasks are displayed with information such as title, file name, and PRIORITY information.

A sorting function is also implemented.

You can complete the selected task with <C-d> and replace with [X].

## screenshots
![doc](doc/doc.gif)

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
or
```
:Marktodo root_path=~/path/to/find
```
or
```
require("marktodo").marktodo("~/path/to/find")
```

If find path is nil or not set, default_root_path in setup options is used.

Open files contain selected todo with <CR>.

Complete task from telescope window with <C-d>.

## Settings
### Set up opsions
```
require("marktodo").setup({
	sort = { "priority", "project_tags", "completion" }, -- last is precedence
	filter = { completion = "[ -]", priority = "[A-Z]" },
	-- exclude_ops = "-g '!./**/.md'",
	-- default_root_path = "path/to/default/root",
	only_top_level_tasks = true,
	telescope = true, -- Only true is supported now.
	telescope_width = vim.o.columns * 0.8,
	description_display = {
		context_tags = true,
		project_tags = false,
		special_keyvalue_tags = false,
	},
	columns = {
		{
			label = "status",
			order = 1,
			replacer = function(todo)
				return todo.priority .. " " .. todo.completion
			end,
		},
		{
			label = "smart_file_path",
			order = 2,
			max_width = 15,
			replacer = function(todo)
				local abs_path = todo.file_path:sub(#vim.fn.getcwd() + 2)
				local disp = ""
				for m in abs_path:gmatch("([^/])[^/]+/") do
					disp = disp .. m .. "/"
				end
				local file_name = abs_path:match("^([^/]+)/") or abs_path
				return disp .. file_name
			end,
		},
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
		completion = "- %[([xX -])%]",
		priority = "%(([A-Z ]?)%)",
		completion_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
		creation_date = "([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])",
		-- description is follor above
	},
	description_patterns = {
		project_tags = "(%+%S+)",
		context_tags = "(@%S+)",
		special_keyvalue_tags = "(%S+:%S+)",
	},
}
```
### Set telescope columns
### Completion with nvim-cmp
```lua
use({"hrsh7th/nvim-cmp"})

require('cmp').setup({
  sources = {
    { name = 'marktodo' },
  },
})
```
- [x] check box
- [x] priority
- [x] project
- [x] tag
- [ ] due date

### Issues
- [x] todoparser
- [x] todofinder
- [ ] cmp for due
- [X] todoevents
- [ ] Sort by due
- [X] Sort by created
- [-] (A) urgency
- [-] (A) task window
	- [x] ops setup
	- [ ] color highlisht
	- [ ] add documents
	- [ ] split window
	- [ ] preview
