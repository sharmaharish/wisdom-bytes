# Wisdom.sh Latency Analysis

## Current Runtime
**~500ms** per invocation (macOS). ~240 external subprocesses spawned.

## External Command Breakdown

| Command | Calls | % of Total | Source |
|---------|-------|------------|--------|
| `basename` | 226 | 94% | `$(basename "$f")` in dedup loops, history processing |
| `find` | 1 | <1% | `find "$dir" -name '*.txt'` in `list_concepts()` |
| `sed` | 5 | 2% | `echo ... \| sed` field extraction in `display_box()` |
| `seq` | 4 | 2% | `$(seq 1 $((width - 2)))` in border drawing |
| `sort` | 1 | <1% | Pipe from `find` in `list_concepts()` |
| `cat` | 1 | <1% | `read_history()` |
| `wc` | 1 | <1% | Line count in `write_history()` |
| `tail`/`mv`/`mkdir` | 1 each | <1% | History rotation |

## Optimization Recommendations

### 1. Replace `basename` with zsh built-in `$var:t` (eliminates 226 subprocesses — 94%)

Every `$(basename "$f")` forks a subprocess. Zsh's `$var:t` and `$var:h:t`
modifiers do the same natively:

```zsh
# Before
cb="$(basename "$c")"
dir="$(basename "$(dirname "$f")")"
write_history "$(basename "$chosen")"

# After
cb="$c:t"
dir="$f:h:t"
write_history "$chosen:t"
```

### 2. Replace `seq` with zsh `l:fill` parameter flag (eliminates 4 subprocesses)

```zsh
# Before
echo "┌$(printf '─%.0s' $(seq 1 $((width - 2))))┐"

# After
echo "┌${(l:$((width - 2))::─:)}┐"
```

### 3. Replace `echo | sed` with zsh parameter expansion (eliminates 5 subprocesses)

```zsh
# Before
name="$(echo "$parsed" | sed -n 's/^name: //p')"

# After
name="${${(M)${(f)parsed}:#name: *}#name: }"
```

### 4. Replace `find | sort` with zsh recursive glob + native sort (~2 subprocesses)

```zsh
# Before
find "$dir" -name '*.txt' -type f 2>/dev/null | sort

# After
local -a files=("$dir"/**/*.txt(.N))
print -l "${(o)files}"
```

### 5. Replace per-file `grep -qE` with zsh pattern matching (eliminates N subprocesses)

When `WISDOM_CATEGORIES` filtering is active, each file currently runs
`echo | grep -qE`. Use zsh's `[[ $var == *pattern* ]]` instead.

### 6. Eliminate `wc -l` subprocess with zsh array length

```zsh
# Before
lines="$(wc -l < "$histfile")"

# After
local -a hist_lines=("${(@f)"$(<$histfile)"}")
lines=${#hist_lines[@]}
```

## Estimated Impact

| Optimization | Subprocesses Saved | Est. Time Saved |
|---|---|---|
| `basename` → `$var:t` | 226 | ~350-400ms |
| `seq` → `l:fill` | 4 | ~10ms |
| `sed` → zsh expansion | 5 | ~15ms |
| `find` → zsh glob | 2 | ~5ms |
| `grep` → zsh pattern | variable | ~10ms+ |
| **Total** | **~240** | **~400-450ms** |

Target runtime after optimization: **~30-80ms**
