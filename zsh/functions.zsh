

# GIT COMMANDS

# A function that git reset --hard and receives a property number. If there is no number, it will reset to the last commit.
function gitResetHard() { #Alias rh
  if [ -z "$1" ]; then
    echo "Usage: gitResetHard <n|0|current>  — provide number of commits to go back; use 0 or current for HEAD"
    return 1
  fi

  local target command
  case "$1" in
    0|current)
      target="current commit (HEAD)"
      command="git reset --hard HEAD"
      ;;
    ([0-9]*)
      target="$1 commits back (HEAD~$1)"
      command="git reset --hard HEAD~$1"
      ;;
    *)
      echo "Invalid argument: $1. Use a non-negative integer, or 'current'."
      return 1
      ;;
  esac

  echo -n "Are you sure you want to reset to $target? This will discard all changes! Type 'YES' to continue: "
  read answer
  if [ "$answer" = "YES" ]; then
    eval $command
  else
    echo "Operation cancelled."
  fi
}

# A function that git reset --soft and receives a property number. If there is no number, it will reset to the last commit.
function gitResetSoft() { #Alias rs
  if [ -z "$1" ]; then
    echo "Usage: gitResetSoft <n|0|current|all>  — provide number of commits to go back; use 0 or current for HEAD; 'all' resets to merge-base with master"
    return 1
  fi

  local target command branchName
  case "$1" in
    0|current)
      target="last commit (HEAD)"
      command="git reset --soft HEAD"
      ;;
    all)
      branchName=$(getCurrentBranch)
      target="merge-base with master for branch $branchName"
      command="git reset --soft $(git merge-base master $branchName)"
      ;;
    ([0-9]*)
      target="$1 commits back (HEAD~$1)"
      command="git reset --soft HEAD~$1"
      ;;
    *)
      echo "Invalid argument: $1. Use a non-negative integer, 'all', or 'current'."
      return 1
      ;;
  esac

  eval $command
}

function gitCommit() { #Alias gc
  if [ -z "$1" ]; then
    git commit -m "."
  else
    git commit -m "$1"
  fi
}

function gitCheckOut() { #Alias gco
  # If an argument is provided, defer to `git checkout` (e.g., git checkout -b new-branch)
  if [ -n "$1" ]; then
    git checkout "$@"
    return $?
  fi

  # Interactive mode
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not a git repository."
    return 1
  fi

  local current all_branches branches n i b target_branch
  current=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null)
  
  # Get all branches and filter out the current one
  all_branches=( $(git for-each-ref --format='%(refname:short)' refs/heads/) )
  branches=()
  for b in ${all_branches[@]}; do
    if [ "$b" != "$current" ]; then
      branches+=($b)
    fi
  done

  if [ ${#branches[@]} -eq 0 ]; then
    echo "No other local branches found."
    return 1
  fi

  local GREEN RESET
  GREEN=$'\033[1;32m'
  RESET=$'\033[0m'

  n=${#branches[@]}
  # Menu height = list size + 1 header line
  local menu_height=$((n + 1))
  local pos=1 key first_run=1

  echo "Use ↑/↓ to move, SPACE/ENTER to checkout, q to cancel."

  # Hide cursor and set trap
  tput civis
  trap 'tput cnorm; stty sane; echo "\nCancelled."; return 1' INT TERM

  while true; do
    # Move cursor up relative to menu height (skips first run)
    if [ $first_run -eq 0 ]; then
      printf "\033[%dA" "$menu_height"
    fi
    first_run=0

    printf "\033[J" # Clear from cursor to end of screen
    echo "Select branch to checkout:"

    for ((i=1;i<=n;i++)); do
      if [ "$i" -eq "$pos" ]; then
        printf "> %b%s%b\n" "$GREEN" "${branches[i]}" "$RESET"
      else
        printf "  %s\n" "${branches[i]}"
      fi
    done

    # Read key input
    key=""
    read -k 1 -s k1
    if [ "$k1" = $'\e' ]; then
      read -k 2 -s krest
      key="$k1$krest"
    else
      key="$k1"
    fi

    case "$key" in
      $'\e[A') # Up
        if (( pos > 1 )); then ((pos--)); else pos=$n; fi
        ;;
      $'\e[B') # Down
        if (( pos < n )); then ((pos++)); else pos=1; fi
        ;;
      ' '|$'\n'|$'\r') # Space or Enter to confirm
        target_branch="${branches[pos]}"
        break
        ;;
      q)
        tput cnorm
        echo "\nCancelled."
        return 0
        ;;
    esac
  done

  # Restore cursor
  tput cnorm
  
  # Perform checkout
  if [ -n "$target_branch" ]; then
    echo "\nChecking out to $target_branch..."
    git checkout "$target_branch"
  fi
}

