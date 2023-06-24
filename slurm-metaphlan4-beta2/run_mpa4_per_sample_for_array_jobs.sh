#!/bin/bash



if [ ! -z "$1" ]
then
    s=$1 # an identifier for a sample
fi
if [ ! -z "$2" ]
then
    pr=$2 # a path to cleaned reads, for example, /vol/projects/MIKI/Project-2022-RheumaVor/filteredReads/
fi
if [ ! -z "$3" ]
then
    po=$3 # a path to outputs, for example, /vol/projects/khuang/projects/rheumavor/
fi
if [ ! -z "$4" ]
then
    ncpu=$4 # CPUs use for each execution
fi

unset PYTHONPATH
. /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
conda activate metaphlan-4beta

mpa_version=`metaphlan --version | cut -f3 -d ' '`
mdb_version=mpa_vJan21_CHOCOPhlAnSGB_202103
ps=${po}/metaphlan-${mpa_version}_${mdb_version#*_}_read_stats/${s}
mkdir -p ${ps}

zcat `ls -1 ${pr}/${s}*fastq.gz | paste -sd ' ' -` | \
/vol/projects/khuang/anaconda3/envs/metaphlan-4beta/bin/metaphlan \
    --nproc ${ncpu} \
    --input_type fastq \
    --index ${mdb_version} \
    --force \
    -t rel_ab_w_read_stats \
    --sgb \
    --bowtie2out ${ps}/${s}.bowtie2.bz2 \
    --samout ${ps}/${s}.sam.bz2 \
    -o ${ps}/${s}_profile.tsv
