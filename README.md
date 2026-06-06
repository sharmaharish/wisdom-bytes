# Wisdom Bytes 🧠⚙️

A knowledge base of engineering laws, mental models, cognitive biases, paradoxes, and other meta-wisdom — delivered as a daily micro-lesson every time you open a terminal.

## How It Works

Wisdom Bytes stores concepts as simple text files in a git repository. A lightweight zsh script picks one at random (avoiding recent repeats) and displays it in a formatted box whenever you open a new terminal window. You can also run `wisdom` manually anytime.

## Quick Install

```bash
git clone https://github.com/<your-username>/wisdom-bytes.git
cd wisdom-bytes
./install.sh
```

Open a new terminal — your first wisdom byte will appear!

## Categories

| Category | Emoji | Directory |
|---|---|---|
| Engineering Laws | ⚙️ | `concepts/engineering-laws/` |
| Mental Models | 🧠 | `concepts/mental-models/` |
| Cognitive Biases | 🎯 | `concepts/cognitive-biases/` |
| Paradoxes | 🔄 | `concepts/paradoxes/` |
| Design Principles | 📐 | `concepts/design-principles/` |
| Heuristics | 💡 | `concepts/heuristics/` |
| Logical Fallacies | ⚠️ | `concepts/fallacies/` |
| Economic Principles | 📊 | `concepts/economic-principles/` |
| Scientific Laws | 🔬 | `concepts/scientific-laws/` |
| Decision Frameworks | 🗺️ | `concepts/decision-frameworks/` |
| Programming Wisdom | 🖥️ | `concepts/programming-wisdom/` |

## Usage

```bash
# Manual trigger (after installing)
wisdom

# Re-run if you didn't like what you got
wisdom

# Shortcut alias (same as wisdom)
ws

# Pick from specific categories
ws engineering-laws,paradoxes

# List available categories
ws -l
ws --list

# Show usage and options
ws -h
ws --help

# If you provide an unknown category, you'll see an error
# and a list of available categories:
ws foo-bar
# → Error: unknown category 'foo-bar'
# → Available categories: engineering-laws, mental-models, ...
```

## Category Filtering

Limit to specific categories by setting `WISDOM_CATEGORIES` before the `source` line in `.zshrc`:

```bash
# Only show concepts from engineering-laws and mental-models
export WISDOM_CATEGORIES="engineering-laws,mental-models"
source /path/to/wisdom.sh
```

For a one-off filtered display in the current session:

```bash
WISDOM_CATEGORIES="paradoxes"
wisdom

# Or use the ws alias with categories inline
ws paradoxes
```

## Adding Concepts

See [CONTRIBUTING.md](CONTRIBUTING.md) for file format and guidelines.

## License

MIT
