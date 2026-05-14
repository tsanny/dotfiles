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






kitty-reload() {
    kill -SIGUSR1 $(pidof kitty)
}

eval "$(zoxide init zsh)"

# bun completions
[ -s "/Users/sf.tsany/.bun/_bun" ] && source "/Users/sf.tsany/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# Function to compress a video file using ffmpeg and save it to the
# source file's directory.
# Usage: compressvid <input_file.mov>
# Function to compress video to specific size (Target: < 10MB)
# Usage: compressvid <input_file> [height]
compressvid() {
  local INPUT_FILE="$1"
  local TARGET_HEIGHT=${2:-720} # Default to 720p
  local TARGET_SIZE_MB=6

  # --- 1. Validation ---
  if [ -z "$INPUT_FILE" ]; then
    echo "Error: No input file specified."
    echo "Usage: compressvid <input_file> [height]"
    return 1
  fi

  local INPUT_PATH=$(readlink -f "$INPUT_FILE")
  if [ ! -f "$INPUT_PATH" ]; then
    echo "Error: File not found: '$INPUT_FILE'"
    return 1
  fi

  # Check for ffprobe (usually comes with ffmpeg)
  if ! command -v ffprobe &> /dev/null; then
    echo "Error: 'ffprobe' is required but not found."
    return 1
  fi

  # --- 2. Setup Variables ---
  local INPUT_DIR="${INPUT_PATH:h}"
  local FILENAME_ROOT="${INPUT_PATH:t:r}"
  local OUTPUT_FILE="${INPUT_DIR}/compressed_10mb_${FILENAME_ROOT}.mp4"

  # --- 3. Get Duration & Calculate Bitrate ---
  echo "🔍 Analyzing video duration..."

  # Get duration in seconds (floating point)
  local DURATION=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$INPUT_PATH")

  # Calculate Target Video Bitrate using awk
  # Formula: (9.5MB * 8192 kbits/MB / duration) - 128k audio
  # We target 9.5MB to allow 0.5MB safety buffer for container overhead
  local VIDEO_BITRATE=$(awk -v dur="$DURATION" 'BEGIN { printf "%.0f", (9.5 * 8192 / dur) - 128 }')

  # Safety check: Prevent negative or extremely low bitrates for long videos
  if [ "$VIDEO_BITRATE" -lt 100 ]; then
    echo "⚠️  WARNING: This video is too long to fit into 10MB with acceptable quality."
    echo "   Calculated bitrate: ${VIDEO_BITRATE}k. Aborting to prevent creating garbage."
    return 1
  fi

  echo "📋 Stats:"
  echo "   Duration: ${DURATION}s"
  echo "   Target Height: ${TARGET_HEIGHT}p"
  echo "   Video Bitrate: ${VIDEO_BITRATE}k"
  echo "   Audio Bitrate: 128k"
  echo "   Output: '$OUTPUT_FILE'"
  echo "---"

  if [ -f "$OUTPUT_FILE" ]; then
    echo "Warning: Output file exists. Overwriting in 5 seconds..."
    sleep 5
  fi

  # --- 4. Two-Pass Encoding ---

  # PASS 1: Analysis (Output to /dev/null, audio disabled)
  echo "🔄 Running Pass 1 (Analysis)..."
  ffmpeg -y -i "$INPUT_PATH" \
    -vf "scale=-2:${TARGET_HEIGHT}" \
    -c:v libx264 -b:v "${VIDEO_BITRATE}k" -pass 1 -an \
    -f mp4 /dev/null \
    -loglevel warning

  if [ $? -ne 0 ]; then echo "❌ Pass 1 failed"; return 1; fi

  # PASS 2: Actual Encoding
  echo "🚀 Running Pass 2 (Compression)..."
  ffmpeg -y -i "$INPUT_PATH" \
    -vf "scale=-2:${TARGET_HEIGHT}" \
    -c:v libx264 -b:v "${VIDEO_BITRATE}k" -pass 2 \
    -c:a aac -b:a 128k \
    "$OUTPUT_FILE" \
    -loglevel warning

  # --- 5. Cleanup ---
  # Remove the temporary log files created by -pass
  rm -f ffmpeg2pass-0.log ffmpeg2pass-0.log.mbtree

  echo "---"
  if [ $? -eq 0 ]; then
    local ACTUAL_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo "✅ Done! Final Size: $ACTUAL_SIZE"
  else
    echo "❌ Compression failed."
    return 1
  fi
}
