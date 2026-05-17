#!/bin/bash
set -e

REPO="/home/grads/u/udayagirirahul7/ECEN676/project/ChampSim-UCP"
TRACE_DIR="~pgratz/dpc3_traces"

WARM=1000000
SIM=20000000

PARTITION="adademic"
QOS="olympus-academic"
TIME="12:00:00"
MAIL="udayagirirahul7@tamu.edu"

WAYS=(1 2 4 6 8 10 12 14 16)

declare -A TRACE
TRACE[mcf]="605.mcf_s-665B.champsimtrace.xz"
TRACE[bwaves]="603.bwaves_s-3699B.champsimtrace.xz"
TRACE[x264]="625.x264_s-18B.champsimtrace.xz"
TRACE[gcc]="602.gcc_s-734B.champsimtrace.xz"
TRACE[xalancbmk]="623.xalancbmk_s-700B.champsimtrace.xz"
TRACE[omnetpp]="620.omnetpp_s-874B.champsimtrace.xz"

for bench in mcf bwaves x264 gcc xalancbmk omnetpp; do
  for w in "${WAYS[@]}"; do
    job="solo_${bench}_${w}w"
    file="batch_jobs/${job}.sh"
    binname="champsim_lru_1c_llc${w}w"
    outname="solo_${bench}_llc${w}w"

    cat > "$file" <<EOT
#!/bin/bash
#SBATCH --job-name=${job}
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=${MAIL}
#SBATCH --ntasks=1
#SBATCH --time=${TIME}
#SBATCH --output=${job}_%j.log
#SBATCH --qos=${QOS}
#SBATCH --partition=${PARTITION}

set -e
cd ${REPO}
mkdir -p results

bin/${binname} \\
  --warmup-instructions ${WARM} \\
  --simulation-instructions ${SIM} \\
  ${TRACE_DIR}/${TRACE[$bench]} \\
  > results/${outname}.txt
EOT

    chmod +x "$file"
  done
done

echo "Created 54 single-core way-sweep jobs."
