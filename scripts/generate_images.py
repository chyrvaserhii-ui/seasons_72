#!/usr/bin/env python3
"""
Batch-generate missing kō illustrations via Pollinations.ai.

Pollinations is a free, no-login image API that wraps Flux.1 and other
open models. URL-triggered — just GET the image URL and save the PNG.

Usage (from project root):
    python3 scripts/generate_images.py                 # generate all missing
    python3 scripts/generate_images.py --force         # regenerate even existing
    python3 scripts/generate_images.py --only 30 31 32 # generate only these

Then sync JSON + restart flutter:
    python3 scripts/sync_images.py
    # in flutter run terminal: Q → flutter run

Quality note: Pollinations uses Flux.1 (schnell or dev variants). Quality
is solid but style can differ slightly from DALL-E 3 (the first 29 images
were DALL-E 3 via Microsoft Designer). If consistency is critical, use
Ideogram (10/day) or wait for Designer credits to refresh.
"""

from __future__ import annotations

import argparse
import json
import pathlib
import random
import ssl
import sys
import time
import urllib.parse
import urllib.request


def _build_ssl_context() -> ssl.SSLContext:
    """
    Build an SSL context that works on any Python install. macOS system
    Python often ships without a fresh CA bundle — we auto-install certifi
    via pip if missing; if that fails, we fall back to an unverified
    context (safe here: only downloading public images, no sensitive data).
    """
    # Try certifi.
    try:
        import certifi
        return ssl.create_default_context(cafile=certifi.where())
    except ImportError:
        pass

    # Not installed — attempt to install it quietly via pip.
    print("→ Installing certifi (one-time, needed for SSL)...")
    try:
        import subprocess
        subprocess.run(
            [sys.executable, "-m", "pip", "install", "--user",
             "--quiet", "--disable-pip-version-check", "certifi"],
            check=True, timeout=60,
        )
        import certifi  # noqa
        return ssl.create_default_context(cafile=certifi.where())
    except Exception as e:
        print(f"  (certifi install failed: {e})")

    # Last resort — unverified. We're downloading public PNG files from
    # pollinations.ai, no credentials or sensitive data flow through.
    print("  ! SSL verification disabled — install certificates permanently with:")
    print("  !   open '/Applications/Python 3.11/Install Certificates.command'")
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    return ctx


SSL_CTX = _build_ssl_context()

ROOT = pathlib.Path(__file__).resolve().parent.parent
SEASONS_JSON = ROOT / "assets" / "data" / "seasons.json"
IMAGES_DIR = ROOT / "assets" / "images" / "ko"

