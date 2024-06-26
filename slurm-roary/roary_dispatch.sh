#!/usr/bin/env bash

##########################################################################################
####Master script of dispatching running roary jobs on SLURM according to input type######
##########################################################################################

VERSION="1.0.0"
PACKAGE_DIR="/vol/projects/khuang/repos/slurm-computing-family/slurm-roary"

help_page () {
    echo ""
    echo "Pipeline version: v=$VERSION"
    echo "Usage: roary_dispatch.sh -i [input] -o [output] -n [nproc]"
    echo ""
    echo " -i       A folder of input GFF files or a file in which each row indicates a folder containing GFF files."
    echo " -o       A folder for storing output results."
    echo " -id      Minimum percentage identity for blastp. Default: 95"
    echo " -n       The number of processors to use. Default: 20"
    echo " -cd      Percentage of isolates a gene must be in to be core. Default: 99"
    echo " -mem     Specify the memory in need. Default = 6, Gb"
    echo " -time    Specify the walltime. Default = 24, hours"
    echo " -log_dir Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)"
    echo " -log_id  Specify the identifiable label for log outputs."
    echo " --help | -h   Show this help page"
    echo " !NOTE!: Both input and output should be given with an absolute path!"
    echo "";
}

# set default parameters
n=20; id=95; i="false"; o="false"; time=24; mem=6; cpu=20; log_id=roary; cd=99
log_dir="/vol/cluster-data/khuang/slurm_logs"
while true; do
    case "$1" in
        -i) i=$2; shift 2;;
        -o) o=$2; shift 2;;
        -id) id=$2; shift 2;;
        -mem) mem=$2; shift 2;;
        -cd) cd=$2; shift 2;;
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
if [ "$i" = "false" ] || [ "$o" = "false" ]; then
    help_page
    echo "Error: inputs are missing in -i [input], -o [output]!"
    exit 1
fi

echo "logs will be saved in ${log_dir}..."
mkdir -p ${log_dir}



SLURM_JOBNAME=${log_id}_$(echo $(date +"%T") | sed "s/://g")_$(date +"%m-%y-%d")
SLURM_STDOUT="$log_dir"/%x_%j.out
SLURM_STDERR="$log_dir"/%x_%j.err
INPUT=$(readlink -f ${i})

send_jobs_to_slurm() {
    if [[ -d ${INPUT} ]]; then
        sbatch --job-name=${SLURM_JOBNAME} --array=1 \
             --cpus-per-task=${n} --mem=${mem}g --time=${time}:00:00 \
             --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
             ${PACKAGE_DIR}/roary_carrier.sh ${INPUT} ${o} ${id} ${cd} ${n}
    elif [[ -f ${INPUT} ]]; then
        SLURM_ARRAY_LENGTH=$(cat "$i" | wc -l)
        sbatch --job-name=${SLURM_JOBNAME} --array=1-${SLURM_ARRAY_LENGTH} \
             --cpus-per-task=${n} --mem=${mem}g --time=${time}:00:00 \
             --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
             ${PACKAGE_DIR}/roary_carrier.sh ${INPUT} ${o} ${id} ${cd} ${n}
    fi
}

send_jobs_to_slurm
##########################################################################################
######################################### END ############################################
##########################################################################################