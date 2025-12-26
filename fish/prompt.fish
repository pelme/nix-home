function fish_prompt
    set -l last_status $status
    set -l stat
    if test $last_status -ne 0
        set stat (set_color red)"[$last_status] "(set_color normal)
    end

    set -l username ""
    test $USER != andreas; and set username (set_color ff6b6b)$USER" "(set_color normal)

    string join '' -- $stat $username (set_color green) (prompt_pwd) (set_color normal) '❯ '
end
