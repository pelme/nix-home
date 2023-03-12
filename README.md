Based on https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050

1) Install nix
2) ./switch
3) echo /etc/profiles/per-user/andreas/bin/fish | sudo tee -a /etc/shells
4) chsh -s /etc/profiles/per-user/andreas/bin/fish
