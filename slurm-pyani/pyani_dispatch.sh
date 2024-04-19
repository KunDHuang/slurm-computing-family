#!/usr/bin/env bash

##########################################################################################
####Master script of dispatching running pyani jobs on SLURM according to input type######
##########################################################################################

VERSION="1.0.0"
PACKAGE_DIR="/vol/projects/khuang/repos/slurm-computing-family/slurm-pyani"

help_page () {
    echo ""
    echo "Pipeline version: v=$VERSION"
    echo "Usage: pyani_dispatch.sh -i [input] -o [output] -m [method] -n [nproc]"
    echo ""
    echo " -i       A directory of input genomes or a file of directory paths leading input genomes."
    echo " -o       A directory for storing output results."
    echo " -m       ANI estimating methods: ANIm/ANIb/ANIblastall. Default: ANIb."
    echo " -n       The number of processors to use. Default: 20"
    echo " -mem     Specify the memory in need. Default = 64, Gb"
    echo " -time    Specify the walltime. Default = 24, hours"
    echo " -log_dir Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)"
    echo " -log_id  Specify the identifiable label for log outputs."
    echo " --help | -h   Show this help page"
    echo " !NOTE!: Both input and output should be given with an absolute path!"
    echo "";
}

# set default parameters
n=20; m="ANIb"; i="false"; o="false"; time=24; mem=64; cpu=20; log_id=pyani
log_dir="/vol/cluster-data/khuang/slurm_logs"
while true; do
    case "$1" in
        -i) i=$2; shift 2;;
        -o) o=$2; shift 2;;
        -m) m=$2; shift 2;;
        -mem) mem=$2; shift 2;;
        -cpu) cpu=$2; shift 2;;
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
             --cpus-per-task=${cpu} --mem=${mem}g --time=${time}:00:00 \
             --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
             ${PACKAGE_DIR}/pyani_carrier.sh ${INPUT} ${o} ${m} ${cpu}
    elif [[ -f ${INPUT} ]]; then
        SLURM_ARRAY_LENGTH=$(cat "$i" | wc -l)
        sbatch --job-name=${SLURM_JOBNAME} --array=1-${SLURM_ARRAY_LENGTH} \
             --cpus-per-task=${cpu} --mem=${mem}g --time=${time}:00:00 \
             --error=${SLURM_STDERR} --output=${SLURM_STDOUT} \
             ${PACKAGE_DIR}/pyani_carrier.sh ${INPUT} ${o} ${m} ${cpu}
    fi
}

send_jobs_to_slurm
##########################################################################################
######################################### END ############################################
##########################################################################################