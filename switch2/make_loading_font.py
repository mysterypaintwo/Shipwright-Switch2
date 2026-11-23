#!/usr/bin/env python3
"""Bakes the boot loading screen's text into a C header.

  python3 switch2/make_loading_font.py

Uses Montserrat, the font already in soh/assets/custom/fonts.
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT = ROOT / "soh/assets/custom/fonts/Montserrat-Regular.ttf"
OUT = ROOT / "libultraship/src/ship/port/switch/SwitchLoadingFont.h"
TITLE = "ShipOfHarkinian"
CHARS = sorted(set("Loading game data Loading audio Preparing shaders Preparing graphics 0123456789%."))
ATLAS_W, PAD = 1024, 3

title_font = ImageFont.truetype(str(FONT), 72)
label_font = ImageFont.truetype(str(FONT), 34)
tb = title_font.getbbox(TITLE, anchor="ls")
title_w, title_h = tb[2] - tb[0], tb[3] - tb[1]
assert title_w + 8 <= ATLAS_W, "the title does not fit in the atlas"
atlas = Image.new("L", (ATLAS_W, 512), 0)
draw = ImageDraw.Draw(atlas)
atlas.paste(255, (0, 0, 4, 4))
x, y = 8, 0
draw.text((x - tb[0], y - tb[1]), TITLE, font=title_font, fill=255, anchor="ls")
title_rect = (x, y, title_w, title_h)
x, y, row = 0, title_h + PAD + 4, 0
glyphs = []
for c in CHARS:
    b = label_font.getbbox(c, anchor="ls")
    w, h = max(0, b[2] - b[0]), max(0, b[3] - b[1])
    if x + w + PAD > ATLAS_W:
        x, y, row = 0, y + row + PAD, 0
    if w and h:
        draw.text((x - b[0], y - b[1]), c, font=label_font, fill=255, anchor="ls")
    glyphs.append((ord(c), x, y, w, h, b[0], b[1], label_font.getlength(c)))
    x += w + PAD
    row = max(row, h)
height = y + row + PAD
pixels = atlas.crop((0, 0, ATLAS_W, height)).tobytes()

with OUT.open("w") as f:
    f.write("#pragma once\n// Made by switch2/make_loading_font.py from Montserrat. Do not edit.\n#include <cstdint>\n\n")
    f.write(f"static constexpr int kLoadingAtlasWidth = {ATLAS_W};\nstatic constexpr int kLoadingAtlasHeight = {height};\n")
    f.write(f"static constexpr int kLoadingTitle[4] = {{ {title_rect[0]}, {title_rect[1]}, {title_rect[2]}, {title_rect[3]} }};\n")
    f.write("struct LoadingGlyph {\n    char c;\n    short x, y, w, h, left, top;\n    float advance;\n};\n")
    f.write("static const LoadingGlyph kLoadingGlyphs[] = {\n")
    for g in glyphs:
        f.write(f"    {{ {g[0]}, {g[1]}, {g[2]}, {g[3]}, {g[4]}, {g[5]}, {g[6]}, {g[7]:.3f}f }},\n")
    f.write("};\nstatic const uint8_t kLoadingAtlas[] = {\n")
    for i in range(0, len(pixels), 32):
        f.write(",".join(str(v) for v in pixels[i:i + 32]) + ",\n")
    f.write("};\n")
print(f"atlas {ATLAS_W}x{height}, {len(glyphs)} glyphs")
