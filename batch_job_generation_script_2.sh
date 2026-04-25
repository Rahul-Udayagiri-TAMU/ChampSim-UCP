mkdir -p batch_jobs

cat > batch_jobs/create_extra_2core_jobs.sh <<'EOF'
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

# Pair 5: mcf + gcc
make_job batch_jobs/pair5_mcf_gcc_lru.sh    p5_lru    champsim_lru_2c    605.mcf_s-665B.champsimtrace.xz      602.gcc_s-734B.champsimtrace.xz      pair5_mcf_gcc_lru
make_job batch_jobs/pair5_mcf_gcc_static.sh p5_static champsim_static_2c 605.mcf_s-665B.champsimtrace.xz      602.gcc_s-734B.champsimtrace.xz      pair5_mcf_gcc_static
make_job batch_jobs/pair5_mcf_gcc_ucp.sh    p5_ucp    champsim_ucp_2c    605.mcf_s-665B.champsimtrace.xz      602.gcc_s-734B.champsimtrace.xz      pair5_mcf_gcc_ucp

# Pair 6: omnetpp + x264
make_job batch_jobs/pair6_omnetpp_x264_lru.sh    p6_lru    champsim_lru_2c    620.omnetpp_s-874B.champsimtrace.xz  625.x264_s-18B.champsimtrace.xz      pair6_omnetpp_x264_lru
make_job batch_jobs/pair6_omnetpp_x264_static.sh p6_static champsim_static_2c 620.omnetpp_s-874B.champsimtrace.xz  625.x264_s-18B.champsimtrace.xz      pair6_omnetpp_x264_static
make_job batch_jobs/pair6_omnetpp_x264_ucp.sh    p6_ucp    champsim_ucp_2c    620.omnetpp_s-874B.champsimtrace.xz  625.x264_s-18B.champsimtrace.xz      pair6_omnetpp_x264_ucp

# Pair 7: xalancbmk + bwaves
make_job batch_jobs/pair7_xalancbmk_bwaves_lru.sh    p7_lru    champsim_lru_2c    623.xalancbmk_s-700B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair7_xalancbmk_bwaves_lru
make_job batch_jobs/pair7_xalancbmk_bwaves_static.sh p7_static champsim_static_2c 623.xalancbmk_s-700B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair7_xalancbmk_bwaves_static
make_job batch_jobs/pair7_xalancbmk_bwaves_ucp.sh    p7_ucp    champsim_ucp_2c    623.xalancbmk_s-700B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair7_xalancbmk_bwaves_ucp

echo "Created 9 extra job files."
EOF

chmod +x batch_jobs/create_extra_2core_jobs.sh
./batch_jobs/create_extra_2core_jobs.sh
