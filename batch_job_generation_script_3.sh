cat > batch_jobs/create_all_2core_llc8w_jobs.sh <<'EOF'
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

# pair1 mcf + bwaves
make_job batch_jobs/pair1_mcf_bwaves_lru_llc8w.sh    p1_lru_8w    champsim_lru_2c_llc8w    605.mcf_s-665B.champsimtrace.xz      603.bwaves_s-3699B.champsimtrace.xz  pair1_mcf_bwaves_lru_llc8w
make_job batch_jobs/pair1_mcf_bwaves_static_llc8w.sh p1_static_8w champsim_static_2c_llc8w 605.mcf_s-665B.champsimtrace.xz      603.bwaves_s-3699B.champsimtrace.xz  pair1_mcf_bwaves_static_llc8w
make_job batch_jobs/pair1_mcf_bwaves_ucp_llc8w.sh    p1_ucp_8w    champsim_ucp_2c_llc8w    605.mcf_s-665B.champsimtrace.xz      603.bwaves_s-3699B.champsimtrace.xz  pair1_mcf_bwaves_ucp_llc8w

# pair2 mcf + x264
make_job batch_jobs/pair2_mcf_x264_lru_llc8w.sh      p2_lru_8w    champsim_lru_2c_llc8w    605.mcf_s-665B.champsimtrace.xz      625.x264_s-18B.champsimtrace.xz      pair2_mcf_x264_lru_llc8w
make_job batch_jobs/pair2_mcf_x264_static_llc8w.sh   p2_static_8w champsim_static_2c_llc8w 605.mcf_s-665B.champsimtrace.xz      625.x264_s-18B.champsimtrace.xz      pair2_mcf_x264_static_llc8w
make_job batch_jobs/pair2_mcf_x264_ucp_llc8w.sh      p2_ucp_8w    champsim_ucp_2c_llc8w    605.mcf_s-665B.champsimtrace.xz      625.x264_s-18B.champsimtrace.xz      pair2_mcf_x264_ucp_llc8w

# pair3 xalancbmk + gcc
make_job batch_jobs/pair3_xalancbmk_gcc_lru_llc8w.sh    p3_lru_8w    champsim_lru_2c_llc8w    623.xalancbmk_s-700B.champsimtrace.xz  602.gcc_s-734B.champsimtrace.xz   pair3_xalancbmk_gcc_lru_llc8w
make_job batch_jobs/pair3_xalancbmk_gcc_static_llc8w.sh p3_static_8w champsim_static_2c_llc8w 623.xalancbmk_s-700B.champsimtrace.xz  602.gcc_s-734B.champsimtrace.xz   pair3_xalancbmk_gcc_static_llc8w
make_job batch_jobs/pair3_xalancbmk_gcc_ucp_llc8w.sh    p3_ucp_8w    champsim_ucp_2c_llc8w    623.xalancbmk_s-700B.champsimtrace.xz  602.gcc_s-734B.champsimtrace.xz   pair3_xalancbmk_gcc_ucp_llc8w

# pair4 omnetpp + bwaves
make_job batch_jobs/pair4_omnetpp_bwaves_lru_llc8w.sh    p4_lru_8w    champsim_lru_2c_llc8w    620.omnetpp_s-874B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair4_omnetpp_bwaves_lru_llc8w
make_job batch_jobs/pair4_omnetpp_bwaves_static_llc8w.sh p4_static_8w champsim_static_2c_llc8w 620.omnetpp_s-874B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair4_omnetpp_bwaves_static_llc8w
make_job batch_jobs/pair4_omnetpp_bwaves_ucp_llc8w.sh    p4_ucp_8w    champsim_ucp_2c_llc8w    620.omnetpp_s-874B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair4_omnetpp_bwaves_ucp_llc8w

# pair5 mcf + gcc
make_job batch_jobs/pair5_mcf_gcc_lru_llc8w.sh    p5_lru_8w    champsim_lru_2c_llc8w    605.mcf_s-665B.champsimtrace.xz      602.gcc_s-734B.champsimtrace.xz      pair5_mcf_gcc_lru_llc8w
make_job batch_jobs/pair5_mcf_gcc_static_llc8w.sh p5_static_8w champsim_static_2c_llc8w 605.mcf_s-665B.champsimtrace.xz      602.gcc_s-734B.champsimtrace.xz      pair5_mcf_gcc_static_llc8w
make_job batch_jobs/pair5_mcf_gcc_ucp_llc8w.sh    p5_ucp_8w    champsim_ucp_2c_llc8w    605.mcf_s-665B.champsimtrace.xz      602.gcc_s-734B.champsimtrace.xz      pair5_mcf_gcc_ucp_llc8w

# pair6 omnetpp + x264
make_job batch_jobs/pair6_omnetpp_x264_lru_llc8w.sh    p6_lru_8w    champsim_lru_2c_llc8w    620.omnetpp_s-874B.champsimtrace.xz  625.x264_s-18B.champsimtrace.xz      pair6_omnetpp_x264_lru_llc8w
make_job batch_jobs/pair6_omnetpp_x264_static_llc8w.sh p6_static_8w champsim_static_2c_llc8w 620.omnetpp_s-874B.champsimtrace.xz  625.x264_s-18B.champsimtrace.xz      pair6_omnetpp_x264_static_llc8w
make_job batch_jobs/pair6_omnetpp_x264_ucp_llc8w.sh    p6_ucp_8w    champsim_ucp_2c_llc8w    620.omnetpp_s-874B.champsimtrace.xz  625.x264_s-18B.champsimtrace.xz      pair6_omnetpp_x264_ucp_llc8w

# pair7 xalancbmk + bwaves
make_job batch_jobs/pair7_xalancbmk_bwaves_lru_llc8w.sh    p7_lru_8w    champsim_lru_2c_llc8w    623.xalancbmk_s-700B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair7_xalancbmk_bwaves_lru_llc8w
make_job batch_jobs/pair7_xalancbmk_bwaves_static_llc8w.sh p7_static_8w champsim_static_2c_llc8w 623.xalancbmk_s-700B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair7_xalancbmk_bwaves_static_llc8w
make_job batch_jobs/pair7_xalancbmk_bwaves_ucp_llc8w.sh    p7_ucp_8w    champsim_ucp_2c_llc8w    623.xalancbmk_s-700B.champsimtrace.xz  603.bwaves_s-3699B.champsimtrace.xz  pair7_xalancbmk_bwaves_ucp_llc8w

echo "Created 21 LLC-8W job files."
EOF

chmod +x batch_jobs/create_all_2core_llc8w_jobs.sh
./batch_jobs/create_all_2core_llc8w_jobs.sh
