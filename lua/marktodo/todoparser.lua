local marktodo = require("marktodo")
local mp = marktodo.ops.marktodo_patterns
local mdp = marktodo.ops.description_patterns
local mdd = marktodo.ops.description_display
local utils = require("marktodo.utils")
TodoParser = {}

TodoParser.new = function(todo_line, file_path, line_number)
	local obj = {}
	obj.todo_line = todo_line
	obj.file_path = file_path
	obj.line_number = line_number

	---------------
	-- Status
	---------------
	obj.isComplete = function(self)
		local _, _, chapture = obj.todo_line:find(mp.completion)
		return chapture == "x" or chapture == "X"
	end

	obj.parse = function(self)
		local residue = self.todo_line
		local chapture
		-- Completion
		_, _, chapture = residue:find(mp.completion)
		residue = residue:gsub("^%s*" .. mp.completion, "")
		residue = residue:gsub("^% +", "")
		self.completion = chapture or ""
		-- Priotiry
		_, _, chapture = residue:find(mp.priority)
		residue = residue:gsub("^" .. mp.priority, "")
		residue = residue:gsub("^% +", "")
		self.priority = chapture or ""
		-- CompletionDate
		_, _, chapture = residue:find(mp.completion_date)
		residue = residue:gsub("^" .. mp.completion_date, "")
		residue = residue:gsub("^% +", "")
		self.completion_date = chapture or ""
		-- CreationDate
		_, _, chapture = residue:find(mp.creation_date)
		residue = residue:gsub("^" .. mp.creation_date, "")
		residue = residue:gsub("^% +", "")
		self.creation_date = chapture or ""

		-- Description
		self.description = residue or ""
		self.project_tags = self:getProjectTags() or ""
		self.context_tags = self:getContextTags() or ""
		self.special_keyvalue_tags = self:getSpecialKeyvalueTags() or ""
	end

	-- For filter
	obj.show = function(self)
		local filter_param = marktodo.ops.filter
		-- Perse filter text
		for filter_kv in filter_param:gmatch("%S+:%S+") do
			local _, _, key, pat = filter_kv:find("^(%S+):(%S+)")
			assert(self[key], key .. " is not defined!")
			if type(self[key]) == "string" then
				if self[key]:match(pat) then
				else
					return false
				end
			elseif type(self[key]) == "table" then
				local show = false
			end
		end
		return true
	end

	---------------
	-- Desciption
	---------------
	obj.getProjectTags = function(self)
		local res_table = {}
		for match in self.description:gmatch(mdp.project_tags) do
			table.insert(res_table, match)
		end
		if not mdd.project_tags then
			self.description = self.description:gsub(mdp.project_tags, "")
		end
		return res_table
	end

	obj.getContextTags = function(self)
		local res_table = {}
		for match in self.description:gmatch(mdp.context_tags) do
			table.insert(res_table, match)
		end
		if not mdd.context_tags then
			self.description = self.description:gsub(mdp.context_tags, "")
		end
		return res_table
	end

	obj.getSpecialKeyvalueTags = function(self)
		local keyvalue = {}
		for match in self.description:gmatch(mdp.special_keyvalue_tags) do
			local _, _, _, key, value = match:find(mdp.special_keyvalue_tags)
			keyvalue[key] = value
		end
		if not mdd.special_keyvalue_tags then
			self.description = self.description:gsub(mdp.special_keyvalue_tags, "")
		end
		return keyvalue
	end

	return obj
end

return TodoParser
