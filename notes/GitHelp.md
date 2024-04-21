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

# Setting up authentication

1. Install Github CLI

```bash
brew install gh
```

2. Log into github

- -> Settings (Profile->Settings)
  - -> Developer Settings (Left bottom)
    - -> Personal Access Tokens

3. Create an access token.

- Make sure repo and admin:org is enabled

4. Copy the token

5. Run github cli to sign in

```bash
gh auth login
```

6. Use the token to sign in :)

# Setting up SSH

1. Generate key

```bash
ssh-keygen -t ed25519 -C "email@email.com"

# Give a name to the key file
Enter file in which to save the key (/Users/chris.kang/.ssh/id_ed25519): /Users/chris.kang/.ssh/my_custom_key
```

2. Start the ssh-agent in the background

```bash
eval "$(ssh-agent -s)"
> Agent pid *****
```

3. Create `~/.ssh/config` if it doesn't exist

4. Update `~/.ssh/config`

```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/my_custom_key
```

5. Add SSH private key to the ssh-agent and store your passphrase in the keychain

```bash
ssh-add --apple-use-keychain ~/.ssh/my_custom_key
```
