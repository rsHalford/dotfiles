export ZDOTDIR="$HOME/.config/zsh"

if uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi
