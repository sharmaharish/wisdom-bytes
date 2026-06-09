#!/usr/bin/env zsh

setopt local_options no_monitor

WISDOM_HOME="${WISDOM_HOME:-"$(cd "$(dirname "$(realpath "$0")")" && pwd)"}"
WISDOM_DATA_DIR="${WISDOM_DATA_DIR:-"${HOME}/.wisdom-bytes"}"
HISTORY_SIZE="${HISTORY_SIZE:-20}"
WISDOM_CATEGORIES="${WISDOM_CATEGORIES:-}"

list_concepts() {
  local dir="${1:-$WISDOM_HOME/concepts}"
  if [[ ! -d "$dir" ]]; then
    echo "ERROR: Concepts directory not found at $dir" >&2
    return 1
  fi
  local -a files=("$dir"/**/*.txt(.N))
  print -l "${(@o)files}"
}

list_categories() {
  local -a files=("${(@f)$(list_concepts)}")
  local -a cats=()
  local f dir
  for f in "${files[@]}"; do
    dir="$f:h:t"
    if (( ! $cats[(Ie)$dir] )); then
      cats+=("$dir")
    fi
  done
  echo "${(j:, :)cats}"
}

ws_usage() {
  echo "Usage: ws [options] [categories]"
  echo ""
  echo "Options:"
  echo "  -l, --list       List available categories"
  echo "  -h, --help       Show this help message"
  echo ""
  echo "Arguments:"
  echo "  categories       Comma-separated list of categories to filter by"
  echo ""
  echo "Examples:"
  echo "  ws                          Random wisdom byte"
  echo "  ws engineering-laws         Pick from engineering-laws"
  echo "  ws engineering-laws,mental-models"
  echo "                              Pick from multiple categories"
  echo "  ws -l                       List all categories"
  echo ""
  echo "Environment:"
  echo "  WISDOM_CATEGORIES           Default category filter (comma-separated)"
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
    local excluded item ex
    for item in "${items[@]}"; do
      excluded=0
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
    echo "$(<$histfile)"
  fi
}

write_history() {
  local entry="$1"
  local histfile="$WISDOM_DATA_DIR/history"
  mkdir -p "$WISDOM_DATA_DIR"
  echo "$entry" >> "$histfile"
  local -a lines=("${(@f)"$(<$histfile)"}")
  if [[ ${#lines[@]} -gt $HISTORY_SIZE ]]; then
    print -l "${lines[-$HISTORY_SIZE,-1]}" > "$histfile"
  fi
}

typeset -g -A _EMOJI=(
  engineering-laws    "⚙️"
  mental-models       "🧠"
  cognitive-biases    "🎯"
  paradoxes           "🔄"
  design-principles   "📐"
  heuristics          "💡"
  fallacies           "⚠️"
  economic-principles "📊"
  scientific-laws     "🔬"
  decision-frameworks "🗺️"
  programming-wisdom  "🖥️"
)

typeset -g -A _CATEGORY_NAME=(
  engineering-laws    "Engineering Laws"
  mental-models       "Mental Models"
  cognitive-biases    "Cognitive Biases"
  paradoxes           "Paradoxes"
  design-principles   "Design Principles"
  heuristics          "Heuristics"
  fallacies           "Logical Fallacies"
  economic-principles "Economic Principles"
  scientific-laws     "Scientific Laws"
  decision-frameworks "Decision Frameworks"
  programming-wisdom  "Programming Wisdom"
)

display_box() {
  local concept_file="$1"
  if [[ ! -f "$concept_file" ]]; then
    echo "ERROR: Concept file not found: $concept_file" >&2
    return 1
  fi

  local parsed
  parsed="$(parse_concept "$concept_file")"

  local -a parsed_lines=("${(f)parsed}")
  local name category description example source
  name="${${(@M)parsed_lines:#name: *}#name: }"
  category="${${(@M)parsed_lines:#category: *}#category: }"
  description="${${(@M)parsed_lines:#description: *}#description: }"
  example="${${(@M)parsed_lines:#example: *}#example: }"
  source="${${(@M)parsed_lines:#source: *}#source: }"

  local width=72
  local emoji="${_EMOJI[$category]:-📌}"
  local category_display="${_CATEGORY_NAME[$category]:-$category}"

  local pad=$(( width - 3 ))

  print_top_border() {
    echo "┌${(l:$((width - 2))::─:)}┐"
  }

  print_bottom_border() {
    echo "└${(l:$((width - 2))::─:)}┘"
  }

  print_separator() {
    echo "│${(l:$((width - 2))::─:)}│"
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
  print_line "$emoji  [$category_display] \"$name\""
  print_separator
  print_wrapped "$description" 0

  if [[ -n "$example" ]]; then
    print_line ""
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

  local -a all_files=("${(@f)all_concepts}")

  if [[ -n "$WISDOM_CATEGORIES" ]]; then
    local -a cats=("${(@s:,:)WISDOM_CATEGORIES}")
    local -a filtered=()
    for _f in "${all_files[@]}"; do
      if (( $cats[(Ie)$_f:h:t] )); then
        filtered+=("$_f")
      fi
    done
    all_files=("${filtered[@]}")
    if [[ ${#all_files[@]} -eq 0 ]]; then
      echo "Error: no concepts found for categories: $WISDOM_CATEGORIES" >&2
      echo "Available categories: $(list_categories)" >&2
      return 1
    fi
  fi

  local -a concepts=("${all_files[@]}")
  local -a recent=("${(@f)$(read_history)}")
  local -a recent_basenames=("${recent[@]##*/}")

  local -a pool=()
  local cb c rb found
  for c in "${concepts[@]}"; do
    cb="$c:t"
    found=0
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
  write_history "$chosen:t"
}

ws() {
  if [[ $# -eq 0 ]]; then
    wisdom
    return
  fi

  case "$1" in
    -l|--list)
      list_categories
      ;;
    -h|--help)
      ws_usage
      ;;
    *)
      local input_cats=("${(@s:,:)1}")
      local -a available_cats=()
      local f dir
      for f in "${(@f)$(list_concepts)}"; do
        dir="$f:h:t"
        if (( ! $available_cats[(Ie)$dir] )); then
          available_cats+=("$dir")
        fi
      done
      local invalid=0
      local cat
      for cat in "${input_cats[@]}"; do
        if (( ! $available_cats[(Ie)$cat] )); then
          echo "Error: unknown category '$cat'" >&2
          invalid=1
        fi
      done
      if [[ $invalid -eq 1 ]]; then
        echo "Available categories: ${(j:, :)available_cats}" >&2
        return 1
      fi
      WISDOM_CATEGORIES="$1" wisdom
      ;;
  esac
}

wisdom
