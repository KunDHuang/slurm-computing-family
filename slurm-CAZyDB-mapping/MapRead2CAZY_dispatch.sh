#!/usr/bin/env bash

##########################################################################################
####Master script of dispatching map_reads2CAZyDB jobs on SLURM with flexible version option####
##########################################################################################

VERSION="1.0.1"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
echo "SCRIPT DIRECTORY ::: $SCRIPT_DIR"

help_page () {
    echo ""
    echo "Pipeline version: v=$VERSION"
    echo "Usage: CAZY_dispatch.sh -i_file [input_file] -i_dir [input_dir] -o [output] -n [nproc]"
    echo ""
    echo " -i_file  A file in which each row indicates a sample identifier."
    echo " -i_dir   A folder holding FASTQ corresponding to sample identifiers in [-i_file]."
    echo " -o       A folder for holding output results."
    echo " -n       The number of processors to use. default = 15"
    echo " -mem     Specify the memory (Gb) in need. default = 24"
    echo " -time    Specify the walltime (hours). default = 2"
    echo " -log_dir Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)"
    echo " --help | -h   Show this help page"
    echo " !NOTE!: All inputs and outputs should be given with an absolute path!"
    echo "";
}

# set default parameters
n=25; i_file="false"; i_dir="false"; o="false"; time=2; mem=64; log_id=MapRead2CAZY; log_dir="/vol/cluster-data/khuang/slurm_logs"
while true; do
    case "$1" in
        -i_file) i_file=$2; shift 2;;
        -i_dir) i_dir=$2; shift 2;;
        -o) o=$2; shift 2;;
        -mem) mem=$2; shift 2;;
        -n) n=$2; shift 2;;
        -log_id) log_id=$2; shift 2;;
        -log_dir) log_dir=$2; shift 2;;
        -time) time=$2; shift 2;;
        -h | --help) help_page; exit 1; shift 1;;
        --) help_page; exit 1; shift; break ;;
        *) break;;
    esac
done

# Examine required parameters are entered
if [ "$i_file" = "false" ] || [ "$i_dir" = "false" ] || [ "$o" = "false" ]; then
    help_page
    echo "Error: Arguments are missing in -i_file [input_file], -i_dir[input_dir], -o [output]!"
    exit 1
fi

echo "logs will be saved in ${log_dir}..."
mkdir -p ${log_dir}



SLURM_JOBNAME=${log_id}_$(echo $(date +"%T") | sed "s/://g")_$(date +"%m-%y-%d")
SLURM_STDOUT="$log_dir"/%x_%j.out
SLURM_STDERR="$log_dir"/%x_%j.err
INPUT=$(readlink -f "$i_file")

send_jobs_to_slurm() {
    SLURM_ARRAY_LENGTH=$(cat "$i_file" | wc -l)
    sbatch --job-name=${SLURM_JOBNAME} --array=1-${SLURM_ARRAY_LENGTH} \
            --cpus-per-task=${n} --mem=${mem}g --time=${time}:00:00 \
            --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
            ${SCRIPT_DIR}/map_reads2CAZyDB_array_jobs.sh \
            ${INPUT} ${i_dir} ${o} ${n}
}

send_jobs_to_slurm
##########################################################################################
######################################### END ############################################
##########################################################################################