import re
import csv
from pathlib import Path

results_dir = Path("results")
out_csv = Path("results/singlecore_way_sweep_summary.csv")

pat_name = re.compile(r"solo_(.+?)_llc(\d+)w\.txt$")
pat_ipc = re.compile(r"CPU 0 cumulative IPC:\s*([0-9.]+)")
pat_llc = re.compile(r"cpu0->LLC LOAD\s+ACCESS:\s*([0-9]+)\s+HIT:\s*([0-9]+)\s+MISS:\s*([0-9]+)")

rows = []

for path in sorted(results_dir.glob("solo_*_llc*w.txt")):
    m = pat_name.match(path.name)
    if not m:
        continue
    bench = m.group(1)
    ways = int(m.group(2))
    text = path.read_text(errors="ignore")

    roi_idx = text.rfind("Region of Interest Statistics")
    if roi_idx != -1:
        text_use = text[roi_idx:]
    else:
        text_use = text

    ipc_m = pat_ipc.search(text_use)
    llc_m = pat_llc.search(text_use)

    if not ipc_m or not llc_m:
        print(f"Warning: could not parse {path}")
        continue

    ipc = float(ipc_m.group(1))
    access = int(llc_m.group(1))
    miss = int(llc_m.group(3))
    mpki = (miss * 1000.0) / 20000000.0

    rows.append([bench, ways, ipc, access, miss, mpki, path.name])

rows.sort(key=lambda x: (x[0], x[1]))

with out_csv.open("w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["benchmark", "ways", "ipc", "llc_load_access", "llc_load_miss", "llc_load_mpki", "file"])
    writer.writerows(rows)

print(f"Wrote {out_csv}")
