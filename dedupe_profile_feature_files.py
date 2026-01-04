#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Deduplicate profile files:
Deletes duplicate files inside lib/modules/profile/** when an identical file exists
inside one of:
- lib/modules/profile_projects/**
- lib/modules/profile_skills/**
- lib/modules/profile_experience/**

Safety:
- Creates a backup zip before deleting.
- Only deletes if: same filename AND same content hash.
- Supports --dry-run to preview.
"""

from __future__ import annotations

import argparse
import hashlib
import os
import sys
import time
import zipfile
from pathlib import Path
from typing import Dict, List, Tuple


FEATURE_MODULES = [
    "profile_projects",
    "profile_skills",
    "profile_experience",
]

PROFILE_MODULE = "profile"


def sha256_of_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def collect_files(base: Path) -> List[Path]:
    if not base.exists():
        return []
    return [p for p in base.rglob("*.dart") if p.is_file()]


def build_feature_index(lib_modules: Path) -> Dict[str, List[Tuple[Path, str]]]:
    """
    Index feature files by filename -> list of (path, hash)
    """
    index: Dict[str, List[Tuple[Path, str]]] = {}
    for mod in FEATURE_MODULES:
        root = lib_modules / mod
        for f in collect_files(root):
            name = f.name
            digest = sha256_of_file(f)
            index.setdefault(name, []).append((f, digest))
    return index


def zip_backup(project_root: Path, target_root: Path) -> Path:
    """
    Create a zip backup of target_root (lib/modules/profile) before deletion.
    """
    ts = time.strftime("%Y%m%d_%H%M%S")
    backup_path = project_root / f"backup_profile_before_dedupe_{ts}.zip"
    with zipfile.ZipFile(backup_path, "w", compression=zipfile.ZIP_DEFLATED) as z:
        for file in target_root.rglob("*"):
            if file.is_file():
                rel = file.relative_to(project_root)
                z.write(file, rel.as_posix())
    return backup_path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--root",
        type=str,
        default=".",
        help="Project root (where pubspec.yaml exists). Default: current directory",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview what would be deleted without deleting anything",
    )
    parser.add_argument(
        "--no-backup",
        action="store_true",
        help="Skip creating backup zip (NOT recommended)",
    )
    args = parser.parse_args()

    project_root = Path(args.root).resolve()
    pubspec = project_root / "pubspec.yaml"
    lib_modules = project_root / "lib" / "modules"
    profile_root = lib_modules / PROFILE_MODULE

    print(f"📁 Project root: {project_root}")
    print(f"🔎 pubspec.yaml exists: {pubspec.exists()}")
    print(f"🔎 lib/modules exists: {lib_modules.exists()}")
    if not pubspec.exists() or not lib_modules.exists():
        print("❌ This doesn't look like a Flutter project root.")
        return 2

    if not profile_root.exists():
        print(f"⚠️ No profile module found at: {profile_root}")
        return 0

    # Build feature index
    print("\n🔎 Scanning feature modules for duplicates...")
    feature_index = build_feature_index(lib_modules)

    # Scan profile files
    profile_files = collect_files(profile_root)
    print(f"📦 Found {len(profile_files)} .dart files under {profile_root}")

    # Decide deletions
    to_delete: List[Tuple[Path, Path]] = []  # (profile_file, matched_feature_file)
    kept: List[Path] = []
    skipped_no_match: List[Path] = []
    skipped_name_match_but_diff: List[Path] = []

    for pf in profile_files:
        candidates = feature_index.get(pf.name, [])
        if not candidates:
            skipped_no_match.append(pf)
            continue

        pf_hash = sha256_of_file(pf)
        match = None
        for cand_path, cand_hash in candidates:
            if cand_hash == pf_hash:
                match = cand_path
                break

        if match is None:
            skipped_name_match_but_diff.append(pf)
        else:
            to_delete.append((pf, match))

    print("\n==============================")
    print(f"✅ Duplicate candidates (safe to delete): {len(to_delete)}")
    print(f"↩️ No filename match in features: {len(skipped_no_match)}")
    print(f"⚠️ Filename match but different content: {len(skipped_name_match_but_diff)}")
    print("==============================\n")

    # Show a concise plan
    if to_delete:
        print("🗑️ Planned deletions (profile -> kept in feature):")
        for pf, mf in to_delete:
            rel_pf = pf.relative_to(project_root)
            rel_mf = mf.relative_to(project_root)
            print(f" - {rel_pf}  (kept: {rel_mf})")
        print()

    if args.dry_run:
        print("🧪 DRY RUN: No files were deleted.")
        return 0

    # Backup
    if not args.no_backup:
        print("📦 Creating backup zip before deletion...")
        backup = zip_backup(project_root, profile_root)
        print(f"✅ Backup created: {backup.name}")
    else:
        print("⚠️ Backup skipped (--no-backup).")

    # Delete files
    deleted = 0
    for pf, _ in to_delete:
        try:
            pf.unlink()
            deleted += 1
        except Exception as e:
            print(f"❌ Failed to delete {pf}: {e}")

    # Remove empty dirs
    removed_dirs = 0
    # walk bottom-up
    for d in sorted(profile_root.rglob("*"), reverse=True):
        if d.is_dir():
            try:
                if not any(d.iterdir()):
                    d.rmdir()
                    removed_dirs += 1
            except Exception:
                pass

    print("\n==============================")
    print(f"✅ Deleted files: {deleted}")
    print(f"🧹 Removed empty dirs: {removed_dirs}")
    print("✅ Done.")
    print("==============================")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
