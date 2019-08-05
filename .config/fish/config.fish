set --universal EDITOR                 nvim
set --universal GIT_EDITOR             nvim
set --universal VISUAL                 nvim
set --universal FISH_POWERPROMPT_THEME "random"

# Colors
set --universal fish_color_command 00c5d7 darkcyan
set -gx LSCOLORS ExfxxxxxBx

if type -q ~/aliases.fish
    source ~/aliases.fish
end

# Add macports bin/ directory
set PATH /opt/local/bin $PATH

# Add pyenv to path
set --universal PYENV_ROOT "$HOME/.pyenv"
set PATH "$PYENV_ROOT/bin" $PATH

status --is-interactive; and source (pyenv init -|psub)