# Scene descriptions for each kō — same set used in PROMPTS.md
SCENES = {
    1: "spring east wind melting ice on a mountain river, willow branches bending, dawn light, early thaw",
    2: "a bush warbler uguisu bird singing on a plum branch, mountain mist, first sign of spring",
    3: "Japanese koi fish leaping out of cracked river ice through a hole, early spring thaw, traditional ink painting style, pine trees on riverbank",
    4: "steady late February rain falling on dark wet bare brown earth and stone-edged paddy embankments, no rice plants yet, no green crop, vertical slanted rain lines, single bare leafless plum branch with small white buds in upper foreground, distant grey-purple mountains under low overcast sky, quiet early-spring thaw, ukiyo-e woodblock",
    5: "thick morning mist drifting over terraced rice paddies, soft diffused light",
    6: "tender green shoots pushing through earth beside dried grass",
    7: "small insects emerging from cracks in warming earth, close-up ground level",
    8: "peach tree in full pink blossom, petals drifting in light breeze",
    9: "a butterfly just emerged from its chrysalis, wings unfolding, dewdrops",
    10: "sparrows gathering twigs for a nest under the wooden eave of an old house",
    11: "cherry tree in full sakura bloom by a river, petals floating on water",
    12: "distant thunderhead rumbling over rice paddies, lightning flash",
    13: "swallows flying toward traditional wooden Japanese house, returning migration",
    14: "V-formation of wild geese flying north over a valley at golden sunset",
    15: "vivid rainbow arching over a village after spring rain, rice paddies below",
    16: "tender green reeds sprouting from pond water, dragonflies appearing",
    17: "tiny pale-green rice seedlings only 3 to 5 cm tall barely poking above the still mirror-flat water surface of a flooded April rice paddy, brown bare earth embankments, hazy distant blue mountains under cool spring sky, sparse pink wild cherry branches in middle distance, last frost shadow on the dyke, NO summer green foliage, NO mature trees in full leaf, ukiyo-e woodblock",
    18: "lush red and pink peony blossoms in a traditional Japanese garden",
    19: "a single small green frog sitting on a wet stone at the edge of shallow reeds and irises by a pond, mouth open in mid-call, ripples spreading on still water, early summer twilight, NO lotus leaves, NO lotus blossoms, NO open pink flowers, just stones and reeds, ukiyo-e woodblock",
    20: "earthworms surfacing on damp soil after rain, close-up ground view",
    21: "three or four stout pointed young bamboo shoots takenoko breaking through dark soil and brown leaf litter in clear foreground focus, brown protective sheaths still wrapping their tips, dappled May sunlight on the ground, mature green bamboo culms softly receding into misty background, focus on the EMERGING new shoots not the established grove, ukiyo-e woodblock",
    22: "silkworms feeding on green mulberry leaves, close-up of delicate creatures",
    23: "fields of orange-red safflower blooms stretching to horizon",
    24: "traditional Japanese peasant farmers with straw hats harvesting golden wheat using sickles, stacked bundles of wheat, early summer countryside, ukiyo-e painting",
    25: "newly hatched praying mantis on a dewy green leaf",
    26: "fireflies glowing in dark forest at night, stream reflecting light",
    27: "yellowing ume plums hanging heavy on branches, ready for harvest",
    28: "withered purple prunella flowers drying in a summer meadow, faded petals",
    29: "purple irises blooming along a pond with arched wooden bridge",
    30: "pinellia herb plant with glossy green spade-shaped leaves sprouting from dark earth, mid-summer garden",
    33: "young Japanese mountain hawk spreading wings for flight on a rocky cliff, soaring above pine forest, summer sky",
    34: "close-up of paulownia kiri tree branches against soft summer sky, very large heart-shaped green leaves, clusters of small round green-and-brown WALNUT-SIZED SEED CAPSULES hanging from the branch tips, late July seed-forming stage AFTER the lavender flowers have dropped, NO purple flowers, NO red blossoms, NO open clusters of pink, just leaves and seed pods, ukiyo-e woodblock",
    35: "heavy white-grey humid haze hanging low over still-growing GREEN rice paddies in late July, dripping wet glossy foliage, condensation droplets on leaves, water reflections heavy with mist, faint sun barely visible through muggy white sky, midsummer sticky-heat mood, NO golden ripe rice, NO autumn russet, NO clear blue sky, NO harvest scenes, ukiyo-e woodblock",
    38: "a cicada on a tree branch at dusk, warm orange evening light",
    45: "a flock of swallow birds perched in a row on a thin bamboo branch over a rice field, preparing autumn migration south",
    47: "a small round black beetle insect partially buried in a pile of fallen red and yellow autumn maple leaves on the forest floor, detailed woodblock print",
    48: "elderly Japanese farmer in traditional clothes releasing water from a rice paddy field using a wooden board, autumn harvest preparation, traditional painting style",
    49: "V-formation flock of wild geese birds flying across autumn sky, returning from the north, sunset over countryside",
    51: "a small brown chirping cricket insect sitting on the wooden threshold of a traditional Japanese sliding paper door shoji, autumn moonlit evening, ink painting",
    61: "heavy dark winter clouds sealing sky over a snowy village",
    62: "a black bear walking into its cave den, snowy winter forest, paw prints in the snow, hibernation",
    63: "many salmon fish leaping upstream through rapids in a shallow rocky mountain river, splashing white water, snow-dusted winter rocks, ukiyo-e style",
    64: "close-up of two or three tiny bright-green prunella seedlings (just the leaves, NO flowers, NO buds, NO purple, NO bells) pushing up through a thin crust of fresh white snow, dark winter soil visible at the base of each sprout, soft pre-dawn winter solstice light, palette of sumi ink and snow white with a single fresh green for the shoots, return-of-light mood, ukiyo-e woodblock PAINTING not a photograph",
    67: "close-up of a dense clump of bright green Japanese seri water dropwort herb growing at the edge of a cold winter stream, water flowing past, traditional woodblock illustration",
    69: "a male ring-necked pheasant bird with bright plumage crowing in a snowy winter field, clear morning",
    72: "simple scene of brown and white hens chickens gathered inside a straw-lined wooden barn coop, white eggs on the ground, warm light, plain background, no decorative seals, no text, no letters",
}

