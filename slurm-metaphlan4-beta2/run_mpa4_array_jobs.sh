#!/bin/bash

#SBATCH --job-name=mpa4_exp88-freiburg-read_stats
#SBATCH --array=1-265
#SBATCH --ntasks=10
#SBATCH --partition=cpu
#SBATCH --output /vol/cluster-data/khuang/slurm_stdout_logs/%x_%j.out
#SBATCH --error /vol/cluster-data/khuang/slurm_stderr_logs/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=40g
#SBATCH --time=10:00:00





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



INPUT_FILENAME=$(awk "NR==${SLURM_ARRAY_TASK_ID}" ${SAMPLE_LIST})
/vol/projects/khuang/repos/slurm-metaphlan4-beta2/run_mpa4_per_sample_for_array_jobs.sh ${INPUT_FILENAME} ${PR} ${PO}
