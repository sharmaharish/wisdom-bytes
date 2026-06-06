#!/usr/bin/env zsh

setopt local_options no_monitor

WISDOM_HOME="${WISDOM_HOME:-"$(cd "$(dirname "$(realpath "$0")")" && pwd)"}"
WISDOM_DATA_DIR="${WISDOM_DATA_DIR:-"${HOME}/.wisdom-bytes"}"
HISTORY_SIZE="${HISTORY_SIZE:-20}"

list_concepts() {
  local dir="${1:-$WISDOM_HOME/concepts}"
  if [[ ! -d "$dir" ]]; then
    echo "ERROR: Concepts directory not found at $dir" >&2
    return 1
  fi
  find "$dir" -name '*.txt' -type f 2>/dev/null | sort
}

parse_concept() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo "ERROR: File not found: $file" >&2
    return 1
  fi

  local name=""
  local category=""
  local tags=""
  local description=""
  local example=""
  local source=""
  local section="header"

  while IFS= read -r line || [[ -n "$line" ]]; do
    case "$section" in
      header)
        if [[ "$line" =~ ^Name:\ (.*) ]]; then
          name="${match[1]}"
        elif [[ "$line" =~ ^Category:\ (.*) ]]; then
          category="${match[1]}"
        elif [[ "$line" =~ ^Tags:\ (.*) ]]; then
          tags="${match[1]}"
        elif [[ -z "$line" ]]; then
          section="description"
        fi
        ;;
      description)
        if [[ "$line" =~ ^Example:\ (.*) ]]; then
          if [[ -n "${match[1]}" ]]; then
            example="${match[1]}"
          fi
          section="example"
        elif [[ "$line" =~ ^Source:\ (.*) ]]; then
          source="${match[1]}"
          section="done"
        else
          if [[ -z "$description" ]]; then
            description="$line"
          else
            description="$description
$line"
          fi
        fi
        ;;
      example)
        if [[ "$line" =~ ^Source:\ (.*) ]]; then
          source="${match[1]}"
          section="done"
        else
          if [[ -z "$example" ]]; then
            example="$line"
          else
            example="$example
$line"
          fi
        fi
        ;;
    esac
  done < "$file"

  echo "name: $name"
  echo "category: $category"
  echo "tags: $tags"
  echo "description: $description"
  echo "example: $example"
  echo "source: $source"
  echo "file: $file"
}

pick_random() {
  local -a items=("${(@f)$(cat)}")
  local -a exclude=("${(@f)$(cat)}")

  if [[ ${#items[@]} -eq 0 ]]; then
    return 1
  fi

  if [[ ${#exclude[@]} -gt 0 ]]; then
    local -a filtered=()
    for item in "${items[@]}"; do
      local excluded=0
      for ex in "${exclude[@]}"; do
        if [[ "$item" == "$ex" ]]; then
          excluded=1
          break
        fi
      done
      if [[ $excluded -eq 0 ]]; then
        filtered+=("$item")
      fi
    done
    items=("${filtered[@]}")
  fi

  if [[ ${#items[@]} -eq 0 ]]; then
    return 1
  fi

  local idx=$(( (RANDOM * 32768 + RANDOM) % ${#items[@]} ))
  echo "${items[$idx + 1]}"
}

read_history() {
  local histfile="$WISDOM_DATA_DIR/history"
  if [[ -f "$histfile" ]]; then
    cat "$histfile"
  fi
}

write_history() {
  local entry="$1"
  local histfile="$WISDOM_DATA_DIR/history"
  mkdir -p "$WISDOM_DATA_DIR"
  if [[ -f "$histfile" ]]; then
    echo "$entry" >> "$histfile"
  else
    echo "$entry" > "$histfile"
  fi
  local lines
  lines="$(wc -l < "$histfile")"
  if [[ "$lines" -gt "$HISTORY_SIZE" ]]; then
    tail -n "$HISTORY_SIZE" "$histfile" > "${histfile}.tmp" && mv "${histfile}.tmp" "$histfile"
  fi
}

get_emoji() {
  local category="$1"
  case "$category" in
    engineering-laws)       echo "⚙️" ;;
    mental-models)          echo "🧠" ;;
    cognitive-biases)       echo "🎯" ;;
    paradoxes)              echo "🔄" ;;
    design-principles)      echo "📐" ;;
    heuristics)             echo "💡" ;;
    fallacies)              echo "⚠️" ;;
    economic-principles)    echo "📊" ;;
    scientific-laws)        echo "🔬" ;;
    decision-frameworks)    echo "🗺️" ;;
    programming-wisdom)     echo "🖥️" ;;
    *)                      echo "📌" ;;
  esac
}

