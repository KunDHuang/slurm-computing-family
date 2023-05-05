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
    pt=$4 # a path to taxonomy profile folder
fi




unset PYTHONPATH
. /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
conda activate humann3
export PATH=/vol/biotools/bin:$PATH

ps=${po}humann3/${s}
pt_file=${pt}${s}_metaphlan_bugs_list.tsv
mkdir -p ${ps}
humann_ipt=${ps}/${s}.fastq
zcat ${pr}${s}*fastq.gz > ${ps}/${s}.fastq
/vol/projects/khuang/anaconda3/envs/humann3/bin/humann --input ${humann_ipt} --threads 30 --memory-use maximum --output ${ps} --taxonomic-profile ${pt_file}
rm $humann_ipt
