local cmp = require("cmp")
local keys = require("which-key")

local function on_attach(client, buffer)
	vim.bo[buffer].omnifunc = "v:lua.vim.cmp.omnifunc"

	keys.register({
		d = {
			name = "cmp",
			d = {"<cmd>cmp vim.cmp.complete()<cr>", "Declaration"},
		}
	}, {
		prefix = "<leader>",
		buffer = buffer,
	})
end

local function setup()
	cmp.rust_analyzer.setup{
		on_attach = on_attach,
	}

	cmp.denols.setup {
		on_attach = on_attach,
		init_options = {
			lint = true,
		},
	}
end

return {
	setup = setup,
}
