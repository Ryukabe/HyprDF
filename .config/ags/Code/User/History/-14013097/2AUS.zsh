# Simple user-level plugin manager function
function user_plugin() {
    local name=$1
    local repo=$2
    local dir="$ZDOTDIR/plugins/$name"

    # If the plugin doesn't exist, download it automatically
    if [ ! -d "$dir" ]; then
        echo "Downloading plugin: $name..."
        git clone --depth 1 "$repo" "$dir"
    fi

    # Source the plugin code
    if [ -f "$dir/$name.plugin.zsh" ]; then
        source "$dir/$name.plugin.zsh"
    elif [ -f "$dir/$name.zsh" ]; then
        source "$dir/$name.zsh"
    fi
}

# --- FETCHING YOUR ORIGINAL PLUGIN STACK ---
user_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions"
user_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
user_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
user_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting"

# Enable native git completions (replaces the old OMZ git helper)
autoload -Uz vcs_info
