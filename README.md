# `.dotfiles`

A repository for keeping my dotfiles for personal configurations across
machines.

## Installation

Neovim's Diffview plugin (`<leader>do`) requires Git 2.31 or newer on `PATH`.
Check the version with `git --version`; older versions can produce a misleading
"Not a repo ... or no supported VCS adapter" error inside valid repositories.

Clone the repository and run the installation script:

```sh
./install.sh
```

Existing configurations are moved to a timestamped `.backup.*` path next to
the original before linking. The installer stops if any setup step fails.

## Python navigation

Install the configured Python language servers (requires Node/npm and uv):

```sh
npm install --global pyright
uv tool install ruff
```

Ensure npm's global bin directory and `~/.local/bin` are on `PATH`, then restart
Neovim. In Python files, `,gd` (or `gd`) jumps to a definition, `,gr` lists
references, `K` shows documentation, and Ctrl-O returns to the previous location.
Pyright provides navigation; Ruff provides linting and formatting.

Install each project's dependencies in its virtual environment for navigation
into third-party packages. The configuration detects `.venv`, `venv`, `env`,
`env36`, or `.env` at the project root; you can also activate an environment
before starting Neovim.
