#!/usr/bin/env bash


if [ ! -z "$1" ]
then
    INPUT=$1 # A folder with an absolute path for input genomes
fi
if [ ! -z "$2" ]
then
    OUTPUT=$2 # A folder to hold output results 
fi
if [ ! -z "$3" ]
then
    ID=$3 # The identity threshold for blast 
fi
if [ ! -z "$4" ]
then
    CD=$4 # Percentage of isolates a gene must be in to be core
fi
if [ ! -z "$5" ]
then
    CPU=$5 # Number of CPUs to use
fi



unset PYTHONPATH
. /vol/projects/MIKI/lab_anaconda3/20240201_anaconda3/etc/profile.d/conda.sh
conda activate roary-3.13.0

ROARY=/vol/projects/MIKI/lab_anaconda3/20240201_anaconda3/envs/roary-3.13.0/bin/roary
export LC_ALL=C
if [[ -d ${INPUT} ]]; then
    ${ROARY} ${INPUT}/*.gff -f ${OUTPUT} -e -n -cd ${CD} -i ${ID} -p ${CPU}
elif [[ -e ${INPUT} ]]; then
    CHILD_INPUT=$(awk "NR==${SLURM_ARRAY_TASK_ID}" ${INPUT})
    BASENAME=$(basename ${CHILD_INPUT})
    CHILD_OUTPUT=${OUTPUT}/"${BASENAME%.*}"
    ${ROARY} ${CHILD_INPUT}/*.gff -f ${CHILD_OUTPUT} -e -n -cd ${CD} -i ${ID} -p ${CPU}
fi