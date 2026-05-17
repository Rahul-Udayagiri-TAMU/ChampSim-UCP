import csv
from collections import defaultdict
import matplotlib.pyplot as plt

data = defaultdict(list)

with open("results/singlecore_way_sweep_summary.csv") as f:
    reader = csv.DictReader(f)
    for row in reader:
        b = row["benchmark"]
        data[b].append((int(row["ways"]), float(row["ipc"]), float(row["llc_load_mpki"])))

for b in data:
    data[b].sort()

# IPC plot
plt.figure(figsize=(10, 6))
for b, vals in data.items():
    x = [v[0] for v in vals]
    y = [v[1] for v in vals]
    plt.plot(x, y, marker='o', label=b)
plt.xlabel("LLC ways")
plt.ylabel("IPC")
plt.title("Single-core IPC vs LLC ways")
plt.xticks([1,2,4,6,8,10,12,14,16])
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig("results/singlecore_ipc_vs_ways.png", dpi=200)
plt.close()

# MPKI plot
plt.figure(figsize=(10, 6))
for b, vals in data.items():
    x = [v[0] for v in vals]
    y = [v[2] for v in vals]
    plt.plot(x, y, marker='o', label=b)
plt.xlabel("LLC ways")
plt.ylabel("LLC LOAD MPKI")
plt.title("Single-core LLC LOAD MPKI vs LLC ways")
plt.xticks([1,2,4,6,8,10,12,14,16])
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.savefig("results/singlecore_mpki_vs_ways.png", dpi=200)
plt.close()

print("Wrote results/singlecore_ipc_vs_ways.png")
print("Wrote results/singlecore_mpki_vs_ways.png")
