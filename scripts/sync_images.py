#!/usr/bin/env python3
"""
Auto-sync illustrations: scans assets/images/ko/ for files named
{index}.{png,webp,jpg,jpeg} and updates assets/data/seasons.json
so each kō with a matching file gets an "illustration" field.

Removes the field if the file is no longer on disk.

Usage (from project root):
    python3 scripts/sync_images.py

Then do a full flutter rebuild (not hot restart) to bundle the new assets:
    # in the terminal running flutter, press 'q' to stop, then:
    flutter run
"""

import json
import pathlib
import sys


def main() -> int:
    root = pathlib.Path(__file__).resolve().parent.parent
    seasons_path = root / "assets" / "data" / "seasons.json"
    images_dir = root / "assets" / "images" / "ko"

    if not seasons_path.exists():
        print(f"✗ {seasons_path} not found. Run from project root.")
        return 1

    with open(seasons_path, encoding="utf-8") as f:
        data = json.load(f)

    added, removed, total_bytes = [], [], 0
    for k in data["ko"]:
        idx = k["index"]
        found_path = None
        for ext in ("png", "webp", "jpg", "jpeg"):
            p = images_dir / f"{idx}.{ext}"
            if p.exists():
                # Use forward-slash relative path for pubspec compatibility.
                found_path = f"assets/images/ko/{idx}.{ext}"
                total_bytes += p.stat().st_size
                break

        if found_path:
            if k.get("illustration") != found_path:
                k["illustration"] = found_path
                added.append((idx, found_path, k["uk"]))
        elif "illustration" in k:
            del k["illustration"]
            removed.append((idx, k["uk"]))

    with open(seasons_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    illustrated = sum(1 for k in data["ko"] if k.get("illustration"))
    print(f"✓ {illustrated}/72 seasons have illustrations")
    if added:
        print(f"\nNewly linked ({len(added)}):")
        for idx, p, name in added:
            print(f"  #{idx:2d}  {p}  —  {name}")
    if removed:
        print(f"\nUnlinked ({len(removed)}):")
        for idx, name in removed:
            print(f"  #{idx:2d}  —  {name}")

    mb = total_bytes / 1024 / 1024
    if mb > 0:
        avg_kb = total_bytes / len(added + [k for k in data["ko"] if k.get("illustration")]) / 1024 if illustrated else 0
        print(f"\nTotal illustration payload: {mb:.1f} MB across {illustrated} files")
        if mb > 50:
            print(f"  ⚠  Consider compressing before shipping (see scripts/compress_images.py once ready)")

    return 0


if __name__ == "__main__":
    sys.exit(main())
