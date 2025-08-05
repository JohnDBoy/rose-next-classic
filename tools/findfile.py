#!/usr/bin/env python3
import os, sys, json
from pathlib import Path

COMPONENTS = {
    'database': ['database', 'migrations'],
    'client': ['src/client'],
    'login_server': ['sho_loginserver', 'login'],
    'world_server': ['sho_worldserver', 'world'],
    'game_server': ['sho_gameserver', 'game'],
    'website': ['website', 'web']
}

def detect_component(path: Path):
    for comp, markers in COMPONENTS.items():
        for m in markers:
            if m in path.parts:
                return comp
    return 'unknown'

def scan(root):
    entries = []
    for p in root.rglob('*'):
        if p.is_file():
            comp = detect_component(p.relative_to(root))
            entries.append({'path': str(p.relative_to(root)), 'component': comp, 'name': p.name})
    return entries

def write_json(data, out):
    json.dump(data, out, indent=2)

def write_md(data, out):
    out.write('# Gemini File Index\n\n')
    out.write('Lists all files and their associated project components.\n\n')
    by_comp = {}
    for e in data:
        by_comp.setdefault(e['component'], []).append(e)
    for comp in sorted(by_comp):
        out.write(f'## {comp}\n\n')
        for e in sorted(by_comp[comp], key=lambda x: x['path']):
            out.write(f'- `{e["name"]}` — `{e["path"]}`\n')
        out.write('\n')
    meta = out

def main():
    root = Path(__file__).parent.parent if Path(__file__).parent.name in ['tools','.'] else Path('.')
    files = scan(root)
    with open('file_index.json', 'w', encoding='utf-8') as fj:
        write_json(files, fj)
    with open('gemini_file_index.md', 'w', encoding='utf-8') as fm:
        write_md(files, fm)
    if len(sys.argv) > 1:
        query = sys.argv[1]
        matches = [e for e in files if query.lower() in e['name'].lower()]
        for e in matches:
            print(f"{e['name']:30} | {e['component']:15} | {e['path']}")

if __name__ == '__main__':
    main()
