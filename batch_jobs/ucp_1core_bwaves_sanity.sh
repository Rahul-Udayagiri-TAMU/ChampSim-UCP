#!/bin/bash

#SBATCH --job-name=ucp1_bwaves
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=udayagirirahul7@tamu.edu
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=ucp1_bwaves_%j.log
#SBATCH --qos=olympus-academic
#SBATCH --partition=adademic

set -e

cd /home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP

mkdir -p results

bin/champsim_ucp_1c \
  --warmup-instructions 1000000 \
  --simulation-instructions 20000000 \
  ~pgratz/dpc3_traces/603.bwaves_s-3699B.champsimtrace.xz \
  > results/solo_ucp_bwaves_sanity.txt
