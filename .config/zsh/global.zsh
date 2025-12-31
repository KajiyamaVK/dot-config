export ZSH=$HOME/.oh-my-zsh
export PATH="/opt/homebrew/bin:$PATH"
export PATH=$HOME/bin:/usr/local/go/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PNPM_HOME="/Users/victor.kajiyama/Library/pnpm"
export NVM_DIR="$HOME/.nvm"
# export JAVA_HOME=$(/usr/libexec/java_home -v 17) (This only works for Mac. It was needed for torticity mobile app)
export PATH=$JAVA_HOME/bin:$PATH

# Config Alias
alias init='cursor ~/.config/nvim/init.lua'
alias settings='cursor ~/.config/nvim/lua/settings.lua'
alias mappings='cursor ~/.config/nvim/lua/mappings.lua'
alias plugins='cursor ~/.config/nvim/lua/plugins.lua'
alias global='cursor ~/.config/zsh/global.zsh'
alias zshrc='cursor ~/.zshrc'
alias sourceAgain='source ~/.zshrc'

# Path Alias
alias src='cd ~/src/'
alias myProjects='cd ~/src/myProjects/'

# Git Alias
alias gl='git pull'
alias gp='git push'
alias add='git add .'
alias log='git log'
alias status='git status'

# Project Alias
alias nrd='npm run dev'
alias pr-evaluate='cd "/Users/victor.kajiyama/src/myProjects/pr-evaluate"'
alias helpr='cd "/Users/victor.kajiyama/src/myProjects/helpr"'
alias dockit-ui-next='cd "/Users/victor.kajiyama/torticity/apps/dockit-ui-next"'
alias dockit-api='cd "/Users/victor.kajiyama/torticity/apps/dockit-api"'
alias claimant-portal-api='cd "/Users/victor.kajiyama/torticity/apps/claimant-portal-api"'
alias brief-api='cd "/Users/victor.kajiyama/torticity/apps/brief-api"'

# Utility Alias
alias cu='cursor . -r'
alias cl='clear'

### Brief
alias b='dev brief-ui'
alias brief=b
alias bate='prepare brief-api && nr --filter brief-api test:e2e:watch'
alias batu='prepare brief-api && nr --filter brief-api test:unit:watch'
### Dockit
alias d='dev dockit-ui-next'
alias dockit=d
alias dtc='prepare dockit-ui-next&& nr --filter dockit-ui-next test:component'
alias dtu='prepare dockit-ui-next&& nr --filter dockit-ui-next test:unit'
alias dtuu='prepare dockit-ui-next && nr --filter dockit-ui-next test:unit:ui'
alias da='dev dockit-api'
alias datu='prepare dockit-api && nr --filter dockit-api test:unit:watch'
alias date='prepare dockit-api && nr --filter dockit-api test:e2e:watch'
### CaseWise
alias cpui='dev claimant-portal-ui'
alias cpapi='dev claimant-portal-api'
### TortEquity
alias fpui='dev financier-portal-ui'
alias fpapi='dev financier-portal-api'
alias fpapitu='prepare financier-portal-api && nr --filter financier-portal-api test:unit:watch'
alias fpapite='prepare financier-portal-api && nr --filter financier-portal-api test:e2e:watch'alias torticity='cd "/Users/victor.kajiyama/torticity"'
