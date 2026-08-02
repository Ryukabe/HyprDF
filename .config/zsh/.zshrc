# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$ZDOTDIR/ohmyzsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# --- 1. POWERLEVEL10K INSTANT PROMPT ---
# Must remain at the absolute top of the file to guarantee instant terminal load times
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- 2. SYSTEM COMPLETION ENGINE SETUP ---
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# --- 3. LOAD USER CONFIG BLOCKS ---
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/plugins.zsh"
source "$ZDOTDIR/aliases.zsh"

# --- 4. YOUR NATIVE POWERLEVEL10K THEME ---
# Loads the underlying theme files
source "$HOME/powerlevel10k/powerlevel10k.zsh-theme"

# Loads your custom user preferences, prompt layout, and styles
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
source /home/shiham/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/shiham/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/shiham/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
