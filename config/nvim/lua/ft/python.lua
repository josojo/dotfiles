local set = require("utils.set")
local keys = require("which-key")

-- Pyright + ruff handle all linting/formatting via vim.lsp; ALE is disabled
-- globally for Python in init.lua via g:ale_linters.

keys.register({
	p = {
		name = "python",
		i = {"<cmd>!python3 -m venv env36 source env36/bin/activate", "Check Workspace"},
		F = {"<cmd>!python3 -m black .<cr>", "Format Workspace"},
		r = {"<cmd>!python3 -m src.main<cr>", "Run"},
		t = {"<cmd>!python3 -m test<cr>", "Test"},
	}
}, {
	prefix = "<leader>",
})

set.opts {
	expandtab = true,
}

