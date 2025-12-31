

function sshp() {
    # Set Git global configuration for personal account
    git config --global user.name "KajiyamaVK"
    git config --global user.email "victor.kajiyama@gmail.com"

    # Update SSH agent to use personal SSH key
    ssh-add -D  # Remove all identities from ssh-agent
    ssh-add ~/.ssh/id_ed25519_personal

    # Explicitly set GH_CONFIG_DIR to personal account
    export GH_CONFIG_DIR=~/.config/gh/personal

    # Check and authenticate if necessary
    if ! gh auth status > /dev/null 2>&1; then
        gh auth login --hostname github.com --git-protocol ssh
    fi

    echo "Switched to Personal GitHub account."
}

# GIT COMMANDS
# A function that git reset --hard and receives a property number. If there is no number, it will reset to the last commit.

# A function that returns the current branch name
function getCurrentBranch() {
  git branch --show-current
}

# Check if the branch exists remotely
function branchExistsRemotely() {
  git ls-remote --heads origin $1
}

function deleteBranch() {
  if [ -z "$1" ]; then
    echo "Usage: deleteBranch <branch-name>"
    return 1
  fi
  # if the branch is the current branch, checkout to master
  if [ "$(getCurrentBranch)" = "$1" ]; then
    gco master
  fi
  git branch -D $1

  # Check if the branch exists remotely
  if branchExistsRemotely $1; then
    # Ask if want to delete the branch remotely
    echo "Do you want to delete the branch $1 remotely? (y/n)"
    read answer
    if [ "$answer" = "y" ]; then
      git push origin --delete $1
    fi
  fi
}

function rh() {
  local target
  if [ -z "$1" ]; then
    target="current commit (HEAD)"
    command="git reset --hard HEAD"
  else
    target="$1 commits back (HEAD~$1)"
    command="git reset --hard HEAD~$1"
  fi

  echo -n "Are you sure you want to reset to $target? This will discard all changes! Type 'YES' to continue: "
  read answer
  if [ "$answer" = "YES" ]; then
    eval $command
  else
    echo "Operation cancelled."
  fi
}

function rs() {
  local target
  if [ -z "$1" ]; then
    target="last commit (HEAD)"
    command="git reset --soft HEAD"
  elif [ "$1" = "all" ]; then
    branchName=$(getCurrentBranch)
    command="git reset --soft $(git merge-base master $branchName)"
  else
    target="$1 commits back (HEAD~$1)"
    command="git reset --soft HEAD~$1"
  fi
  eval $command
}

function stash() {
  local message
  if [ -z "$1" ]; then
    # If no message provided, just do a simple stash
    git stash list
  else
    # If message provided, use save with the message
    git stash save "$1"
  fi
}

function commit() {
  if [ -z "$1" ]; then
    git commit -m "."
  else
    git commit -m "$1"
  fi
}

function gco() {
  # First, check if the branch exists. If it doesn't, make use of -b to create it.
  git branch -a | grep -q "$1"
  if [ $? -eq 0 ]; then
    git checkout "$1"
  else
    # Present a prompt to the user to confirm the creation of the branch.
    echo "Branch '$1' does not exist. Do you want to create it? (y/n)"
    read answer
    if [ "$answer" = "y" ]; then
      git checkout -b "$1"
    else
      echo "Operation cancelled."
    fi
  fi
}

function preparePR() {
  if [ -z "$1" ]; then
    echo "Error: You need to specify the branch name."
    echo "Usage: git_reset_branch <branch-name>"
    return 1
  fi

  local BRANCH_NAME=$1

  echo "Adding all changes to the index..."
  git add -A

  echo "Saving current changes to the stash..."
  git stash push -m "Backup before reset"

  echo "Resetting branch to its initial state..."
  git reset --soft $(git merge-base master $BRANCH_NAME)

  echo "Deleting remote branch (if it exists)..."
  git push origin --delete $BRANCH_NAME 2>/dev/null || echo "No remote branch found for $BRANCH_NAME"

  echo "Switching to master..."
  git checkout master

  echo "Pulling latest changes from master..."
  git pull origin master

  echo "Deleting local branch $BRANCH_NAME..."
  git branch -D $BRANCH_NAME

  echo "Recreating branch $BRANCH_NAME..."
  git checkout -b $BRANCH_NAME

  echo "Applying changes from stash..."
  git stash apply || echo "Error applying stash. Please check manually."

  echo "Process complete! Check the status of your branch with 'git status'."
}

# PROJECT COMMANDS

function prepare() {
  if [ -z "$1" ]; then
    echo "Usage: prepare <project-name>"
    return 1
  fi
  nr build --filter="$1^..."
}

function dev() {
  if [ -z "$1" ]; then
    echo "Usage: dev <project-name>"
    return 1
  fi
  prepare "$1" && nr dev --filter="$1"
}

function teste2e() {
  if [ -z "$1" ]; then
    #show a confirmation message so the user can cancel the operation
    echo "Running all tests"
    echo -n "Are you sure you want to run all tests? (y/n): "
    read answer
    if [ "$answer" = "y" ]; then
      npm run test:e2e
    else
      echo "Operation cancelled."
    fi
  else
    echo "Running test $1"
    npm run test:e2e test/$1.e2e-spec.ts
  fi
}





