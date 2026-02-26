local set = require("utils.set")
local keys = require("which-key")

-- rustaceanvim already manages rust-analyzer; disable ALE's LSP linters here
-- to avoid duplicate rust-analyzer clients and duplicate inlay hints.
vim.b.ale_disable_lsp = 1

keys.register({
	c = {
		name = "cargo",
		b = {"<cmd>!cargo build<cr>", "Build"},
		c = {"<cmd>!cargo clippy<cr>", "Check"},
		C = {"<cmd>!cargo clippy --workspace --all-features --all-targets<cr>", "Check Workspace"},
		F = {"<cmd>!cargo +nightly fmt --version >/dev/null && cargo +nightly fmt --all || cargo fmt --all<cr>", "Format Workspace"},
		r = {"<cmd>!cargo run<cr>", "Run"},
		t = {"<cmd>!cargo test<cr>", "Test"},
		T = {"<cmd>!cargo test --workspace --all-features<cr>", "Test Workspace"},
	}
}, {
	prefix = "<leader>",
})

set.opts {
	expandtab = true,
}
