# Research: Shell Script Techniques for Terminal Display

## ZSH Startup Hooks
- **`.zshrc`**: Source the wisdom script on shell startup
- **Method**: Add `source ~/.wisdom-bytes/wisdom.sh` or directly invoke the script at the end of `.zshrc`
- **Manual command**: Define a `wisdom` alias/function in `.zshrc` that runs the script on demand

## Tracking Shown Concepts
- **Approach**: Maintain a simple text file (`~/.wisdom-bytes/history`) that stores the last N shown concept filenames
- **Selection algorithm**: 
  1. List all concept files
  2. Remove recently shown ones from the pool
  3. Pick randomly from remaining
  4. Append selected concept to history file
  5. Trim history to keep only last N entries (e.g., N=20)

## Formatted Terminal Box Pattern
A pure zsh/bash function to draw a box border:

```zsh
print_box() {
  local title="$1"
  local content="$2"
  local source="$3"
  local emoji="$4"
  local width=72

  # Top border
  echo "┌$(printf '─%.0s' $(seq 1 $((width-2))))┐"
  
  # Title line
  printf "│ %-*s│\n" $((width-3)) "$emoji  $title"
  
  # Separator
  echo "│$(printf '─%.0s' $(seq 1 $((width-2))))│"
  
  # Content (split by newlines)
  while IFS= read -r line; do
    printf "│ %-*s│\n" $((width-3)) "$line"
  done <<< "$content"
  
  # Source line
  echo "│$(printf '─%.0s' $(seq 1 $((width-2))))│"
  printf "│ %-*s│\n" $((width-3)) "  $source"
  
  # Bottom border
  echo "└$(printf '─%.0s' $(seq 1 $((width-2))))┘"
}
```

## Existing ZSH Plugins for Reference
- **zsh-banner** (drkhsh): Displays ANSI/ASCII art on shell startup, configurable via env vars
- **zsh-welcome-banner** (joshuadanpeterson): Colorful welcome banners with inspirational quotes, uses figlet/lolcat
- **welcome** (codesignd): Modular information provider system for shell login messages

## Key Design Decisions
- Avoid external dependencies (no figlet, lolcat required)
- Use pure zsh string manipulation for portability
- Box-drawing characters (┌─┐└┘│) work in all modern terminals
- History file should be simple text, one filename per line
- Install script should be idempotent (check before adding to .zshrc)
