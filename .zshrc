export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$PATH:/Users/anthonybullard/Development/flutter/bin"

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH
export PATH=$GEM_HOME/ruby/2.6.0/bin:$PATH

# pnpm
export PNPM_HOME="/Users/anthonybullard/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
#
export GO_HOME="/Users/anthonybullard/sdk/go1.22.0/bin"
export GO_BIN="/Users/anthonybullard/go/bin"
export PATH="$GO_BIN:$GO_HOME:$PATH"

export PATH="/Users/anthonybullard/.local/bin/roc:$PATH"

eval "$(starship init zsh)"
eval "$(opam env)"

# Have rustup version trump homebrew version
RUSTUP_CARGO="$(rustup which cargo --toolchain stable)"
RUSTUP_TOOLCHAIN_DIR="$(dirname $RUSTUP_CARGO)"
export PATH="$RUSTUP_TOOLCHAIN_DIR:$PATH"

# Set default CC to Clang
export CC="clang"

function sessionize() {
    if [[ $# -eq 1 ]]; then
        selected="$1"
    else
        selected="$(find ~/Development ~/.config -type d -mindepth 1 -maxdepth 1 | fzf)"
    fi

    if [[ -z $selected ]]; then
        exit 0
    fi

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s $selected_name -c $selected
        exit 0
    fi

    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        tmux new-session -ds $selected_name -c $selected
    fi

    tmux switch-client -t $selected_name
}

[ -f "/Users/anthonybullard/.ghcup/env" ] && source "/Users/anthonybullard/.ghcup/env" # ghcup-env
