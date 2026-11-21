#!/usr/bin/env python3
"""Erzeugt das NIMA-App-Icon (1024x1024, ohne Alpha) und den Asset-Katalog."""
import json
import math
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "App" / "Assets.xcassets"
S = 1024
ACC = (159, 239, 0)


def hexagon(cx, cy, r):
    return [(cx + r * math.cos(math.radians(a)), cy + r * math.sin(math.radians(a))) for a in range(-90, 270, 60)]


img = Image.new("RGB", (S, S), (7, 11, 18))
d = ImageDraw.Draw(img)
# background glow + grid
glow = Image.new("RGB", (S, S), (0, 0, 0))
gd = ImageDraw.Draw(glow)
gd.ellipse((S * 0.1, S * 0.05, S * 0.9, S * 0.85), fill=(40, 70, 0))
glow = glow.filter(ImageFilter.GaussianBlur(160))
img = Image.blend(img, glow, 0.6)
d = ImageDraw.Draw(img)
for x in range(0, S, 64):
    d.line([(x, 0), (x, S)], fill=(18, 28, 22), width=2)
    d.line([(0, x), (S, x)], fill=(18, 28, 22), width=2)
# hexagon with neon glow
layer = Image.new("RGB", (S, S), (0, 0, 0))
ld = ImageDraw.Draw(layer)
ld.polygon(hexagon(S / 2, S * 0.47, 330), outline=ACC, width=34)
layer = layer.filter(ImageFilter.GaussianBlur(26))
img = Image.composite(Image.new("RGB", (S, S), ACC), img, layer.convert("L").point(lambda v: min(255, v * 2)))
d = ImageDraw.Draw(img)
d.polygon(hexagon(S / 2, S * 0.47, 330), fill=(12, 20, 14))
d.line(hexagon(S / 2, S * 0.47, 330) + [hexagon(S / 2, S * 0.47, 330)[0]], fill=ACC, width=30, joint="curve")
# prompt >_
cx, cy = S / 2, S * 0.47
d.line([(cx - 150, cy - 110), (cx - 30, cy), (cx - 150, cy + 110)], fill=ACC, width=56, joint="curve")
d.rounded_rectangle((cx + 10, cy + 70, cx + 170, cy + 122), radius=14, fill=ACC)
# wordmark
font = None
for f in ["C:/Windows/Fonts/consolab.ttf", "C:/Windows/Fonts/CascadiaMono.ttf", "/System/Library/Fonts/Menlo.ttc"]:
    try:
        font = ImageFont.truetype(f, 150)
        break
    except OSError:
        pass
if font:
    w = d.textlength("NIMA", font=font)
    d.text(((S - w) / 2, S * 0.80), "NIMA", font=font, fill=(232, 238, 248))

icon_dir = ASSETS / "AppIcon.appiconset"
icon_dir.mkdir(parents=True, exist_ok=True)
img.save(icon_dir / "icon-1024.png")
(icon_dir / "Contents.json").write_text(json.dumps({
    "images": [{"filename": "icon-1024.png", "idiom": "universal", "platform": "ios", "size": "1024x1024"}],
    "info": {"author": "xcode", "version": 1},
}, indent=2))
acc_dir = ASSETS / "AccentColor.colorset"
acc_dir.mkdir(parents=True, exist_ok=True)
(acc_dir / "Contents.json").write_text(json.dumps({
    "colors": [{"idiom": "universal", "color": {"color-space": "srgb", "components": {"red": "0.624", "green": "0.937", "blue": "0.000", "alpha": "1.000"}}}],
    "info": {"author": "xcode", "version": 1},
}, indent=2))
(ASSETS / "Contents.json").write_text(json.dumps({"info": {"author": "xcode", "version": 1}}, indent=2))
print("Icon:", icon_dir / "icon-1024.png")
