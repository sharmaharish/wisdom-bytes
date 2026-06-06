# Requirements Clarification

This file will contain the Q&A process to refine the wisdom-bytes idea.

## Question 7: Copyright & Emojis

**Q:** How to handle source content? Should categories have emoji indicators?

**A:** Include source links. Yes, use emoji indicators per category.

## Question 6: Manual Trigger, Display, Starting Volume

**Q:** Should there be a manual trigger? Display format? How many starting concepts?

**A:** Yes, a `wisdom` command available on-demand. Display format example looks right. Start with 100+ concepts, pulling from fs.blog, lawsofengineering.com, untools.co, fallacies, paradoxes, cognitive biases, mental models, etc.

## Question 5: Repo Structure & Installation

**Q:** How should concepts be organized in the repo, and how should installation work?

**A:** No preference on directory structure. Install flow: clone repo → run install script that adds line to .zshrc → script picks random concept on terminal open.

## Question 4: Repeat Avoidance

**Q:** How should repeat avoidance work — never repeat the same concept, avoid recent repeats, or cycle through all?

**A:** Avoid recent repeats (not same one twice in a row). Pick randomly from all categories equally.

## Question 3: Shell Script Behavior

**Q:** How should the shell script trigger and display?

**A:** Every new terminal window, for zsh. Plain text in a formatted box. Tracks what was shown last and avoids repeating concepts.

## Question 2: Concept Entry Structure

**Q:** What fields should each concept entry contain?

**A:** Name, Category, Description/Definition, Example, Source/Attribution (optional), Tags.

## Question 1: Scope and Categories

**Q:** What scope for the initial knowledge base — which categories should be included first?

**A:** All categories from the start — engineering laws, mental models, cognitive biases, paradoxes, design patterns, and any other similar wisdom categories not yet listed. Also includes: heuristics, logical fallacies, economic principles, scientific laws & effects, decision-making frameworks, and programming/Unix wisdom.

