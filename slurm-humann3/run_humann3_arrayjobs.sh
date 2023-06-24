#!/bin/bash

##########Configure SLURM parameters##########
#SBATCH --job-name=humann3
#SBATCH --array=1-4
#SBATCH --ntasks=25
#SBATCH --partition=cpu
#SBATCH --output /vol/cluster-data/khuang/slurm_stdout_logs/%x_%j.out
#SBATCH --error /vol/cluster-data/khuang/slurm_stderr_logs/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=300G
#SBATCH --time=10-00:00:00
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


INPUT_FILENAME=$(awk "NR==${SLURM_ARRAY_TASK_ID}" ${SAMPLE_LIST})
${PWD}/run_humann3_per_sample.sh ${INPUT_FILENAME} ${PR} ${PO} ${SLURM_NTASKS}

