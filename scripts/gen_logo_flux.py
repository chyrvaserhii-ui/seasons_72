#!/usr/bin/env python3
"""
Generate app-icon candidates for "72 Seasons" via Pollinations.ai.

Pollinations is a free, no-login image API wrapping Flux.1 — the same
service used for the 72 kō engravings (see generate_images.py). URL-
triggered: build a request URL, GET it, save the PNG.

Usage (from project root):
    python3 scripts/gen_logo_flux.py              # 4 styles × 2 variants = 8 PNGs
    python3 scripts/gen_logo_flux.py --only emblem --count 4
    python3 scripts/gen_logo_flux.py --size 1536  # bigger source for later upscale

Output:
    assets/brand/candidates/YYYYMMDD_HHMMSS_<style>_v<n>.png

Prompt style notes (Flux-tuned):
    - Pollinations' Flux responds well to prose, hex colors, and layout
      hints; keep each prompt one paragraph with explicit composition.
    - "no text" works better than "avoid text" — Flux is prone to
      hallucinated glyphs otherwise.
    - Seeds are randomized per run so reruns produce fresh variety.
"""

from __future__ import annotations

import argparse
import pathlib
import random
import ssl
import sys
import time
import urllib.parse
import urllib.request


# ---------------------------------------------------------------------------
# SSL context (same helper as generate_images.py)
# ---------------------------------------------------------------------------

def _build_ssl_context() -> ssl.SSLContext:
    try:
        import certifi
        return ssl.create_default_context(cafile=certifi.where())
    except ImportError:
        pass
    try:
        import subprocess
        subprocess.run(
            [sys.executable, "-m", "pip", "install", "--user",
             "--quiet", "--disable-pip-version-check", "certifi"],
            check=True, timeout=60,
        )
        import certifi  # noqa
        return ssl.create_default_context(cafile=certifi.where())
    except Exception:
        pass
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    return ctx


SSL_CTX = _build_ssl_context()

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUTPUT_DIR = ROOT / "assets" / "brand" / "candidates"


# ---------------------------------------------------------------------------
# Logo prompts — one paragraph each, Flux-friendly. Palette hex codes
# match meta-season colors used throughout the app (spring pink, summer
# sage, autumn ochre, winter blue-grey).
# ---------------------------------------------------------------------------

PROMPTS: dict[str, str] = {
    "emblem": (
        "premium iOS app icon, perfectly square 1:1, for a contemplative "
        "Japanese micro-seasons calendar app called 72 Seasons. centered "
        "circular emblem divided into four equal arc segments: soft blush "
        "pink #F4B5C1 top-left for spring with a tiny plum blossom, sage "
        "green #8FBF7F top-right for summer with a small bamboo leaf, "
        "warm ochre amber #D89060 bottom-right for autumn with a small "
        "maple leaf, pale blue-grey #8DAAC7 bottom-left for winter with a "
        "small snow crystal. in the exact center a small round traditional "
        "Japanese hanko seal in deep vermilion red featuring one stylized "
        "kanji glyph painted in confident sumi-e brush calligraphy. "
        "background: warm cream washi paper with faint visible fibers. "
        "style: ukiyo-e woodblock print tradition meets minimalist "
        "app-icon aesthetic, hand-painted, zen, generous negative space, "
        "flat traditional Japanese palette. no gradients, no glossy 3D, "
        "no drop shadow, no modern sans-serif typography, no photorealism, "
        "no text, no letters outside the central seal"
    ),
    "branch": (
        "premium iOS app icon, perfectly square 1:1, for a Japanese "
        "micro-seasons calendar app. one slender curving tree branch "
        "traversing the icon diagonally from lower-left to upper-right, "
        "showing four stages across four seasons along its length: a "
        "single soft pink plum blossom bud near the base for spring, "
        "fresh sage green leaves in the middle for summer, a mid-falling "
        "amber maple leaf past center for autumn, bare branch tip catching "
        "a single pale blue snowflake for winter. muted palette #F4B5C1 "
        "#8FBF7F #D89060 #8DAAC7 applied delicately, not dominant. "
        "background warm off-white washi paper with barely visible fibers, "
        "asymmetric composition with generous negative space in upper-left. "
        "hand-painted sumi-e ink-on-washi feel, zen editorial contemplative. "
        "no cartoon, no photorealism, no gloss, no modern typography, no "
        "text, no letters"
    ),
    "kanji": (
        "minimalist premium iOS app icon, perfectly square 1:1, for the "
        "app 72 Seasons. center composition: a single large Japanese kanji "
        "character 候 painted in one confident thick sumi-e black ink "
        "brushstroke, taking about 55 percent of the icon area, crisp and "
        "dramatic. four tiny soft-colored square pigment stamps near the "
        "four corners: blush pink #F4B5C1 upper-left, sage green #8FBF7F "
        "upper-right, warm ochre #D89060 lower-right, pale blue-grey "
        "#8DAAC7 lower-left. background: warm cream washi paper with faint "
        "fiber texture. one small round vermilion red hanko seal in a "
        "lower corner. zen aesthetic, generous negative space, hand-painted "
        "brush quality, not vector. no gradients, no 3D, no shadows, no "
        "modern typography, no letters outside the central kanji"
    ),
    "landscape": (
        "premium iOS app icon, perfectly square 1:1, in the style of a "
        "very simplified ukiyo-e woodblock print inspired by Hokusai and "
        "Hiroshige, for the Japanese micro-seasons calendar app. tiny "
        "stylized landscape: one gently rolling hill with a single slender "
        "bare tree silhouette, a large pale circle in the sky representing "
        "the moon, three small birds flying in a soft arc. limited palette "
        "of warm cream background with subtle seasonal color accents — "
        "blush pink #F4B5C1 in upper sky, sage green #8FBF7F on the hill, "
        "warm ochre #D89060 along the horizon, pale blue-grey #8DAAC7 in "
        "foreground water. visible woodblock texture and hand-carved "
        "linework. one small red hanko seal in a lower corner. no gradients, "
        "no 3D, no drop shadows, no modern typography, no text, no letters"
    ),
}


