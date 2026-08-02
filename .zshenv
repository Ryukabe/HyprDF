# Clean user space directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Point Zsh directly to our modular config folder
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# --- YOUR ORIGINAL WAYLAND & GPU FLAGS ---
export MOZ_ENABLE_WAYLAND=1
export LIBVA_DRIVER_NAME=iHD
export LIBVA_DRIVER_NAME=i965