#!/bin/bash

##########Configure SLURM parameters##########
#SBATCH --job-name=job_name
#SBATCH --array=1-6
#SBATCH --ntasks=1
#SBATCH --partition=cpu
#SBATCH --cluster=bioinf
#SBATCH --mem=1g
#SBATCH --time=01:00:00
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
    PO=$3 # a path to hold output stats, for example, /vol/projects/MIKI/Project-2022-RheumaVor/filteredReads/
fi


INPUT_FILENAME=$(awk "NR==${SLURM_ARRAY_TASK_ID}" ${SAMPLE_LIST})

Nr_R1_reads=$(expr $(zcat ${PR}/${INPUT_FILENAME}*R1*fastq.gz|wc -l) / 4)
Nr_R2_reads=$(expr $(zcat ${PR}/${INPUT_FILENAME}*R2*fastq.gz|wc -l) / 4)
Nr_total_reads=$(expr $Nr_R1_reads + $Nr_R2_reads)


Nr_R1_bases=$(zcat ${PR}/${INPUT_FILENAME}*R1*fastq.gz | paste - - - - | cut -f2 | wc -c)
Nr_R2_bases=$(zcat ${PR}/${INPUT_FILENAME}*R2*fastq.gz | paste - - - - | cut -f2 | wc -c)
Nr_total_bases=$(expr $Nr_R1_bases + $Nr_R2_bases)

avg_read1_length=$(expr $Nr_R1_bases / $Nr_R1_reads)
avg_read2_length=$(expr $Nr_R2_bases / $Nr_R2_reads)
avg_read_length=$(expr $Nr_total_bases / $Nr_total_reads)

OPT_FILE=${PO}/${INPUT_FILENAME}_stats.tsv


printf "Reads\tNr_reads\tNr_bases\tAvg_read_length\n" >> ${OPT_FILE}
printf "R1\t%s\t%s\t%s\t%s\n" ${Nr_R1_reads} ${Nr_R1_bases} ${avg_read1_length} >> ${OPT_FILE} 
printf "R2\t%s\t%s\t%s\t%s\n" ${Nr_R2_reads} ${Nr_R2_bases} ${avg_read2_length} >> ${OPT_FILE}
printf "Total\t%s\t%s\t%s\n" ${Nr_total_reads} ${Nr_total_bases} ${avg_read_length} >> ${OPT_FILE}


