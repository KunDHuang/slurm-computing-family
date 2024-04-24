#!/usr/bin/env bash

##########################################################################################
####Master script of dispatching metaphlan4 jobs on SLURM with flexible version option####
##########################################################################################

VERSION="1.0.1"
PACKAGE_DIR="/vol/projects/khuang/repos/slurm-computing-family/slurm-metaphlan4"

help_page () {
    echo ""
    echo "Pipeline version: v=$VERSION"
    echo "Usage: metaphlan4_dispatch.sh -i_file [input_file] -i_dir [input_dir] -o [output] -n [nproc]"
    echo ""
    echo " -i_file  A file in which each row indicates a sample identifier."
    echo " -i_dir   A folder holding metagenomic reads corresponding to sample identifiers in [-i_file]."
    echo " -o       A folder for holding output results."
    echo " -v       Choose MetaPhlAn 4 version between [mpa4.beta.2] or [mpa4.1.0]. default = [mpa4.1.0]"
    echo " -n       The number of processors to use. default = 15"
    echo " -mem     Specify the memory (Gb) in need. default = 24"
    echo " -time    Specify the walltime (hours). default = 2"
    echo " -log_dir Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)"
    echo " -log_id  Specify the identifiable label for log outputs. default = mpa4_profiling"
    echo " --help | -h   Show this help page"
    echo " !NOTE!: All inputs and outputs should be given with an absolute path!"
    echo "";
}

# set default parameters
n=15; i_file="false"; i_dir="false"; o="false"; time=2; mem=24; v="mpa4.1.0"; log_id=mpa4_profiling; log_dir="/vol/cluster-data/khuang/slurm_logs"
while true; do
    case "$1" in
        -i_file) i_file=$2; shift 2;;
        -i_dir) i_dir=$2; shift 2;;
        -o) o=$2; shift 2;;
        -mem) mem=$2; shift 2;;
        -n) n=$2; shift 2;;
        -v) v=$2; shift 2;;
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
    if [[ "$v" = "mpa4.beta.2" ]]; then
        SLURM_ARRAY_LENGTH=$(cat "$i_file" | wc -l)
        sbatch --job-name=${SLURM_JOBNAME} --array=1-${SLURM_ARRAY_LENGTH} \
             --cpus-per-task=${n} --mem=${mem}g --time=${time}:00:00 \
             --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
             ${PACKAGE_DIR}/launch_mpa4.beta.2.sh ${INPUT} ${i_dir} ${o} ${n}
    elif [[ "$v" = "mpa4.1.0" ]]; then
        SLURM_ARRAY_LENGTH=$(cat "$i_file" | wc -l)
        sbatch --job-name=${SLURM_JOBNAME} --array=1-${SLURM_ARRAY_LENGTH} \
             --cpus-per-task=${n} --mem=${mem}g --time=${time}:00:00 \
             --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
             ${PACKAGE_DIR}/launch_mpa4.1.0.sh ${INPUT} ${i_dir} ${o} ${n}
    else
        echo "choose version: [mpa4.beta.2] or [mpa4.1.0]"
        exit 1
    fi
}

send_jobs_to_slurm
##########################################################################################
######################################### END ############################################
##########################################################################################