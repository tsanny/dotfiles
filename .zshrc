# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/Users/sf.tsany/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/sf.tsany/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

. "$HOME/.local/bin/env"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"





# Function to compress a video file using ffmpeg and save it to the 
# source file's directory.
# Usage: compressvid <input_file.mov>
compressvid() {
  # Check if a file was provided
  if [ -z "$1" ]; then
    echo "Error: No input file specified."
    echo "Usage: compressvid <input_file>"
    return 1
  fi

  # 1. Get the absolute path to the input file
  # Note: The 'readlink -f' command is a standard way to resolve paths.
  local INPUT_PATH=$(readlink -f "$1")

  # Check if the file exists (using the resolved path)
  if [ ! -f "$INPUT_PATH" ]; then
    echo "Error: File not found or path could not be resolved: '$1'"
    return 1
  fi

  # 2. Extract components using Zsh parameter expansion
  # ${INPUT_PATH:h} - Head (directory path)
  # ${INPUT_PATH:t:r} - Tail (filename) and Root (remove extension)
  local INPUT_DIR="${INPUT_PATH:h}"
  local FILENAME_ROOT="${INPUT_PATH:t:r}"
  
  # 3. Define the full path for the output file
  local OUTPUT_FILE="${INPUT_DIR}/compressed_${FILENAME_ROOT}.mp4"

  # Check if the output file already exists
  if [ -f "$OUTPUT_FILE" ]; then
    echo "Warning: Output file '$OUTPUT_FILE' already exists. Overwriting in 5 seconds (Ctrl+C to cancel)..."
    sleep 5
  fi

  echo "🎥 Starting compression..."
  echo "Input:  '$INPUT_PATH'"
  echo "Output: '$OUTPUT_FILE'"
  echo "---"

  # The ffmpeg command
  ffmpeg -i "$INPUT_PATH" -c:v libx264 -crf 23 -c:a aac -b:a 128k "$OUTPUT_FILE"
  
  # Check the exit status of ffmpeg
  if [ $? -eq 0 ]; then
    echo "---"
    echo "✅ Compression complete!"
  else
    echo "---"
    echo "❌ Compression failed. Check ffmpeg output for errors."
    return 1
  fi
}
