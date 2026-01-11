set -g fish_greeting

if status is-interactive
    set -x SSH_AUTH_SOCK "$HOME/.1password/agent.sock"

    zoxide init fish --cmd g | source
    mise activate fish | source
    starship init fish | source
end
