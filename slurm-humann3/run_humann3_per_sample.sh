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
    ncpu=$4 # the number of CPUs to use
fi




unset PYTHONPATH
. /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
conda activate humann3
export PATH=/vol/biotools/bin:$PATH

ps=${po}/humann3/${s}
mkdir -p ${ps}
humann_ipt=${ps}/${s}.fastq
zcat ${pr}/${s}*fastq.gz > ${ps}/${s}.fastq
/vol/projects/khuang/anaconda3/envs/humann3/bin/humann --input ${humann_ipt} --threads ${ncpu} --memory-use maximum --output ${ps}
rm $humann_ipt
