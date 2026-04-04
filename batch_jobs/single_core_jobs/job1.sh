#!/bin/bash
#SBATCH --job-name=ucp_solo_1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp_solo_1_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e
cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP
mkdir -p results

echo "Running solo LRU gcc"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/602.gcc_s-734B.champsimtrace.xz \
  > results/solo_lru_gcc.txt

echo "Running solo LRU bwaves"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/603.bwaves_s-3699B.champsimtrace.xz \
  > results/solo_lru_bwaves.txt

echo "Running solo LRU mcf"
bin/champsim_lru_1c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/605.mcf_s-665B.champsimtrace.xz \
  > results/solo_lru_mcf.txt
