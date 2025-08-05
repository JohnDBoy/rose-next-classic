#!/usr/bin/env python3
import os, sys, json
from pathlib import Path
from fnmatch import fnmatch

# Components and their identifier folders (partial matches)
COMPONENTS = {
    'database': ['database', 'migrations'],
    'client': ['src/client'],
    'login_server': ['sho_loginserver', 'login'],
    'world_server': ['sho_worldserver', 'world'],
    'game_server': ['sho_gameserver', 'game'],
    'website': ['website', 'web']
}

# File types to exclude (assets/media)
EXCLUDED_EXTENSIONS = {'.png', '.jpg', '.jpeg', '.gif', '.bmp', '.tga', '.mp3', '.wav', '.ogg', '.mp4', '.zip', '.rar', '.7z', '.exe', '.dll'}

def load_gitignore(root):
    gitignore_path = root / ".gitignore"
    patterns = []
    if gitignore_path.exists():
        with gitignore_path.open() as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#'):
                    patterns.append(line)
    return patterns

def is_ignored(path, patterns):
    for pattern in patterns:
        if fnmatch(str(path), pattern) or fnmatch(path.name, pattern):
            return True
    return False

def detect_component(path: Path):
    for comp, markers in COMPONENTS.items():
        for m in markers:
            if m in path.parts:
                return comp
    return 'unknown'

def scan(root, ignore_patterns):
    entries = []
    for p in root.rglob('*'):
        if p.is_file():
            if p.suffix.lower() in EXCLUDED_EXTENSIONS:
                continue
            rel_path = p.relative_to(root)
            if is_ignored(rel_path, ignore_patterns):
                continue
            comp = detect_component(rel_path)
            entries.append({'path': str(rel_path), 'component': comp, 'name': p.name})
    return entries

def write_json(data, out_file):
    json.dump(data, out_file, indent=2)

def write_md(data, out_file):
    out_file.write('# Gemini File Index\n\n')
    out_file.write('Lists all files and their associated project components.\n\n')
    by_comp = {}
    for e in data:
        by_comp.setdefault(e['component'], []).append(e)
    for comp in sorted(by_comp):
        out_file.write(f'## {comp}\n\n')
        for e in sorted(by_comp[comp], key=lambda x: x['path']):
            out_file.write(f'- `{e["name"]}` — `{e["path"]}`\n')
        out_file.write('\n')

def confirm_overwrite(file_path):
    if file_path.exists():
        response = input(f"File {file_path.name} exists. Overwrite? (y/n): ").strip().lower()
        if response != 'y':
            print(f"Skipped writing {file_path.name}")
            return False
    return True

def main():
    root = Path(__file__).parent.parent if Path(__file__).parent.name in ['tools','.'] else Path('.')
    ignore_patterns = load_gitignore(root)
    files = scan(root, ignore_patterns)

    json_path = root / 'file_index.json'
    md_path = root / 'gemini_file_index.md'

    if confirm_overwrite(json_path):
        with json_path.open('w', encoding='utf-8') as fj:
            write_json(files, fj)
        print(f"Wrote {json_path.name}")

    if confirm_overwrite(md_path):
        with md_path.open('w', encoding='utf-8') as fm:
            write_md(files, fm)
        print(f"Wrote {md_path.name}")

    if len(sys.argv) > 1:
        query = sys.argv[1]
        matches = [e for e in files if query.lower() in e['name'].lower()]
        for e in matches:
            print(f"{e['name']:30} | {e['component']:15} | {e['path']}")

if __name__ == '__main__':
    main()
