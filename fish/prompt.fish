function prompt_long_pwd --description 'Print the current working directory'
    echo $PWD | sed -e "s|^$HOME|~|"
end


set -g __fish_git_prompt_color_branch green --bold

function fish_prompt --description 'Write out the prompt, Andreas style'
    echo -n -s (__fish_git_prompt (set_color green)"%s"(set_color green)" ")
    echo -n -s (set_color normal) (prompt_pwd) (set_color normal)
    echo -n -s (set_color -o purple ) " \$ " (set_color normal)
end

