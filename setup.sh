#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1" dst="$2"
    if [ -L "$dst" ]; then
        echo "skip  $dst (already a symlink)"
    elif [ -e "$dst" ]; then
        echo "back  $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
        ln -s "$src" "$dst"
        echo "link  $dst -> $src"
    else
        ln -s "$src" "$dst"
        echo "link  $dst -> $src"
    fi
}

link "$DOTFILES/zsh/.zshrc"       "$HOME/.zshrc"
link "$DOTFILES/tmux/tmux.conf"   "$HOME/.tmux.conf"
link "$DOTFILES/vim/vimrc"        "$HOME/.vimrc"

echo "done"
