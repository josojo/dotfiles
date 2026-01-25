local keys = require("which-key")

local function on_attach(client, buffer)
	vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

	keys.register({
		a = {
			name = "lsp",
			a = {"<cmd>lua vim.lsp.buf.code_action()<cr>", "Actions"},
			d = {"<cmd>lua vim.lsp.buf.definition()<cr>", "Declaration"},
			D = {"<cmd>Telescope lsp_definitions<cr>", "Definition"},
			e = {"<cmd>lua vim.diagnostic.open_float()<cr>", "Show Diagnostic"},
			f = {"<cmd>lua vim.lsp.buf.format()<cr>", "Format"},
			i = {"<cmd>Telescope lsp_implementations<cr>", "Implementation"},
			k = {"<cmd>lua vim.lsp.buf.hover()<cr>", "Hover"},
			K = {"<cmd>lua vim.lsp.buf.signature_help()<cr>", "Help"},
			l = {"<cmd>Telescope diagnostics bufnr="..buffer.."<cr>", "Document Diagnostics"},
			L = {"<cmd>Telescope diagnostics<cr>", "Diagnostics"},
			n = {"<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"},
			r = {"<cmd>Telescope lsp_references<cr>", "References"},
			s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
			S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"},
			["["] = {"<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
			["]"] = {"<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
		}
	}, {
		prefix = "<leader>",
		buffer = buffer,
	})
end

local function setup()
	-- Set up LspAttach autocommand for keybindings
	vim.api.nvim_create_autocmd('LspAttach', {
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, args.buf)
		end,
	})

	-- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
	vim.lsp.config.rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	}

	vim.lsp.config.pyright = {
		settings = {
			python = {},
		},
	}

	vim.lsp.config.gopls = {}

	vim.lsp.config.solidity_ls = {
		cmd = { "npx", "@nomicfoundation/solidity-language-server", "--stdio" },
		filetypes = { "solidity" },
	}

	vim.lsp.config.ts_ls = {
		init_options = {
			lint = false,
		},
	}

	-- Enable all configured servers
	vim.lsp.enable('rust_analyzer')
	vim.lsp.enable('pyright')
	vim.lsp.enable('gopls')
	vim.lsp.enable('solidity_ls')
	vim.lsp.enable('ts_ls')
end

return {
	setup = setup,
}