# ---------------------------------------------------------------------------
# Core
# ---------------------------------------------------------------------------

def build_url(prompt: str, seed: int, size: int = 1024) -> str:
    encoded = urllib.parse.quote(prompt, safe="")
    return (
        f"https://image.pollinations.ai/prompt/{encoded}"
        f"?width={size}&height={size}&model=flux&nologo=true&seed={seed}"
    )


def download(url: str, dest: pathlib.Path, timeout: int = 120) -> bool:
    req = urllib.request.Request(url, headers={"User-Agent": "seasons_72-logo/1.0"})
    try:
        with urllib.request.urlopen(req, timeout=timeout, context=SSL_CTX) as r:
            data = r.read()
            if len(data) < 5_000:
                return False
            dest.write_bytes(data)
            return True
    except Exception as e:
        print(f"    ! error: {type(e).__name__}: {e}")
        return False


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--only", nargs="+", choices=sorted(PROMPTS),
                        help="Only run these prompt styles (default: all)")
    parser.add_argument("--count", type=int, default=2,
                        help="Variants per style. Default: 2")
    parser.add_argument("--size", type=int, default=1024,
                        help="Image size in pixels (square). Default: 1024")
    parser.add_argument("--delay", type=float, default=2.0,
                        help="Seconds between requests. Default: 2")
    args = parser.parse_args()

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    styles = args.only or list(PROMPTS)
    stamp = time.strftime("%Y%m%d_%H%M%S")

    total = len(styles) * args.count
    print(f"→ Generating {total} logo candidates via Pollinations.ai (Flux.1)")
    print(f"  Styles: {', '.join(styles)}")
    print(f"  Output: {OUTPUT_DIR}")
    print(f"  Size:   {args.size}x{args.size}, delay between requests: {args.delay}s\n")

    random.seed()
    successes = 0
    failures: list[str] = []
    for style in styles:
        prompt = PROMPTS[style]
        for n in range(1, args.count + 1):
            seed = random.randint(1, 999_999)
            name = f"{stamp}_{style}_v{n}.png"
            dest = OUTPUT_DIR / name
            url = build_url(prompt, seed, size=args.size)
            print(f"  {style:10s} v{n}  seed={seed}", end=" ", flush=True)
            start = time.time()
            ok = download(url, dest)
            elapsed = time.time() - start
            if ok:
                kb = dest.stat().st_size / 1024
                print(f"✓ {kb:,.0f} KB ({elapsed:.1f}s)  {name}")
                successes += 1
            else:
                print(f"✗ ({elapsed:.1f}s)")
                failures.append(name)
            time.sleep(args.delay)

    print()
    print(f"✓ Done. Success: {successes}/{total}")
    if failures:
        print(f"  Failed: {failures}. Rerun the script to retry those.")
    else:
        print()
        print("Next steps:")
        print(f"  open {OUTPUT_DIR.relative_to(ROOT)}  # pick your favorite")
        print("  # then copy winner to assets/brand/app_icon.png")
        print("  # and run:  dart run flutter_launcher_icons")
    return 0 if not failures else 2


if __name__ == "__main__":
    sys.exit(main())
