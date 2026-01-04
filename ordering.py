#!/usr/bin/env python3
from __future__ import annotations

import argparse
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple
import zipfile
from datetime import datetime

PROJECT_PKG = "notes_tasks"


@dataclass(frozen=True)
class Move:
    src: str  # relative to lib/
    dst: str  # relative to lib/


# =========================
# EDIT HERE
# =========================
MOVES: List[Move] = [
    Move(
        src="modules/auth/domain/mappers/auth_failure_mapper.dart",
        dst="core/services/auth/mappers/firebase_auth_failure_mapper.dart",
    ),
    Move(
        src="core/services/auth/providers/auth_state_provider.dart",
        dst="core/session/providers/auth_state_provider.dart",
    ),
    Move(
        src="core/services/auth/providers/email_verified_stream_provider.dart",
        dst="core/session/providers/email_verified_stream_provider.dart",
    ),
    Move(
        src="core/services/auth/providers/user_role_provider.dart",
        dst="core/session/providers/user_role_provider.dart",
    ),
]

DELETE_FILES: List[str] = [
    # put duplicates here later if needed
]
# =========================


def zip_backup(project_root: Path) -> Path:
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    out = project_root / f"backup_before_refactor_{ts}.zip"
    with zipfile.ZipFile(out, "w", compression=zipfile.ZIP_DEFLATED) as z:
        for p in [project_root / "lib", project_root / "pubspec.yaml", project_root / "pubspec.lock"]:
            if not p.exists():
                continue
            if p.is_file():
                z.write(p, p.relative_to(project_root).as_posix())
            else:
                for f in p.rglob("*"):
                    if f.is_file():
                        z.write(f, f.relative_to(project_root).as_posix())
    return out


def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)


def collect_import_rewrites(moves: List[Move]) -> Dict[str, str]:
    rewrites = {}
    for m in moves:
        old = f"package:{PROJECT_PKG}/{m.src}"
        new = f"package:{PROJECT_PKG}/{m.dst}"
        rewrites[old] = new
    return rewrites


def rewrite_imports_in_dart_files(lib_root: Path, rewrites: Dict[str, str], apply: bool) -> List[Tuple[Path, int]]:
    changed: List[Tuple[Path, int]] = []
    dart_files = list(lib_root.rglob("*.dart"))

    for f in dart_files:
        text = f.read_text(encoding="utf-8")
        new_text = text
        count = 0

        for old, new in rewrites.items():
            if old in new_text:
                count += new_text.count(old)
                new_text = new_text.replace(old, new)

        if count > 0 and new_text != text:
            if apply:
                f.write_text(new_text, encoding="utf-8")
            changed.append((f, count))

    return changed


def perform_moves(project_root: Path, moves: List[Move], apply: bool) -> List[str]:
    logs: List[str] = []
    lib_root = project_root / "lib"

    for m in moves:
        src = lib_root / m.src
        dst = lib_root / m.dst

        if not src.exists():
            logs.append(f"SKIP (missing): {m.src}")
            continue

        if dst.exists():
            logs.append(f"SKIP (dest exists): {m.dst}")
            continue

        logs.append(f"MOVE: {m.src} -> {m.dst}")
        if apply:
            ensure_parent(dst)
            shutil.move(str(src), str(dst))

    return logs


def delete_files(project_root: Path, rel_paths: List[str], apply: bool) -> List[str]:
    logs: List[str] = []
    lib_root = project_root / "lib"

    for rp in rel_paths:
        p = lib_root / rp
        if not p.exists():
            logs.append(f"DELETE SKIP (missing): {rp}")
            continue
        logs.append(f"DELETE: {rp}")
        if apply:
            p.unlink()

    return logs


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", type=str, default=".", help="Project root (where pubspec.yaml exists)")
    ap.add_argument("--apply", action="store_true", help="Actually apply changes (default: dry-run)")
    ap.add_argument("--no-backup", action="store_true", help="Skip creating a backup zip")
    args = ap.parse_args()

    project_root = Path(args.root).resolve()
    lib_root = project_root / "lib"

    if not (project_root / "pubspec.yaml").exists() or not lib_root.exists():
        print("ERROR: --root must be a Flutter project root containing pubspec.yaml and lib/")
        return 1

    apply = bool(args.apply)

    print("\n=== Refactor Move Script ===")
    print(f"Root: {project_root}")
    print(f"Mode: {'APPLY' if apply else 'DRY-RUN'}")

    if not args.no_backup:
        backup = zip_backup(project_root)
        print(f"Backup created: {backup.name}")

    print("\n--- Planned Moves ---")
    for m in MOVES:
        print(f"- {m.src}  ->  {m.dst}")

    print("\n--- Running Moves ---")
    for line in perform_moves(project_root, MOVES, apply=apply):
        print(line)

    print("\n--- Running Deletes ---")
    for line in delete_files(project_root, DELETE_FILES, apply=apply):
        print(line)

    print("\n--- Rewriting package imports ---")
    rewrites = collect_import_rewrites(MOVES)
    changed = rewrite_imports_in_dart_files(lib_root, rewrites, apply=apply)

    if not changed:
        print("No import changes.")
    else:
        for f, c in changed:
            rel = f.relative_to(project_root)
            print(f"UPDATED: {rel}  ({c} replacements)")

    print("\nDONE ✅")
    if not apply:
        print("Dry-run only. Re-run with --apply to execute changes.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
