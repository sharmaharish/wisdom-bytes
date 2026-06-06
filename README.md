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

## Sources

The concept collection draws from these sources (among others):

| Source | Scope |
|---|---|
| [pragprog.com](https://pragprog.com/titles/tpp20/the-pragmatic-programmer-20th-anniversary-edition/) — *The Pragmatic Programmer* | Programming wisdom & engineering practices |
| [fs.blog](https://fs.blog/mental-models/) — Farnam Street | Mental models |
| [lawsofsoftwareengineering.com](https://lawsofsoftwareengineering.com/) | Engineering laws |
| [hacker-laws.com](https://hacker-laws.com/) | Engineering laws & principles |
| [untools.co](https://untools.co/) | Thinking tools & frameworks |
| [Wikipedia — List of Cognitive Biases](https://en.wikipedia.org/wiki/List_of_cognitive_biases) | Cognitive biases |
| [Wikipedia — List of Fallacies](https://en.wikipedia.org/wiki/List_of_fallacies) | Logical fallacies |
| [Wikipedia — List of Paradoxes](https://en.wikipedia.org/wiki/List_of_Paradoxes) | Paradoxes |
| [threwthelookingglass.com](https://threwthelookingglass.com/cognitive-biases/) | Cognitive biases |

### Backlog / Pending

These sources are identified but not yet incorporated:

| Source | Scope |
|---|---|
| [leadership.garden](https://leadership.garden/56-laws-of-software-engineering/) — 56 Laws of Software Engineering | Engineering laws |
| [sesamedisk.com](https://sesamedisk.com/software-engineering-laws-2026/) — Software Engineering Laws 2026 | Engineering laws |
| [github.com/kanywst/hacker-heuristics](https://github.com/kanywst/hacker-heuristics) | Mental models for engineering |
| [github.com/dvdarkin/reasoning-tools](https://github.com/dvdarkin/reasoning-tools) | Reasoning primitives (32 domains) |
| [github.com/mattnowdev/thinking-partner](https://github.com/mattnowdev/thinking-partner) | Mental models catalog (150+) |
| [github.com/jacksonshapiro11/mental-models-observatory](https://github.com/jacksonshapiro11/mental-models-observatory) | Mental models (119 across 40 domains) |
| [github.com/justinhartbiz/model-thinker-toolkit](https://github.com/justinhartbiz/model-thinker-toolkit) | Decision-making models (50) |
| [github.com/henu-wang/awesome-mental-models](https://github.com/henu-wang/awesome-mental-models) | Curated mental models list |
| [github.com/henu-wang/mental-models-handbook](https://github.com/henu-wang/mental-models-handbook) | Mental models (25+, multidisciplinary) |
| [github.com/jarmolkowicz/modern-mind-knowledge-base](https://github.com/jarmolkowicz/modern-mind-knowledge-base) | AI-era concepts (55) |
| [github.com/metaphorex/metaphorex](https://github.com/metaphorex/metaphorex) | Cross-domain conceptual metaphors |

## License

MIT
