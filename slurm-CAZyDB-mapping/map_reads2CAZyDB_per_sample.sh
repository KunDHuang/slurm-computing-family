#!/bin/bash

if [ ! -z "$1" ]
then
    S_ID=$1 # an identifier for a sample
fi
if [ ! -z "$2" ]
then
    PATH_READS=$2 # a path to cleaned reads, for example, /vol/projects/MIKI/Project-2022-RheumaVor/filteredReads/
fi
if [ ! -z "$3" ]
then
    PATH_OUT=$3 # a path to outputs, for example, /vol/projects/khuang/projects/rheumavor/
fi
if [ ! -z "$4" ]
then
    NCPU=$4 # CPUs use for each execution
fi

export LC_ALL=C
mkdir -p ${PATH_OUT}
CAZYDB_IDX="/vol/projects/khuang/databases/dbcan3/dbcan/CAZyDB.09242021.fa" # CAZyDB index for paladin
PALADIN_EXE="/vol/projects/khuang/tools/paladin/paladin" # executable paladin
MERGED_READS=${PATH_OUT}/${S_ID}_merged.fq
OPT_SID=${PATH_OUT}/${S_ID}
SAMTOOLS="/vol/biotools/bin/samtools"
PILEUP="/vol/cluster-data/trlesker/bbmap/pileup.sh"
zcat ${PATH_READS}/*${S_ID}*.fastq.gz > ${MERGED_READS}


${PALADIN_EXE} align -t ${NCPU} -C -n -a ${CAZYDB_IDX} ${MERGED_READS} | ${SAMTOOLS} view -Sb - > ${OPT_SID}.bam
${PILEUP} in=${OPT_SID}.bam covstats=${OPT_SID}.covstats 32bit=t overwrite=t 2> ${OPT_SID}.log2

sleep 15

rm ${MERGED_READS}.pro
rm ${MERGED_READS}