STYLE_SUFFIX = (
    "in the style of a traditional Japanese ukiyo-e woodblock print, "
    "muted earth tones with selective vibrant accents, bold black outlines, "
    "flat color fields, soft atmospheric sky gradient, "
    "Hokusai Hiroshige aesthetic, aged paper texture, "
    "no text, no letters, no borders, no signature"
)


def build_url(prompt: str, seed: int, size: int = 1024) -> str:
    """Compose a Pollinations image URL for a given prompt."""
    encoded = urllib.parse.quote(prompt, safe="")
    return (
        f"https://image.pollinations.ai/prompt/{encoded}"
        f"?width={size}&height={size}&model=flux&nologo=true&seed={seed}"
    )


def download(url: str, dest: pathlib.Path, timeout: int = 90) -> bool:
    """Download an image URL to disk. Returns True on success."""
    req = urllib.request.Request(url, headers={"User-Agent": "seasons_72/1.0"})
    try:
        with urllib.request.urlopen(req, timeout=timeout, context=SSL_CTX) as response:
            data = response.read()
            if len(data) < 5_000:
                # Likely an error placeholder, not a real image.
                return False
            dest.write_bytes(data)
            return True
    except Exception as e:
        print(f"    ! error: {type(e).__name__}: {e}")
        return False


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--force", action="store_true",
                        help="Regenerate even if image already exists")
    parser.add_argument("--only", nargs="+", type=int,
                        help="Only generate these kō indexes")
    parser.add_argument("--size", type=int, default=1024,
                        help="Image size in pixels (square). Default: 1024")
    parser.add_argument("--delay", type=float, default=2.0,
                        help="Seconds to wait between requests. Default: 2")
    args = parser.parse_args()

    if not SEASONS_JSON.exists():
        print(f"✗ {SEASONS_JSON} not found. Run from project root.")
        return 1
    IMAGES_DIR.mkdir(parents=True, exist_ok=True)

    # Decide which kō to process
    if args.only:
        targets = args.only
    elif args.force:
        targets = list(range(1, 73))
    else:
        # Only the ones without an existing PNG
        targets = [
            i for i in range(1, 73)
            if not (IMAGES_DIR / f"{i}.png").exists()
        ]

    if not targets:
        print("✓ All 72 illustrations already present. Use --force to regenerate.")
        return 0

    print(f"→ Generating {len(targets)} illustrations via Pollinations.ai (Flux.1)")
    print(f"  Output: {IMAGES_DIR}")
    print(f"  Size:   {args.size}x{args.size}, delay between requests: {args.delay}s\n")

    random.seed()  # fresh seeds every run — needed for regeneration variety
    successes = 0
    failures = []
    for idx in targets:
        if idx not in SCENES:
            print(f"  #{idx}: no scene description, skipping")
            continue
        prompt = f"{SCENES[idx]}, {STYLE_SUFFIX}"
        seed = random.randint(1, 999_999)
        url = build_url(prompt, seed, size=args.size)
        dest = IMAGES_DIR / f"{idx}.png"
        print(f"  #{idx:2d} → {dest.name}", end=" ", flush=True)
        start = time.time()
        ok = download(url, dest)
        elapsed = time.time() - start
        if ok:
            kb = dest.stat().st_size / 1024
            print(f"✓ {kb:,.0f} KB ({elapsed:.1f}s)")
            successes += 1
        else:
            print(f"✗ ({elapsed:.1f}s)")
            failures.append(idx)
        time.sleep(args.delay)

    print()
    print(f"✓ Done. Success: {successes}/{len(targets)}")
    if failures:
        print(f"  Failed: {failures}. Rerun the script to retry.")
    else:
        print()
        print("Next steps:")
        print("  python3 scripts/sync_images.py    # update seasons.json")
        print("  # in flutter terminal: Q → flutter run")
    return 0 if not failures else 2


if __name__ == "__main__":
    sys.exit(main())
