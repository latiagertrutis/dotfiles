#!/usr/bin/env python3
"""Bake letter-spacing (tracking) into a font, since Emacs can't do it.

usage:
  track-font.py FONT --list                      # show axes + named instances
  track-font.py FONT OUTDIR [--track 0.06] [--space 0.10] [--family NAME]
                      [--instances "Fizzy Regular" "Fizzy Bold" ...]
--track / --space are fractions of the em added to every glyph / to the space.
Example:
sudo pacman -S python-fonttools
F=~/.local/share/fonts/pppalma-fizzyvariable-vf.ttf

python ~/bin/track-font.py "$F" --list     # see the exact instance names

python ~/bin/track-font.py "$F" ~/.local/share/fonts/palma-spaced \
  --family "PP Palma Spaced" --track 0.06 --space 0.10 \
  --instances "Fizzy Regular" "Fizzy Bold" "Fizzy Regular Italic" "Fizzy Bold Italic"

fc-cache -f
fc-list | grep -i "palma spaced"
"""
import argparse, os, sys
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

SPACES = {"space", "uni00A0", "nbspace", "nonbreakingspace", "uni202F"}

def nm(f, i):
    return f["name"].getDebugName(i)

def named_instances(f):
    return {nm(f, i.subfamilyNameID): i.coordinates for i in f["fvar"].instances}

def track(f, add, space_add):
    hmtx = f["hmtx"].metrics
    cmap = f.getBestCmap() or {}
    space_glyphs = {g for cp, g in cmap.items() if cp in (0x20, 0xA0, 0x202F)} | SPACES
    for g, (adv, lsb) in list(hmtx.items()):
        if adv == 0:                       # combining marks: leave alone
            continue
        extra = add + (space_add if g in space_glyphs else 0)
        hmtx[g] = (adv + extra, lsb)       # extra space goes after the glyph
    for t in ("hdmx", "LTSH", "VDMX"):     # cached metrics, now stale
        if t in f: del f[t]

def rename(f, family, style):
    name = f["name"]
    ps = (family + "-" + style).replace(" ", "")
    for nid in (16, 17, 21, 22, 25):
        name.removeNames(nameID=nid)
    rib = style if style in ("Regular", "Bold", "Italic", "Bold Italic") else "Regular"
    for nid, val in ((1, family), (2, rib), (3, ps), (4, f"{family} {style}"), (6, ps)):
        name.setName(val, nid, 3, 1, 0x409)
        name.setName(val, nid, 1, 0, 0)
    bold, ital = "Bold" in style, "Italic" in style
    os2 = f["OS/2"]
    os2.usWeightClass = 700 if bold else 400
    sel = os2.fsSelection & ~0b1100001
    sel |= (1 if ital else 0) | (0x20 if bold else 0) | (0x40 if not (bold or ital) else 0)
    os2.fsSelection = sel
    f["head"].macStyle = (1 if bold else 0) | (2 if ital else 0)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("font"); ap.add_argument("outdir", nargs="?")
    ap.add_argument("--list", action="store_true")
    ap.add_argument("--track", type=float, default=0.06)
    ap.add_argument("--space", type=float, default=0.10)
    ap.add_argument("--family", default=None)
    ap.add_argument("--instances", nargs="*")
    a = ap.parse_args()

    src = TTFont(a.font)
    vf = "fvar" in src
    if a.list:
        if vf:
            for ax in src["fvar"].axes:
                print(f"axis {ax.axisTag}: {ax.minValue} .. {ax.defaultValue} .. {ax.maxValue}")
            for k, v in named_instances(src).items():
                print(f"instance {k!r}: {v}")
        else:
            print("static font")
        return
    if not a.outdir: sys.exit("need OUTDIR")
    os.makedirs(a.outdir, exist_ok=True)
    family = a.family or (nm(src, 16) or nm(src, 1)).replace(" Variable", "") + " Spaced"

    if vf:
        insts = named_instances(src)
        wanted = a.instances or list(insts)
        jobs = []
        for w in wanted:
            if w not in insts: sys.exit(f"no instance {w!r}; try --list")
            jobs.append((w, insts[w]))
    else:
        jobs = [(nm(src, 2), None)]

    for style_name, coords in jobs:
        f = TTFont(a.font)
        if coords is not None:
            f = instancer.instantiateVariableFont(f, coords)
        upm = f["head"].unitsPerEm
        track(f, round(a.track * upm), round(a.space * upm))
        style = " ".join(w for w in style_name.split() if w.lower() != "fizzy") or "Regular"
        rename(f, family, style)
        out = os.path.join(a.outdir, f"{family}-{style}".replace(" ", "") + ".ttf")
        f.save(out)
        print("wrote", out)

if __name__ == "__main__":
    main()
