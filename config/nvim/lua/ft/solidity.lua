local set = require("utils.set")
local keys = require("which-key")

keys.register({
	s = {
		name = "solidity",
		f = {"<cmd>!forge fmt<cr>", "format with foundry"},
		t = {"<cmd>!forge test -vvv<cr>", "Test"},
	}
}, {
	prefix = "<leader>",
})

set.opts {
	expandtab = false,
}

