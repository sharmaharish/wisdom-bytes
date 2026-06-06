# Wisdom Bytes — Implementation Plan

## Checklist
- [ ] Step 1: Initialize repository structure and README
- [ ] Step 2: Create wisdom.sh with concept parsing and random selection
- [ ] Step 3: Implement display_box with formatted terminal output
- [ ] Step 4: Add history tracking and repeat avoidance
- [ ] Step 5: Create manual `wisdom` function and auto-display on source
- [ ] Step 6: Create install.sh with idempotent .zshrc integration
- [ ] Step 7: Seed first batch of concept files (categories A-I)
- [ ] Step 8: Seed remaining concept files (categories J-Z)
- [ ] Step 9: Final wiring, testing, and documentation

---

## Step 1: Initialize repository structure and README

**Objective**: Create the initial git repository with directory scaffolding and a README that explains the project.

**Guidance**:
- Create the root repository directory
- Set up the directory structure as defined in the design: `concepts/<category>/` for each of the 11 categories
- Create a `.gitignore` (ignore `*.swp`, `.DS_Store`)
- Write a `README.md` explaining what wisdom-bytes is, how to install it, how to contribute concepts, and category index with emojis
- Include a `CONTRIBUTING.md` with guidelines for adding new concepts
- Initialize git and make the first commit

**Test requirements**:
- Verify all 11 category directories exist under `concepts/`
- Verify README renders correctly (basic markdown check)
- Verify `.gitignore` ignores `.DS_Store`

**Demo**: `ls concepts/` shows all 11 category folders. `cat README.md` shows project description.

---

## Step 2: Create wisdom.sh with concept parsing and random selection

**Objective**: Write the core wisdom.sh script that can discover concept files and parse their content into structured fields.

**Guidance**:
- Determine the script's own directory at runtime (to find `concepts/` relative to itself)
- Implement `list_concepts()` — uses `find` to locate all `*.txt` files in the `concepts/` tree, shuffle them
- Implement `parse_concept(file)` — parse a concept file into fields (Name, Category, Description, Example, Source, Tags). Handle missing optional fields gracefully
- Implement the `WISDOM_HOME` detection logic (relative to script location)
- Add basic error handling: if no concept directory or files exist, print a helpful message

**Test requirements**:
- Place a test concept file, source wisdom.sh, and verify `list_concepts` finds it
- Verify `parse_concept` correctly extracts all fields from a well-formed file
- Verify `parse_concept` handles missing optional fields (e.g., no Source)

**Demo**: `source wisdom.sh && list_concepts` lists concept files. `parse_concept "concepts/engineering-laws/test.txt"` outputs structured fields.

---

## Step 3: Implement display_box with formatted terminal output

**Objective**: Create the terminal box rendering function that displays a concept in the formatted box with emoji.

**Guidance**:
- Implement `get_emoji(category)` that maps category names to emoji characters
- Implement `display_box(concept)` that:
  - Takes a parsed concept (associative array or variables)
  - Draws a box using Unicode box-drawing characters (┌─┐└┘│)
  - Shows the emoji + Name at top
  - Shows a separator line
  - Shows Description (handle multi-line, wrap to fit width)
  - Shows "Example:" prefix and example text
  - Shows Source if available
- Default to 72-character width, detect terminal width with `$COLUMNS` if available
- Ensure no external dependencies (no figlet, no lolcat)

**Test requirements**:
- Source wisdom.sh, call `display_box` with a sample concept, verify output contains all fields
- Verify box characters render (visual check or grep for ┌)
- Verify emoji appears correctly for each category

**Demo**: `source wisdom.sh && display_box $(parse_concept "concepts/engineering-laws/test.txt")` shows a formatted box in terminal.

---

## Step 4: Add history tracking and repeat avoidance

**Objective**: Implement the history file mechanism to avoid showing the same concept twice in a row.

**Guidance**:
- Define `WISDOM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/wisdom-bytes"` (or `~/.wisdom-bytes` for simplicity)
- Implement `read_history()` — reads `$WISDOM_DATA_DIR/history`, returns list of recent filenames
- Implement `write_history(name)` — appends concept filename to history file, trims to `HISTORY_SIZE` (default 20)
- Implement `pick_random(all, exclude)` — given a list of all concepts and an exclusion list, pick one at random. If the resulting pool is empty (all concepts recently shown), clear history and pick from full pool
- Modify the main flow: `list_concepts` → `read_history` → `pick_random` → `write_history` → `display_box`

**Test requirements**:
- Test that calling pick_random multiple times does not return an excluded item
- Test that history file is created on first run
- Test that history file does not grow beyond HISTORY_SIZE
- Test that when all concepts are in history, the pool resets

**Demo**: Run the script twice in a row — verify different concepts shown. Check `~/.wisdom-bytes/history` file contains the previously shown entries.

---

## Step 5: Create manual `wisdom` function and auto-display on source

**Objective**: Wire together the full flow and add the manual `wisdom` command plus auto-display on shell start.

