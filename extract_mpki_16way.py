import re
import csv
from pathlib import Path

files = [
    "results/direct_pair1_lru.txt",
    "results/direct_pair1_static.txt",
    "results/direct_pair1_ucp.txt",
    "results/direct_pair2_lru.txt",
    "results/direct_pair2_static.txt",
    "results/direct_pair2_ucp.txt",
    "results/pair5_mcf_gcc_lru.txt",
    "results/pair5_mcf_gcc_static.txt",
    "results/pair5_mcf_gcc_ucp.txt",
    "results/pair6_omnetpp_x264_lru.txt",
    "results/pair6_omnetpp_x264_static.txt",
    "results/pair6_omnetpp_x264_ucp.txt",
    "results/pair3_xalancbmk_gcc_lru.txt",
    "results/pair3_xalancbmk_gcc_static.txt",
    "results/pair3_xalancbmk_gcc_ucp.txt",
    "results/pair4_omnetpp_bwaves_lru.txt",
    "results/pair4_omnetpp_bwaves_static.txt",
    "results/pair4_omnetpp_bwaves_ucp.txt",
]

pair_map = {
    "direct_pair1": "mcf+bwaves",
    "direct_pair2": "mcf+x264",
    "pair5_mcf_gcc": "mcf+gcc",
    "pair6_omnetpp_x264": "omnetpp+x264",
    "pair3_xalancbmk_gcc": "xalancbmk+gcc",
    "pair4_omnetpp_bwaves": "omnetpp+bwaves",
}

def policy_of(name):
    if "_lru" in name: return "LRU"
    if "_static" in name: return "Static"
    if "_ucp" in name: return "UCP"
    return "Unknown"

pat = re.compile(r"cpu([01])->LLC LOAD\s+ACCESS:\s*([0-9]+)\s+HIT:\s*([0-9]+)\s+MISS:\s*([0-9]+)")

rows = []
for f in files:
    p = Path(f)
    if not p.exists():
        continue
    txt = p.read_text(errors="ignore")
    roi = txt.rfind("Region of Interest Statistics")
    if roi != -1:
        txt = txt[roi:]
    matches = pat.findall(txt)

    cpu_stats = {}
    for cpu, access, hit, miss in matches:
        cpu = int(cpu)
        miss = int(miss)
        mpki = miss * 1000.0 / 20000000.0
        cpu_stats[cpu] = mpki

    stem = p.stem
    pair = next((v for k, v in pair_map.items() if k in stem), stem)
    policy = policy_of(stem)

    rows.append([pair, policy, cpu_stats.get(0, ""), cpu_stats.get(1, "")])

with open("results/mpki_16way_summary.csv", "w", newline="") as out:
    w = csv.writer(out)
    w.writerow(["pair", "policy", "cpu0_llc_load_mpki", "cpu1_llc_load_mpki"])
    w.writerows(rows)

print("Wrote results/mpki_16way_summary.csv")
