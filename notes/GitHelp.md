# Basic / Abbrev

    ga `filename`                   Git Add 'filename'
    gc -m "message"                 Git commit with a "message"
    gp                              Git Push
    gl                              Git Pull
    glo/glol/glola                  Git log
    gd                              git diff
    gsta                            git stash
    grh                             git reset

# Resetting

    grhh 'commitID'                 git reset --hard HEAD (Reverting to commit)
    gco HEAD `filename`             Reset a file from commit

    git reset --soft HEAD^          Undo commit
    git reset --hard HEAD^          Undo commit and reset to previous commit

    git reflog                      Show all my history of git command
    git reset HEAD#{#}              #: number => Go back git history

# Branching

    gco -b `feature/name` develop   Branch off from develop
    =====WORK=======
    gcd = gco develop               Checkout to develop
    gmnoff `feature/name`           Merge the final commit to develop
    gb -d `feature/name`            Delete branch

# Stashing

    git stash save "comments"
    git stash save -u               Stash untracked files
    git stash list
    git stash apply/pop             Apply or Apply => Delete
    git stash show -p               Show : -p full description
    git stash drop stash@{1}        Delete one stash
    git stash clear                 Delete all stash

# Rebase

    git rebase branchName           Rebase the branch to the branchName

# Remotes

    git remote -v                           View all remotes
    git remote add origin `ssh-address`     Add a remote origin
    git remote rename origin upstream       Rename remote a to b
    git remote remove origin                Remove remote origin
    git fetch/pull/push origin              Fetch/Pull/Push remote origin

# SSH Key Gen
```bash
# List all files in .ssh
ls -al ~/.ssh

# Generate ssh-key
ssh-keygen -t rsa -b 4096 -C "email@example.com"

# Copy the id-rsa.pub file in clipboard
pbcopy < ~/.ssh/id_rsa.pub

# If git keeps asking for a passphrase,
eval $(ssh-agent) # Check you have started the SSH agent
ssh-add # This will generate a private key and allow your computer to if your public key is added to Github
ssh-add -K # This saves your private key to user's keychain so it works even after close/re-open terminal
```
