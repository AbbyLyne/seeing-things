# The Map Room: Concept Graph (Obsidian-style)

## Why
Some ideas can't be explained in one exhibit. Confounding leads to Simpson's paradox, which leads to
regression adjustment. The **Map Room** shows how concepts, techniques, biases and exhibits connect,
so visitors can wander by curiosity instead of by menu.

## How it works
```
Obsidian vault (vault/*.md, [[wikilinks]])
        │  python/build_graph.py
        ▼
data/graph/graph.json  (nodes + links)
        │
        ▼
D3 force graph embedded in the Quarto site (Observable JS)
```
- Notes are **written** in Obsidian (open the `vault/` folder as a vault). Its local graph view is the authoring tool.
- The script **reads the same files**, so the public map never drifts from the notes.
- The site **renders** its own graph, so it can be styled to match the museum.

## Note types and graph colours
| `type` | Meaning | Suggested colour |
|---|---|---|
| concept | An idea (confounding, sampling) | Accent 2 teal |
| technique | A method (chi-square, regression) | Accent 1 orange |
| bias | A cognitive trap | Accent 5 violet |
| exhibit | A published story | Accent 3 yellow |
| study | A cited research paper | Accent 4 green |

Node size = number of links (`degree`). Optional later: colour rings by `wing`, fade `status: seed` notes.
Bias notes don't belong to a wing: they get `wing: ""` and `type: bias` (the Brain Atlas is a feature, not a wing).

## Linking conventions (so the graph stays meaningful)
Use consistent section headings; they become link *types* later:
- `## Builds on` prerequisite concepts
- `## Leads to` where to go next
- `## Seen in exhibits` exhibits that demonstrate it
- `## Trap` / `## Seen in` biases involved

Keep file names lowercase-hyphenated (`simpsons-paradox.md`) and make each note's `summary` one plain sentence,
since it appears on hover.

## Publishing options
| Option | Effort | Notes |
|---|---|---|
| **Custom D3 graph from `graph.json`** (chosen) | Medium | Integrates with the Quarto site, fully brandable |
| Quartz | Low | Free, open source, turns a vault into a site with graph view, backlinks and search; but it's a separate site from the Quarto exhibits |
| Obsidian Publish | Lowest | Official paid hosting; graph is site-wide |

## Build steps
1. Open `vault/` in Obsidian; add notes using `vault/_templates/concept.md`.
2. Run `uv run python python/build_graph.py vault data/graph/graph.json`. It reports **broken links** and **orphans**.
3. Fix those, commit.
4. Later: an OJS cell loads `graph.json` into a D3 force layout; click a node to open its exhibit.

## Rule for exhibits
Every exhibit gets a vault note, and its concepts, technique and bias must exist as notes it links to.
Publishing an exhibit means growing the map.