display_box() {
  local concept_file="$1"
  if [[ ! -f "$concept_file" ]]; then
    echo "ERROR: Concept file not found: $concept_file" >&2
    return 1
  fi

  local parsed
  parsed="$(parse_concept "$concept_file")"

  local name category description example source
  name="$(echo "$parsed" | sed -n 's/^name: //p')"
  category="$(echo "$parsed" | sed -n 's/^category: //p')"
  description="$(echo "$parsed" | sed -n 's/^description: //p')"
  example="$(echo "$parsed" | sed -n 's/^example: //p')"
  source="$(echo "$parsed" | sed -n 's/^source: //p')"

  local width=72
  local emoji
  emoji="$(get_emoji "$category")"

  local pad=$(( width - 3 ))

  print_top_border() {
    echo "┌$(printf '─%.0s' $(seq 1 $((width - 2))))┐"
  }

  print_bottom_border() {
    echo "└$(printf '─%.0s' $(seq 1 $((width - 2))))┘"
  }

  print_separator() {
    echo "│$(printf '─%.0s' $(seq 1 $((width - 2))))│"
  }

  print_line() {
    local text="$1"
    printf "│ %-*s│\n" "$pad" "$text"
  }

  print_wrapped() {
    local text="$1"
    local indent="$2"
    local avail=$(( width - 4 - indent ))
    while [[ -n "$text" ]]; do
      if [[ ${#text} -le $avail ]]; then
        printf "│ %-*s│\n" "$((pad))" "${(r:$indent:: :)}$text"
        break
      fi
      local slice="${text:0:$avail}"
      local space="${slice% *}"
      if [[ ${#space} -eq ${#slice} ]] || [[ -z "$space" ]]; then
        space="$slice"
        text="${text#$slice}"
      else
        text="${text#$space }"
      fi
      printf "│ %-*s│\n" "$((pad))" "${(r:$indent:: :)}${space}"
    done
  }

  print_top_border
  print_line "$emoji  $name"
  print_separator
  print_wrapped "$description" 0

  if [[ -n "$example" ]]; then
    echo ""
    print_wrapped "Example: $example" 0
  fi

  if [[ -n "$source" ]]; then
    print_separator
    local display_source="$source"
    if [[ ${#display_source} -gt $pad ]]; then
      display_source="…${display_source:$((pad - 55)):55}"
    fi
    printf "│ %-*s│\n" "$pad" "$display_source"
  fi
  print_bottom_border
}

wisdom() {
  local all_concepts
  all_concepts="$(list_concepts)"
  if [[ $? -ne 0 ]] || [[ -z "$all_concepts" ]]; then
    echo "No wisdom found. Ensure concept files exist in \$WISDOM_HOME/concepts/"
    return 1
  fi

  local -a concepts=("${(@f)all_concepts}")
  local -a recent=("${(@f)$(read_history)}")
  local -a recent_basenames=()
  for f in "${recent[@]}"; do
    recent_basenames+=("$(basename "$f")")
  done

  local -a pool=()
  for c in "${concepts[@]}"; do
    local cb="$(basename "$c")" found=0
    for rb in "${recent_basenames[@]}"; do
      if [[ "$cb" == "$rb" ]]; then
        found=1
        break
      fi
    done
    if [[ $found -eq 0 ]]; then
      pool+=("$c")
    fi
  done

  if [[ ${#pool[@]} -eq 0 ]]; then
    pool=("${concepts[@]}")
  fi

  local idx=$(( (RANDOM * 32768 + RANDOM) % ${#pool[@]} ))
  chosen="${pool[$idx + 1]}"

  display_box "$chosen"
  write_history "$(basename "$chosen")"
}

wisdom
