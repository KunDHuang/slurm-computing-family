#!/bin/bash

##########Configure SLURM parameters##########
#SBATCH --job-name=map_reads2CAZyDB
#SBATCH --array=1-232
#SBATCH --ntasks=10
#SBATCH --partition=cpu
#SBATCH --output /vol/cluster-data/khuang/slurm_stdout_logs/%x_%j.out
#SBATCH --error /vol/cluster-data/khuang/slurm_stderr_logs/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=10g
#SBATCH --time=4:00:00
##########Configure SLURM parameters##########




if [ ! -z "$1" ]
then
    SAMPLE_LIST=$1
fi
if [ ! -z "$2" ]
then
    PR=$2 # a path to cleaned reads, for example, /vol/projects/MIKI/Project-2022-RheumaVor/filteredReads/
fi
if [ ! -z "$3" ]
then
    PO=$3 # a path to outputs, for example, /vol/projects/khuang/projects/rheumavor/
fi


SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

INPUT_FILENAME=$(awk "NR==${SLURM_ARRAY_TASK_ID}" ${SAMPLE_LIST})
/vol/projects/khuang/repos/slurm-computing-family/slurm-CAZyDB-mapping/map_reads2CAZyDB_per_sample.sh ${INPUT_FILENAME} ${PR} ${PO} ${SLURM_NTASKS} 
# run_mpa4_per_sample_for_array_jobs.sh is executed in working dir by default so make sure it is placed in an executable path. Otherwise change accordingly. 
