#!/bin/bash
#SBATCH --job-name=ucp_solo_3
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp_solo_3_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e
cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP
mkdir -p results

echo "Running solo LRU xalancbmk"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/623.xalancbmk_s-700B.champsimtrace.xz \
  > results/solo_lru_xalancbmk.txt

echo "Running solo LRU x264"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/625.x264_s-18B.champsimtrace.xz \
  > results/solo_lru_x264.txt
