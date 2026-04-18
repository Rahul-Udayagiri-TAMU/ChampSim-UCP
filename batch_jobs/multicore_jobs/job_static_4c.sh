#!/bin/bash
#SBATCH --job-name=ucp_static_4c
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=shruthikrishnan@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp_static_4c_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e
cd /home/grads/s/shruthikrishnan/ECEN676/project/ChampSim-UCP
mkdir -p results

TRACES=~pgratz/dpc3_traces

# Mix A: cache-sensitive heavy
echo "Running 4c Static Mix A (bwaves, mcf, gcc, omnetpp)"
bin/champsim_static_4c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  $TRACES/603.bwaves_s-3699B.champsimtrace.xz \
  $TRACES/605.mcf_s-665B.champsimtrace.xz \
  $TRACES/602.gcc_s-734B.champsimtrace.xz \
  $TRACES/620.omnetpp_s-874B.champsimtrace.xz \
  > results/static_4c_mixA.txt

# Mix B: mixed sensitivity
echo "Running 4c Static Mix B (bwaves, mcf, x264, leela)"
bin/champsim_static_4c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  $TRACES/603.bwaves_s-3699B.champsimtrace.xz \
  $TRACES/605.mcf_s-665B.champsimtrace.xz \
  $TRACES/625.x264_s-18B.champsimtrace.xz \
  $TRACES/641.leela_s-800B.champsimtrace.xz \
  > results/static_4c_mixB.txt

# Mix C: cache-insensitive heavy
echo "Running 4c Static Mix C (x264, leela, deepsjeng, xalancbmk)"
bin/champsim_static_4c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  $TRACES/625.x264_s-18B.champsimtrace.xz \
  $TRACES/641.leela_s-800B.champsimtrace.xz \
  $TRACES/631.deepsjeng_s-928B.champsimtrace.xz \
  $TRACES/623.xalancbmk_s-700B.champsimtrace.xz \
  > results/static_4c_mixC.txt

echo "Done: Static 4-core runs"
