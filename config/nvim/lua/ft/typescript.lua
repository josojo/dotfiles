local set = require("utils.set")
local keys = require("which-key")

keys.register({
	y = {
		name = "yarn",
		l = {"<cmd>!yarn lint:fix<cr>", "Lint and Prettier"},
		t = {"<cmd>!yarn test<cr>", "Test"},
	}
}, {
	prefix = "<leader>",
})

set.opts {
	expandtab = true,
	shiftwidth = 2,
}
