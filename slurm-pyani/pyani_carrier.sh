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
    METHOD=$3 # The method for estimating 
fi
if [ ! -z "$4" ]
then
    NPROC=$4 # CPUs use for each execution
fi



unset PYTHONPATH
. /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
conda activate pyani-0.2.12

PYANI=/vol/projects/khuang/anaconda3/envs/pyani-0.2.12/bin/average_nucleotide_identity.py

if [[ -d ${INPUT} ]]; then
    ${PYANI} -i ${INPUT} -o ${OUTPUT} -g --gformat jpg -m ${METHOD} --workers ${NPROC}
    rm ${OUTPUT}/*.tar.gz
elif [[ -e ${INPUT} ]]; then
    CHILD_INPUT=$(awk "NR==${SLURM_ARRAY_TASK_ID}" ${INPUT})
    CHILD_OUTPUT=${OUTPUT}/$(basename ${CHILD_INPUT})
    ${PYANI} -i ${CHILD_INPUT} -o ${CHILD_OUTPUT} -g --gformat jpg -m ${METHOD} --workers ${NPROC}
    rm ${CHILD_OUTPUT}/*tar.gz
fi





