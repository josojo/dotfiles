local set = require("utils.set")

set.vars {
	loaded_python_provider = 0,
	loaded_python3_provider = 0,
	loaded_perl_provider = 0,
	loaded_ruby_provider = 0,
	loaded_node_provider = 0,
}
set.opts {
	number = true,
	relativenumber = true,
	list = true,
	listchars = {tab = "» ", nbsp = "␣", trail = "·"},
	tabstop = 4,
	shiftwidth = 4,
}

-- Prerequisites:
-- - neovim >= 0.8
-- - rust-analyzer: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require("packer").init({
  autoremove = true,
})
require("packer").startup(function(use)

	use "dense-analysis/ale"
	use "andymass/vim-matchup"
	use {
		"folke/which-key.nvim",
		config = function ()
			require("which-key").setup()
			require("config.keys").setup()
		end,
	}
	use {
		"neovim/nvim-lspconfig",
		config = function ()
			require("config.lsp").setup()
		end,
	}
	use "Julian/lean.nvim"
	use {
		"nvim-telescope/telescope-ui-select.nvim",
		requires = "nvim-telescope/telescope.nvim",
		config = function ()
			require("telescope").load_extension("ui-select")
		end,
	}
	 use {
	 	"nvim-treesitter/nvim-treesitter",
	 	config = function ()
			require("nvim-treesitter.configs").setup {
				ensure_installed = {
					"c",
					"comment",
					"fennel",
					"javascript",
					"lua",
					"rust",
					"typescript",
				},
				highlight = {enable = true},
				matchup = {enable = true},
			}
		end,
	}

	use "tpope/vim-commentary"
  -- Packer can manage itself
  use("wbthomason/packer.nvim")
  -- Visualize lsp progress
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end
  })

  -- Autocompletion framework
  use("hrsh7th/nvim-cmp")
  use({
    -- cmp LSP completion
    "hrsh7th/cmp-nvim-lsp",
    -- cmp Snippet completion
    "hrsh7th/cmp-vsnip",
    -- cmp Path completion
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    after = { "hrsh7th/nvim-cmp" },
    requires = { "hrsh7th/nvim-cmp" },
  })
  -- See hrsh7th other plugins for more great completion sources!
  -- Snippet engine
  use('hrsh7th/vim-vsnip')
  -- Adds extra functionality over rust analyzer
  use({
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
  })

  -- use("windwp/nvim-autopairs")

  use("lewis6991/gitsigns.nvim")
  -- Optional
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")


  use("ray-x/go.nvim")
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  })

  use {
	              "nvim-telescope/telescope.nvim",
	              requires = {
	                      "kyazdani42/nvim-web-devicons",
	                      "nvim-lua/plenary.nvim",
	              },
	      }
--   use("nvim-telescope/telescope.nvim")

  -- Some color scheme other then default
  use("folke/tokyonight.nvim")
end)

-- the first run will install packer and our plugins
if packer_bootstrap then
  require("packer").sync()
  return
end

vim.g.mapleader = ","

vim.api.nvim_command('set commentstring=//%s')


-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

local function on_attach(client, buffer)
    local keymap_opts = { buffer = buffer }
    -- " Code navigation and shortcuts
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
    vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
    vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
    vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
    vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)

    -- " Show diagnostic popup on cursor hover
    local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end,
      group = diag_float_grp,
    })

    -- " Goto previous/next diagnostic warning/error
    vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
    vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
end

-- Configure LSP through rustaceanvim plugin.
-- See https://github.com/mrcjkb/rustaceanvim
vim.g.rustaceanvim = {
  tools = {
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },
  server = {
    on_attach = on_attach,
    default_settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}
-- Configure leanls via vim.lsp.config (new API)
vim.lsp.config('leanls', {
  on_attach = on_attach,
})
vim.lsp.enable('leanls')
require('lean').setup{
  mappings = true,
}
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})
require("go").setup()


-- " Setup Completion
-- " See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },

  -- Installed sources
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
  	-- { name = "tsserver" },,
    { name = "path" },
    { name = "buffer" },
  },
})

require('gitsigns').setup ({
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
    map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
    map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
    map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
    map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
    map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
    map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

    -- Text object
    map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})
-- put this to setup function and press <a-e> to use fast_wrap
-- require("nvim-autopairs").setup {
--     fast_wrap = {  
--       map = '<C-e>',
--       chars = { '{', '[', '(', '"', "'" },
--       pattern = [=[[%'%"%>%]%)%}%,]]=],
--       end_key = '$',
--       keys = 'qwertyuiopzxcvbnmasdfghjkl',
--       check_comma = true,
--       highlight = 'Search',
--       highlight_grey='Comment'
--     },
-- }
-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"

-- " Set updatetime for CursorHold
-- " 300ms of no cursor movement to trigger CursorHold
-- set updatetime=300
vim.opt.updatetime = 100

vim.opt.clipboard = 'unnamed'

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.cmd[[colorscheme tokyonight ]]

vim.cmd [[call matchadd('ColorColumn', '\%81v.')]]
