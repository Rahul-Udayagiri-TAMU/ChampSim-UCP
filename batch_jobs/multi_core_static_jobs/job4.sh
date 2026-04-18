#!/bin/bash
#SBATCH --job-name=ucp_static4c_4
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp_static4c_4_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e
cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP
mkdir -p results

echo "Running STATIC mix4"
bin/champsim_static_4c \
  --warmup-instructions 50000000 \
  --simulation-instructions 250000000 \
  ~pgratz/dpc3_traces/602.gcc_s-734B.champsimtrace.xz \
  ~pgratz/dpc3_traces/620.omnetpp_s-874B.champsimtrace.xz \
  ~pgratz/dpc3_traces/623.xalancbmk_s-700B.champsimtrace.xz \
  ~pgratz/dpc3_traces/625.x264_s-18B.champsimtrace.xz \
  > results/static_mix4.txt
