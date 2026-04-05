#!/bin/bash
#SBATCH --job-name=ucp_solo_2
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp_solo_2_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e
cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP
mkdir -p results

echo "Running solo LRU deepsjeng"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/631.deepsjeng_s-928B.champsimtrace.xz \
  > results/solo_lru_deepsjeng.txt

echo "Running solo LRU omnetpp"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/620.omnetpp_s-141B.champsimtrace.xz \
  > results/solo_lru_omnetpp.txt

echo "Running solo LRU leela"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/641.leela_s-800B.champsimtrace.xz \
  > results/solo_lru_leela.txt
