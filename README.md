# My Dotfiles

## Requirements

### Install Stow

```sh
brew install stow
```

### Install nvim

```sh
brew install neovim
```

### Install tmux

```sh
brew install tmux
```

### Install TPM and source the config

```sh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

### Install Wezterm

```sh
brew install --cask wezterm
```

### Install starship

```sh
brew install starship
```

### Install aerospace

```sh
brew install --cask nikitabobko/tap/aerospace
```

### Install nvm for node

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```

### (Optional) Install go

Go to [go.dev] and grab the latest release.

### Install rust toolchain

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup toolchain install nightly # You might want stable channel instead
```

### Other useful tools

```sh
brew install fzf fzf-tmux ripgrep zoxide bat git-delta
```


## Installing the dotfiles

Run

```sh
git clone git@github.com/gamebox/dotfiles ~/dotfiles
cd ~/dotfiles
stow .
tmux source ~/.config/tmux/tmux.conf
```

And then open Alacritty with Cmd+Space.  Everything should just work, especially after you open Neovim the first time.
