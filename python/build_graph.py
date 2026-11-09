"""Turn an Obsidian-style vault into graph.json for the website's concept map.

Reads every .md file under the vault, finds [[wikilinks]] and frontmatter
(type, wing, status, summary), and writes nodes + links as JSON for D3.

Run:  uv run python python/build_graph.py vault data/graph/graph.json
"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

WIKILINK = re.compile(r"\[\[([^\]|#]+)(?:#[^\]|]*)?(?:\|[^\]]*)?\]\]")


def parse_frontmatter(text: str) -> tuple[dict, str]:
    """Minimal frontmatter reader (key: value). Returns (metadata, body)."""
    if not text.startswith("---"):
        return {}, text
    _, fm, body = text.split("---", 2)
    meta = {}
    for line in fm.strip().splitlines():
        if ":" in line:
            key, val = line.split(":", 1)
            meta[key.strip()] = val.split("#")[0].strip().strip('"')
    return meta, body


def build(vault: Path) -> dict:
    files = [p for p in vault.rglob("*.md") if "_templates" not in p.parts]
    nodes, links, ids = {}, [], {p.stem for p in files}
    broken = []
    for p in files:
        meta, body = parse_frontmatter(p.read_text(encoding="utf-8"))
        nodes[p.stem] = {
            "id": p.stem,
            "type": meta.get("type", "concept"),
            "wing": meta.get("wing", ""),
            "status": meta.get("status", "seed"),
            "summary": meta.get("summary", ""),
        }
        for target in {t.strip() for t in WIKILINK.findall(body)}:
            if target in ids:
                links.append({"source": p.stem, "target": target})
            else:
                broken.append((p.stem, target))
    degree = Counter()
    for l in links:
        degree[l["source"]] += 1
        degree[l["target"]] += 1
    for n in nodes.values():
        n["degree"] = degree[n["id"]]
    orphans = [n for n, v in nodes.items() if v["degree"] == 0]
    return {"nodes": list(nodes.values()), "links": links,
            "broken": broken, "orphans": orphans}


if __name__ == "__main__":
    vault = Path(sys.argv[1] if len(sys.argv) > 1 else "vault")
    out = Path(sys.argv[2] if len(sys.argv) > 2 else "data/graph/graph.json")
    g = build(vault)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps({k: g[k] for k in ("nodes", "links")}, indent=2))
    print(f"{len(g['nodes'])} nodes, {len(g['links'])} links -> {out}")
    for src, tgt in g["broken"]:
        print(f"  broken link: [[{tgt}]] in {src} (create the note or fix the name)")
    for o in g["orphans"]:
        print(f"  orphan note (no links): {o}")
