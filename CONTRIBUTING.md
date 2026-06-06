# Contributing

## Adding a New Concept

1. Choose the right category directory under `concepts/`
2. Create a file named `<kebab-case-name>.txt`
3. Follow this format:

```
Name: Concept Name
Category: category-name
Tags: tag1, tag2, tag3

Description paragraph here...

Example: Concrete example illustrating the concept.

Source: https://relevant-url.com
```

### Rules
- **Name** must be on the first line
- **Category** must be on the second line (use kebab-case, matching a directory name)
- **Tags** is optional, comma-separated
- Leave a blank line after the header
- Description comes next (can be multi-line)
- `Example:` marker starts the example section
- `Source:` marker is optional, usually a URL
- Filename must be kebab-case (e.g., `parkinsons-law.txt`)
- Write original descriptions — don't copy verbatim from sources (include source URL for attribution)

## Adding a New Category

1. Create a new directory under `concepts/`
2. Add the emoji mapping to `wisdom.sh` in the `get_emoji()` function
3. Add the category to README.md
