import json
from pathlib import Path

base_path = Path("configs/config_lru_1core_llc16w.json")
base = json.loads(base_path.read_text())

ways_list = [2, 6, 10, 12, 14]

for w in ways_list:
    cfg = json.loads(json.dumps(base))
    cfg["executable_name"] = f"champsim_lru_1c_llc{w}w"
    cfg["LLC"]["ways"] = w
    out = Path(f"configs/config_lru_1core_llc{w}w.json")
    out.write_text(json.dumps(cfg, indent=2))
    print(f"Wrote {out}")
