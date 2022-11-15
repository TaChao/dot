# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $HOME/.antigen/antigen.zsh

setopt no_nomatch

#Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle docker 
antigen bundle z
antigen bundle kubectl
antigen bundle tmux
antigen bundle colored-man-pages
antigen bundle sudo
antigen bundle web-search
antigen bundle wd
antigen bundle fzf
antigen bundle bazel
antigen bundle brew
antigen bundle cargo
antigen bundle copybuffer
antigen bundle cp
antigen bundle dash
antigen bundle fd
antigen bundle nmap
antigen bundle rsync
antigen bundle golang
antigen bundle macos
# Other tools
antigen bundle history-substring-search
antigen bundle soimort/translate-shell@develop

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

# Syntax highlighting bundle.
#antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zdharma-continuum/fast-syntax-highlighting
antigen bundle gretzky/auto-color-ls
antigen bundle Kallahan23/zsh-colorls
#antigen bundle zpm-zsh/colorize
antigen bundle Aloxaf/fzf-tab
#antigen bundle zpm-zsh/material-colors


# Load the theme.
# antigen theme robbyrussell
#antigen theme joshjon/bliss-zsh
#antigen theme TaChao/headline
#antigen theme moarram/headline@main
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

#Env
export TERM=xterm-256color
#functions

function mdcli {
    pandoc "$1" -f markdown -t html | lynx -stdin
}

function weather {
    location=${1:-Beijing}
    curl https://wttr.in/${location}
}

function stmux {
	if [ -z "$TMUX" ]; then
	    base_session=${1-"eden"}
	    # Create a new session if it doesn't exist
	    tmux has-session -t $base_session || tmux new-session -s $base_session
	    # Are there any clients connected already?
	    client_cnt=$(tmux list-clients -t $base_session | wc -l)
	    if [ $client_cnt -ge 1 ]; then
	        session_name=$base_session"-"$client_cnt
	        tmux new-session -d -t $base_session -s $session_name
	        tmux -2 attach-session -t $session_name \; set-option destroy-unattached
	    else
	        tmux -2 attach-session -t $base_session
	    fi
	fi
}

function spyenv {
   export PATH="$HOME/.pyenv/bin:$PATH"
   eval "$(pyenv init -)"
   eval "$(pyenv virtualenv-init -)"
}

function cmd_proxy {
   export HTTP_PROXY=$1
   export HTTPS_PROXY=$1
   export http_proxy=$1
   export https_proxy=$1
}

function Gogh {
    bash -c "$(wget -qO- https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh)"
}

function Gogh_osx {
    bash -c "$(curl -sLo- https://raw.githubusercontent.com/Mayccoll/Gogh/master/gogh.sh)"
}

function sconda {
   # >>> conda initialize >>>
   # !! Contents within this block are managed by 'conda init' !!
   __conda_setup="$($HOME/miniconda3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
   if [ $? -eq 0 ]; then
       eval "$__conda_setup"
   else
       if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
# . "$HOME/miniconda3/etc/profile.d/conda.sh"  # commented out by conda initialize
       else
# export PATH="$HOME/miniconda3/bin:$PATH"  # commented out by conda initialize
       fi
   fi
   unset __conda_setup
   # <<< conda initialize <<<
}

function snvm {
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

function srust {
    source $HOME/.cargo/env
}

function srbenv {
    eval "$(rbenv init - zsh)"
}

function ssh {
  if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm= | cut -d : -f1)" = "tmux" ]; then
    tmux rename-window "$(echo -- $* | awk '{print $NF}')"
    command ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@"
    tmux set-window-option automatic-rename "on" 1>/dev/null
  else
    command ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$@"
  fi
}

function monokai_pro {
    echo -n fd330f6f-3f41-421d-9fe5-de742d0c54c0$1 | md5 | cut -c1-25 | sed 's/.\{5\}/&-/g;s/-$//g'
}
alias mac_chrome_with_proxy="open -a /Applications/Google\ Chrome.app/ --args --proxy-server="
alias mac_chrome_with_proxy="open -a /Applications/Google\ Chrome.app/ --args --ignore-certificate-errors & /dev/null &"

function MACBREW_INSTALL_PACKAGE {
  if read -q "choice?Press Y/y to continue with 'Init Brew Environment': "; then
    brew install fzf tmux wget ctags neovim go python bpytop rustup axel p7zip aria2 lynx pandoc
    brew install fish xxh kubectl lolcat cowsay mc youtube-dl rbenv iproute2mac weechat subversion
    brew install global multitail lnav grc exa fd neofetch bazel stormssh bat glow
    brew install --cask oracle-jdk
    brew tap d12frosted/emacs-plus
    brew install emacs-plus@28 --with-spacemacs-icon
  else
    echo
    echo "exit"
  fi

}

function gh_latest_version {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

function gh_latest_version_binaries () {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | grep browser_download_url | cut -d '"' -f 4
}

function install_spacevim {
    curl -sLf https://spacevim.org/install.sh | bash
}

function install_emacspace {
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
}

function install_tmux {
    cd
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
}

function FEDORA_INSTALL_BASE {
    sudo dnf groupinstall -y "Development Tools" "Development Libraries"
    sudo dnf install -y neovim tmux zsh fzf bat emacs ruby ruby-devel pigz p7zip axel aria2 fd-find
    sudo dnf install -y g++ llvm
    sudo dnf module install -y nodejs:16/default
    sudo dnf install -y papirus-icon-theme gnome-tweak-tool xl2tpd NetworkManager-l2tp NetworkManager-l2tp-gnome
}

function UBUNTU_INSTALL_BASE {
    sudo apt install -y neovim tmux zsh fzf bat emacs ruby ruby-dev pigz p7zip axel aria2 fd-find build-essential vim-nox python3-pip
}

function INSTALL_GH_DOWNLOADER {
    sudo rm /usr/bin/ghrd
    sudo rm /usr/local/bin/ghrd
    GHRDVER=$(gh_latest_version zero88/gh-release-downloader)
    sudo curl -L https://github.com/zero88/gh-release-downloader/releases/download/$GHRDVER/ghrd -o /usr/local/bin/ghrd
    sudo chmod +x /usr/local/bin/ghrd
    sudo ln -s /usr/local/bin/ghrd /usr/bin/ghrd
    sudo apt install jq -y
}

function wsl2_x11_enable {
    export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
    export LIBGL_ALWAYS_INDIRECT=1
}
alias reddit='tuir'
alias fzbat="fzf --preview 'bat --style=numbers --color=always {}'"


FZF_TAB_GROUP_COLORS=(
    $'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS
zstyle ':completion:*:descriptions' format '[%d]' 

function reset_license {
     rm -rf ~/Library/Preferences/SmartSVN
}

export PATH="/usr/local/sbin:$PATH:$HOME/.local/bin"

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --color=always --exclude .git'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

