#!/bin/bash

#SBATCH --job-name=ucp_sanity_m2
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp_sanity_m2_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e

cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP

mkdir -p results

echo "Running long UCP sanity mix2"

bin/champsim_static_4c \
  --warmup-instructions 1000000 \
  --simulation-instructions 20000000 \
  ~pgratz/dpc3_traces/602.gcc_s-734B.champsimtrace.xz \
  ~pgratz/dpc3_traces/620.omnetpp_s-874B.champsimtrace.xz \
  ~pgratz/dpc3_traces/625.x264_s-18B.champsimtrace.xz \
  ~pgratz/dpc3_traces/623.xalancbmk_s-700B.champsimtrace.xz \
  > results/ucp_step2_long_sanity_mix2.txt