function updateBranches() { #Alias ub
  # Interactive branch list allowing selection of multiple branches to delete
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Not a git repository."
    return 1
  fi

  local current all_branches branches n i b
  current=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null)
  
  # Get all branches first
  all_branches=( $(git for-each-ref --format='%(refname:short)' refs/heads/) )
  branches=()

  # Filter out the current branch
  for b in ${all_branches[@]}; do
    if [ "$b" != "$current" ]; then
      branches+=($b)
    fi
  done

  if [ ${#branches[@]} -eq 0 ]; then
    echo "No other local branches found (besides current)."
    return 1
  fi

  local GREEN RESET
  GREEN=$'\033[1;32m'
  RESET=$'\033[0m'

  n=${#branches[@]}
  # Calculate menu height: number of branches + 1 line for the "Select branches..." header
  local menu_height=$((n + 1))

  echo "Use ↑/↓ to move, SPACE to toggle, ENTER to confirm, q to cancel."

  typeset -a selected_flags
  for ((i=1;i<=n;i++)); do selected_flags[i]=0; done
  local pos=1 key first=1

  # Hide cursor
  tput civis
  trap 'tput cnorm; stty sane; printf "\nOperation cancelled.\n"; return 1' INT TERM

  local first_run=1

  while true; do
    # Logic: If this is not the first run, move cursor UP by menu_height to overwrite
    if [ $first_run -eq 0 ]; then
      printf "\033[%dA" "$menu_height"
    fi
    first_run=0

    printf "\033[J"  # clear to end of screen
    echo "Select branches to delete:"
    
    for ((i=1;i<=n;i++)); do
      b=${branches[i]}
      mark="[ ]"
      if [ "${selected_flags[i]}" -eq 1 ]; then
        mark="[x]"
      fi
      
      if [ "$i" -eq "$pos" ]; then
        printf "> %s %b%s%b\n" "$mark" "$GREEN" "$b" "$RESET"
      else
        printf "  %s %s\n" "$mark" "$b"
      fi
    done

    # read single key
    key=""
    read -k 1 -s k1
    if [ "$k1" = $'\e' ]; then
      read -k 2 -s krest
      key="$k1$krest"
    else
      key="$k1"
    fi

    case "$key" in
      $'\e[A') # up
        if (( pos > 1 )); then ((pos--)); else pos=$n; fi
        ;;
      $'\e[B') # down
        if (( pos < n )); then ((pos++)); else pos=1; fi
        ;;
      ' ') # space toggles
        if [ "${selected_flags[pos]}" -eq 1 ]; then
          selected_flags[pos]=0
        else
          selected_flags[pos]=1
        fi
        ;;
      $'\n'|$'\r') # enter confirm
        break
        ;;
      q)
        tput cnorm
        echo "\nOperation cancelled."
        return 0
        ;;
    esac
  done

  # restore cursor visibility
  tput cnorm

  # collect selected branches
  typeset -a to_delete
  for ((i=1;i<=n;i++)); do
    if [ "${selected_flags[i]}" -eq 1 ]; then
      to_delete+=(${branches[i]})
    fi
  done

  if [ ${#to_delete[@]} -eq 0 ]; then
    echo "No branches selected for deletion."
    return 0
  fi

  echo "The following branches will be deleted:" 
  for br in ${to_delete[@]}; do
    echo " - $br"
  done
  echo -n "Type 'YES' to confirm: "
  read ans
  if [ "$ans" != "YES" ]; then
    echo "Operation cancelled."
    return 0
  fi

  for br in ${to_delete[@]}; do
    git branch -d -- "$br" 2>/dev/null
    if [ $? -ne 0 ]; then
      echo "Failed to delete $br with -d. Asking to force-delete."
      echo -n "Force delete $br? (y/n): "
      read resp
      if [ "$resp" = "y" ]; then
        git branch -D -- "$br"
      else
        echo "Skipped $br."
      fi
    else
      echo "Deleted $br"
    fi
  done
}







# Database connection shortcut
function db() { #Alias db
  pgcli -h localhost -U admin -d my_agents_db "$@"
}
