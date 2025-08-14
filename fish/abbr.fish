abbr --add g git
abbr --add gs git status
abbr --add gc git commit
abbr --add gd git diff
abbr --add gl git log
abbr --add gds git diff --staged
abbr --add gsw git switch
abbr --add grb git rebase
abbr --add gri git rebase -i origin/main
abbr --add gp git push
abbr --add gpf git push --force-with-lease
abbr --add gpm git pull origin main
abbr --add glm git log --oneline --reverse origin/main..
abbr --add gbr git branch
abbr --add gdm git diff origin/main
abbr --add gaa git add --all
abbr --add gam git commit -a --amend
abbr --add gre git restore

abbr --add grs git reset
abbr --add grsh git reset HEAD^
abbr --add wip git add --all \; git commit -m WIP -n

abbr --add ax aws-vault exec pk --
abbr --add dj django-admin
abbr --add djr django-admin runserver
abbr --add djc django-admin celery
abbr --add djs django-admin shell_plus --quiet-load
abbr --add djm django-admin migrate

abbr --add cd.. cd ..
abbr --add cd... cd ../..
abbr --add cd.... cd ../../..

abbr --add k kubectl
abbr --add kp kubectl -n production
abbr --add kr kubectl -n review

abbr --add jjw "watch -n0.5 --color jj --ignore-working-copy log --color=always\;echo\;jj --color=always status"
abbr --add jjr 'git fetch && jj rebase -b "mutable() & mine()" -d main@origin --skip-emptied'
