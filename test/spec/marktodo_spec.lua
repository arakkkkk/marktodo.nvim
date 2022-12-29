local marktodo = require("marktodo")
-- print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

describe("marktodo", function()
	it("works!", function()
		vim.cmd("Marktodo root_path=~/MyDrive/Applycations/Note/ a={'ag':'val'}")
	end)
end)
