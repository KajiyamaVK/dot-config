export ZSH=$HOME/.oh-my-zsh
export PATH="/opt/homebrew/bin:$PATH"
export PATH=$HOME/bin:/usr/local/go/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PNPM_HOME="/Users/victor.kajiyama/Library/pnpm"
export NVM_DIR="$HOME/.nvm"
# export JAVA_HOME=$(/usr/libexec/java_home -v 17) (This only works for Mac. It was needed for torticity mobile app)
export PATH=$JAVA_HOME/bin:$PATH

#Terminal Commands

alias cl='clear'

# Git General Commands

alias gl='git pull'
alias gp='git push'
alias add='git add .'
alias log='git log'
alias status='git status'

# Git Custom Functions

alias rh='gitResetHard'
alias rs='gitResetSoft'
alias gc='gitCommit'
alias gco='gitCheckOut'
alias ub='updateBranches'
