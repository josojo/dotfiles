local keys = require("which-key")

local function on_attach(client, buffer)
	vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Keep the primary definition shortcut independent of which-key registration.
	vim.keymap.set("n", "<leader>ad", vim.lsp.buf.definition, {
		buffer = buffer,
		desc = "LSP: go to definition",
	})

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
			["["] = {"<cmd>lua vim.diagnostic.jump({ count = -1 })<cr>", "Previous Diagnostic" },
			["]"] = {"<cmd>lua vim.diagnostic.jump({ count = 1 })<cr>", "Next Diagnostic" },
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

	-- Configure LSP servers using vim.lsp.config (Neovim 0.11+).
	-- Rust is configured via rustaceanvim in init.lua.

	vim.lsp.config.pyright = {
		-- Automatically detect venv in common locations
		before_init = function(_, config)
			local venv_names = { ".venv", "venv", "env", "env36", ".env" }
			for _, name in ipairs(venv_names) do
				local venv_path = vim.fs.joinpath(config.root_dir or vim.fn.getcwd(), name)
				if vim.fn.isdirectory(venv_path) == 1 then
					config.settings.python.pythonPath = vim.fs.joinpath(venv_path, "bin", "python")
					break
				end
			end
		end,
		settings = {
			python = {
				analysis = {
					-- Use standard type checking (catches real errors without being noisy)
					typeCheckingMode = "standard",
					-- Don't report missing imports as errors when packages are installed in venv
					diagnosticSeverityOverrides = {
						reportMissingImports = "warning",
						reportMissingModuleSource = "none",
					},
					-- Auto-detect search paths
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
				},
			},
		},
	}

	vim.lsp.config.ruff = {
		capabilities = {
			general = {
				positionEncodings = { "utf-16" },
			},
		},
		init_options = {
			settings = {
				lineLength = 120,
			},
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
	vim.lsp.enable('pyright')
	vim.lsp.enable('ruff')
	vim.lsp.enable('gopls')
	vim.lsp.enable('solidity_ls')
	vim.lsp.enable('ts_ls')
end

return {
	setup = setup,
}
