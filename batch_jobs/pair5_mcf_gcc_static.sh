#!/bin/bash
#SBATCH --job-name=p5_static
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=p5_static_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e

cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP
mkdir -p results

bin/champsim_static_2c \
  --warmup-instructions 1000000 \
  --simulation-instructions 20000000 \
  ~pgratz/dpc3_traces/605.mcf_s-665B.champsimtrace.xz \
  ~pgratz/dpc3_traces/602.gcc_s-734B.champsimtrace.xz \
  > results/pair5_mcf_gcc_static.txt
