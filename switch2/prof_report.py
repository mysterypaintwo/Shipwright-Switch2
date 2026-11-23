#!/usr/bin/env python3
"""Summarizes the T lines of a debug stream log.

  python3 switch2/prof_report.py session.log [--scene N] [--skip SECONDS]

Times are milliseconds per presented frame, averaged over the run. "worst" is
the longest single call seen in any one-second report.
"""
import argparse
import re
from collections import defaultdict

ZONES = ["game", "update", "build", "audiowait", "events", "guistart", "rdp", "draw", "upload", "shader",
         "fbcopy", "fbread", "guiend", "flush", "pace", "swap", "audio", "resource", "fileread", "teximport"]
COUNTERS = ["draws", "tris", "uploads", "uploadkb", "shaders", "fbbinds", "resources", "resbytes"]


def parse(path):
    for line in open(path, errors="replace"):
        at = line.find(" T ")
        if at < 0:
            continue
        fields = dict(re.findall(r"(\w+)=(\S+)", line[at:]))
        if "frames" in fields and "swap" in fields:
            yield fields


def summarize(rows, title):
    frames = sum(int(r["frames"]) for r in rows)
    seconds = sum(int(r["us"]) for r in rows) / 1e6
    if not frames or not seconds:
        return
    print(f"\n{title}: {seconds:.0f} s, {frames / seconds:.1f} fps, "
          f"{sum(int(r['ticks']) for r in rows) / seconds:.1f} game ticks/s, target {rows[-1]['target']}, "
          f"{sum(int(r['late']) for r in rows)} late frames, "
          f"longest frame {max(int(r['longest']) for r in rows) / 1000:.1f} ms")
    print("  per frame: " + ", ".join(f"{c} {sum(int(r.get(c, 0)) for r in rows) / frames:.1f}" for c in COUNTERS))
    print(f"  {'zone':<10}{'ms/frame':>10}{'worst ms':>10}{'calls/frame':>13}")
    for zone in ZONES:
        parts = [tuple(map(int, r[zone].split(":"))) for r in rows if zone in r]
        total = sum(p[0] for p in parts)
        if total:
            print(f"  {zone:<10}{total / 1000 / frames:>10.2f}{max(p[1] for p in parts) / 1000:>10.1f}"
                  f"{sum(p[2] for p in parts) / frames:>13.2f}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("log")
    parser.add_argument("--scene", type=int)
    parser.add_argument("--skip", type=int, default=0)
    args = parser.parse_args()
    rows = list(parse(args.log))[args.skip:]
    if args.scene is not None:
        rows = [r for r in rows if int(r["scene"]) == args.scene]
    if not rows:
        print("No profile lines found.")
        return
    summarize(rows, "All")
    scenes = defaultdict(list)
    for row in rows:
        scenes[int(row["scene"])].append(row)
    if args.scene is None and len(scenes) > 1:
        for scene, scene_rows in sorted(scenes.items(), key=lambda kv: -len(kv[1])):
            summarize(scene_rows, f"Scene {scene}")


if __name__ == "__main__":
    main()
