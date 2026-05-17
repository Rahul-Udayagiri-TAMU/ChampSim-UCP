#!/bin/bash
#SBATCH --job-name=p7_static_8w
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=p7_static_8w_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e
cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP
mkdir -p results

bin/champsim_static_2c_llc8w \
  --warmup-instructions 1000000 \
  --simulation-instructions 20000000 \
  ~pgratz/dpc3_traces/623.xalancbmk_s-700B.champsimtrace.xz \
  ~pgratz/dpc3_traces/603.bwaves_s-3699B.champsimtrace.xz \
  > results/pair7_xalancbmk_bwaves_static_llc8w.txt
