#!/bin/bash
#SBATCH --job-name=ucp_lru4c_1
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp_lru4c_1_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e
cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP
mkdir -p results

bin/champsim_lru_4c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/602.gcc_s-734B.champsimtrace.xz \
  ~pgratz/dpc3_traces/605.mcf_s-665B.champsimtrace.xz \
  ~pgratz/dpc3_traces/620.omnetpp_s-874B.champsimtrace.xz \
  ~pgratz/dpc3_traces/625.x264_s-18B.champsimtrace.xz \
  > results/lru_mix2_repeat.txt
