# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
# ghidra
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Xmx8G -Dawt.useSystemAAFontSettings=on'

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

ZSH_THEME="nanotech"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias mpvi="mpv --vo=gpu --hwdec=vaapi --gpu-context=wayland --ytdl-format='bestvideo[height<=?2160][fps<=?30]+bestaudio/best'"
alias pb="curl -F sunset=3600 -F c=@- 'https://ptpb.pw?u=1'"
alias vi=nvim
alias vim=nvim
alias zstat="awk '{print \"comp_ratio\", \$1/\$2, \"\nori_data_size\", \$1/1024/1024\"M\", \"\ncompr_data_size\", \$2/1024/1024\"M\", \"\nmem_used_total\", \$3/1024/1024\"M\", \"\nmem_limit\", \$4, \"\nmem_used_max\", \$5/1024/1024\"M\", \"\nzero_paes\", \$6, \"\nnum_migrated\", \$7}' /sys/block/zram0/mm_stat"

alias v2='. ~/venv/bin/activate'
alias v3='. ~/venv3/bin/activate'

if test "$TERM" = "xterm-termite"; then
  export TERM=xterm
fi

LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
LC_CTYPE=en_US.UTF-8 

set -o vi
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char

bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
bindkey -s "^[OM" "^M"