**Guidance**:
- Define a `wisdom()` function that runs the full flow (list → filter → pick → display → record)
- At the bottom of wisdom.sh, call `wisdom` so it auto-runs when sourced from `.zshrc`
- Ensure `wisdom` is idempotent and safe to call multiple times
- The auto-display at end-of-script should be the ONLY auto-invocation (avoid double-display)
- Document the `wisdom` command at the top of the script

**Test requirements**:
- Source wisdom.sh and verify the wisdom box appears (auto-display on source)
- Run `wisdom` manually in the same session — verify it shows a different concept (or a new random one)
- Source wisdom.sh twice in a row — verify it doesn't cause double-display issues

**Demo**: `source wisdom.sh` shows a concept. Typing `wisdom` shows another concept.

---

## Step 6: Create install.sh with idempotent .zshrc integration

**Objective**: Write the installation script that sets up wisdom-bytes for the user.

**Guidance**:
- Detect the absolute path of the repository (script's own directory)
- Create `~/.wisdom-bytes/` directory (create if not exists)
- Create empty `~/.wisdom-bytes/history` if not exists
- Read `.zshrc`, check if the sourcing line already exists (check for `source <path>/wisdom.sh`)
- If not present, append: `source <abs-path>/wisdom.sh`
- Print success message: "Wisdom Bytes installed! Open a new terminal to see your first wisdom byte."
- Make script safe to re-run (idempotent — won't duplicate)

**Test requirements**:
- Run install.sh in a test environment with a temp .zshrc
- Verify sourcing line is appended
- Run install.sh again — verify no duplicate line
- Verify `~/.wisdom-bytes/` and `history` file are created

**Demo**: Run `./install.sh`. Check `.zshrc` has the sourcing line. Run install.sh again — verify no duplicate. Source the .zshrc line manually to verify it works.

---

## Step 7: Seed first batch of concept files (categories A-I)

**Objective**: Create the initial set of concept files covering engineering-laws, mental-models, cognitive-biases, design-principles, and decision-frameworks.

**Guidance**:
- Create at minimum 10-12 well-written concept files per category
- Each file following the defined text format
- Write original descriptions and examples (not direct copies)
- Include source attribution
- Engineering laws: Murphy's, Conway's, Parkinson's, Brooks', Gall's, Hofstadter's, Goodhart's, Hanlon's Razor, Occam's Razor, Postel's Law, The Peter Principle, Dunbar's Number
- Mental models: First Principles, Inversion, Map vs Territory, Circle of Competence, OODA Loop, Second-Order Thinking, Probabilistic Thinking, Inertia, Entropy, Red Queen Effect, etc.
- Cognitive biases: Confirmation Bias, Dunning-Kruger, Anchoring, Availability Heuristic, Hindsight Bias, Sunk Cost Fallacy, Survivorship Bias, Halo Effect, etc.
- Design principles: DRY, KISS, YAGNI, SOLID (each as separate files), Law of Demeter, Least Astonishment, etc.
- Decision frameworks: Eisenhower Matrix, Cynefin Framework, Pareto Principle, etc.

**Test requirements**:
- Verify each file is parseable by `parse_concept`
- Verify each category has correct emoji mapping
- Verify "wisdom" command picks from this set

**Demo**: `wisdom` displays concepts from multiple categories. `ls concepts/*/` shows populated directories.

---

## Step 8: Seed remaining concept files (categories J-Z)

**Objective**: Complete the concept library with remaining categories.

**Guidance**:
- Heuristics: Availability Heuristic, Affect Heuristic, Representativeness Heuristic, etc.
- Fallacies: Straw Man, False Dilemma, Slippery Slope, Appeal to Authority, Ad Hominem, etc.
- Economic principles: Supply & Demand, Comparative Advantage, Opportunity Cost, etc.
- Scientific laws: Moore's Law, Metcalfe's Law, Amdahl's Law, Entropy, etc.
- Paradoxes: Jevons' Paradox, Abilene Paradox, Paradox of Choice, etc.
- Programming wisdom: Unix Philosophy, The Zen of Python, "Naming things is hard", etc.
- Ensure total reaches 100+ concepts across all categories

**Test requirements**:
- Verify all 100+ concept files parse correctly
- Run `wisdom` 10 times — verify no crashes, good variety across categories
- Verify no duplicate filenames

**Demo**: `wisdom` displayed several times shows concepts from all 11 categories. Total concept count is 100+.

---

## Step 9: Final wiring, testing, and documentation

**Objective**: End-to-end testing, polish, and finalize documentation.

**Guidance**:
- Run install from scratch in a temp directory, verify full flow works
- Test edge cases: empty history, single concept, concepts with missing fields
- Ensure `.gitignore` excludes user-specific files (like `~/.wisdom-bytes/`)
- Tag the initial release (v0.1.0)
- Finalize README with complete category listing and contribution guide

**Test requirements**:
- Full end-to-end: clone → install → new terminal → wisdom displayed → `wisdom` command works → history tracked
- All edge cases handled gracefully
- README renders complete

**Demo**: Fresh clone + `./install.sh` + `source ~/.zshrc` shows first wisdom byte. `wisdom` shows another. `cat ~/.wisdom-bytes/history` shows tracked concepts.
