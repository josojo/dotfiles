#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"

dotlink() {
	local src="$ROOT/$1"
	if [ -z "$2" ]; then
		local dst="$HOME/.$1"
	else
		local dst="$HOME/$2"
	fi

	if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
		echo "already linked '$dst'"
	elif [ ! -e "$dst" ] && [ ! -L "$dst" ]; then
		ln -s "$src" "$dst"
		echo "linked '$src' to '$dst'"
	else
		echo "cannot link '$src': '$dst' already exists and points elsewhere" >&2
		return 1
	fi
}

gitinst() {
	if [[ -d "$2/.git" ]]; then
		echo "already installed '$1'"
	elif [[ ! -e "$2" ]]; then
		local remote="https://github.com/$1"
		git clone "$remote" "$2"
	else
		echo "cannot install '$1': '$2' exists but is not a git checkout" >&2
		return 1
	fi
}

mkdir -p "$HOME/.config"

dotlink "config/emacs"
dotlink "config/nvim"
gitinst \
	"wbthomason/packer.nvim" \
	"$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

if which nvim &>/dev/null; then
    nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync"
fi
