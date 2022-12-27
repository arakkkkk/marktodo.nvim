local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

return function(selections, opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Marktodo",
			finder = finders.new_table({
				results = selections,
				entry_maker = function(selection)
					return {
						value = selection,
						display = selection["title"],
						ordinal = selection["title"],
						id = selection["id"],
						title = selection["title"],
						callback = selection["callback"]
					}
				end,
			}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					selection["callback"]()
				end)
				return true
			end,
			sorter = conf.generic_sorter(opts),
		})
		:find()
end


