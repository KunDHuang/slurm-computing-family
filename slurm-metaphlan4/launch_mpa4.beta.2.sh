#!/bin/bash

if [ ! -z "$1" ]
then
    INPUT=$1 # an identifier for a sample
fi
if [ ! -z "$2" ]
then
    READS_DIR=$2 # a path to cleaned reads, for example, /vol/projects/MIKI/Project-2022-RheumaVor/filteredReads/
fi
if [ ! -z "$3" ]
then
    OPT_DIR=$3 # a path to outputs, for example, /vol/projects/khuang/projects/rheumavor/
fi
if [ ! -z "$4" ]
then
    NCPU=$4 # CPUs use for each execution
fi

unset PYTHONPATH
. /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
conda activate metaphlan-4beta

CHILD_INPUT=$(awk "NR==${SLURM_ARRAY_TASK_ID}" ${INPUT})

MPA_VERSION=`metaphlan --version | cut -f3 -d ' '`
MDB_VERSION=mpa_vJan21_CHOCOPhlAnSGB_202103
OPT_DIR_SAMPLE=${OPT_DIR}/metaphlan-${MPA_VERSION}_${MDB_VERSION#*_}_read_stats/${s}
mkdir -p ${OPT_DIR_SAMPLE}

zcat `ls -1 ${READS_DIR}/${CHILD_INPUT}*fastq.gz | paste -sd ' ' -` | \
/vol/projects/khuang/anaconda3/envs/metaphlan-4beta/bin/metaphlan \
    --nproc ${NCPU} \
    --input_type fastq \
    --index ${MDB_VERSION} \
    --force \
    -t rel_ab_w_read_stats \
    --sgb \
    --bowtie2out ${OPT_DIR_SAMPLE}/${CHILD_INPUT}.bowtie2.bz2 \
    --samout ${OPT_DIR_SAMPLE}/${CHILD_INPUT}.sam.bz2 \
    -o ${OPT_DIR_SAMPLE}/${CHILD_INPUT}_profile.tsv
