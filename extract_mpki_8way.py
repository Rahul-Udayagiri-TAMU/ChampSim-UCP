import re
import csv
from pathlib import Path

files = [
    "results/pair1_mcf_bwaves_lru_llc8w.txt",
    "results/pair1_mcf_bwaves_static_llc8w.txt",
    "results/pair1_mcf_bwaves_ucp_llc8w.txt",
    "results/pair2_mcf_x264_lru_llc8w.txt",
    "results/pair2_mcf_x264_static_llc8w.txt",
    "results/pair2_mcf_x264_ucp_llc8w.txt",
    "results/pair3_xalancbmk_gcc_lru_llc8w.txt",
    "results/pair3_xalancbmk_gcc_static_llc8w.txt",
    "results/pair3_xalancbmk_gcc_ucp_llc8w.txt",
    "results/pair4_omnetpp_bwaves_lru_llc8w.txt",
    "results/pair4_omnetpp_bwaves_static_llc8w.txt",
    "results/pair4_omnetpp_bwaves_ucp_llc8w.txt",
    "results/pair6_omnetpp_x264_lru_llc8w.txt",
    "results/pair6_omnetpp_x264_static_llc8w.txt",
    "results/pair6_omnetpp_x264_ucp_llc8w.txt",
]

pair_map = {
    "pair1_mcf_bwaves": "mcf+bwaves",
    "pair2_mcf_x264": "mcf+x264",
    "pair3_xalancbmk_gcc": "xalancbmk+gcc",
    "pair4_omnetpp_bwaves": "omnetpp+bwaves",
    "pair6_omnetpp_x264": "omnetpp+x264",
}

def policy_of(name):
    if "_lru_" in name: return "LRU"
    if "_static_" in name: return "Static"
    if "_ucp_" in name: return "UCP"
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

with open("results/mpki_8way_summary.csv", "w", newline="") as out:
    w = csv.writer(out)
    w.writerow(["pair", "policy", "cpu0_llc_load_mpki", "cpu1_llc_load_mpki"])
    w.writerows(rows)

print("Wrote results/mpki_8way_summary.csv")
