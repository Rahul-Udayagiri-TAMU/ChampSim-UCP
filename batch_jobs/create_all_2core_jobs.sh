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

make_job () {
  local file="$1"
  local jobname="$2"
  local binname="$3"
  local t0="$4"
  local t1="$5"
  local outname="$6"

  cat > "$file" <<EOT
#!/bin/bash
#SBATCH --job-name=${jobname}
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=${MAIL}
#SBATCH --ntasks=1
#SBATCH --time=${TIME}
#SBATCH --output=${jobname}_%j.log
#SBATCH --qos=${QOS}
#SBATCH --partition=${PARTITION}

set -e

cd ${REPO}
mkdir -p results

bin/${binname} \\
  --warmup-instructions ${WARM} \\
  --simulation-instructions ${SIM} \\
  ${TRACE_DIR}/${t0} \\
  ${TRACE_DIR}/${t1} \\
  > results/${outname}.txt
EOT

  chmod +x "$file"
}

# Pair 1: sanity pair
make_job batch_jobs/pair1_mcf_bwaves_lru.sh    p1_lru    champsim_lru_2c    605.mcf_s-665B.champsimtrace.xz      603.bwaves_s-3699B.champsimtrace.xz  pair1_mcf_bwaves_lru
make_job batch_jobs/pair1_mcf_bwaves_static.sh p1_static champsim_static_2c 605.mcf_s-665B.champsimtrace.xz      603.bwaves_s-3699B.champsimtrace.xz  pair1_mcf_bwaves_static
make_job batch_jobs/pair1_mcf_bwaves_ucp.sh    p1_ucp    champsim_ucp_2c    605.mcf_s-665B.champsimtrace.xz      603.bwaves_s-3699B.champsimtrace.xz  pair1_mcf_bwaves_ucp

# Pair 2
make_job batch_jobs/pair2_mcf_x264_lru.sh      p2_lru    champsim_lru_2c    605.mcf_s-665B.champsimtrace.xz      625.x264_s-18B.champsimtrace.xz      pair2_mcf_x264_lru
make_job batch_jobs/pair2_mcf_x264_static.sh   p2_static champsim_static_2c 605.mcf_s-665B.champsimtrace.xz      625.x264_s-18B.champsimtrace.xz      pair2_mcf_x264_static
make_job batch_jobs/pair2_mcf_x264_ucp.sh      p2_ucp    champsim_ucp_2c    605.mcf_s-665B.champsimtrace.xz      625.x264_s-18B.champsimtrace.xz      pair2_mcf_x264_ucp

# Pair 3
make_job batch_jobs/pair3_xalancbmk_gcc_lru.sh    p3_lru    champsim_lru_2c    623.xalancbmk_s-700B.champsimtrace.xz  602.gcc_s-734B.champsimtrace.xz   pair3_xalancbmk_gcc_lru
make_job batch_jobs/pair3_xalancbmk_gcc_static.sh p3_static champsim_static_2c 623.xalancbmk_s-700B.champsimtrace.xz  602.gcc_s-734B.champsimtrace.xz   pair3_xalancbmk_gcc_static
make_job batch_jobs/pair3_xalancbmk_gcc_ucp.sh    p3_ucp    champsim_ucp_2c    623.xalancbmk_s-700B.champsimtrace.xz  602.gcc_s-734B.champsimtrace.xz   pair3_xalancbmk_gcc_ucp

# Pair 4
make_job batch_jobs/pair4_omnetpp_bwaves_lru.sh    p4_lru    champsim_lru_2c    620.omnetpp_s-874B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair4_omnetpp_bwaves_lru
make_job batch_jobs/pair4_omnetpp_bwaves_static.sh p4_static champsim_static_2c 620.omnetpp_s-874B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair4_omnetpp_bwaves_static
make_job batch_jobs/pair4_omnetpp_bwaves_ucp.sh    p4_ucp    champsim_ucp_2c    620.omnetpp_s-874B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair4_omnetpp_bwaves_ucp

echo "Created 12 job files."
