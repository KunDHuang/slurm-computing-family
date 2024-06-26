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
    KINDOM=$3 # The kindon to annotate 
fi
if [ ! -z "$4" ]
then
    METAGENOME=$4 # The kindon to annotate 
fi
if [ ! -z "$5" ]
then
    NPROC=$5 # CPUs use for each execution
fi



unset PYTHONPATH
. /vol/projects/MIKI/lab_anaconda3/20240201_anaconda3/etc/profile.d/conda.sh
conda activate prokka-1.14.6

PROKKA=/vol/projects/MIKI/lab_anaconda3/20240201_anaconda3/envs/prokka-1.14.6/bin/prokka

if [[ -d ${INPUT} ]]; then
    INPUT_DIR=${INPUT}
    mkdir -p ${OUTPUT}
    for INPUT_FILE in ${INPUT_DIR}/*; do
        BASENAME=$(basename ${INPUT_FILE})
        PREFIX="${BASENAME%.*}"
        OUTPUT_DIR=${OUTPUT}/${PREFIX}."prokka"
        ${PROKKA} ${INPUT_FILE} --outdir ${OUTPUT_DIR} --cpus ${NPROC} --metagenome ${METAGENOME} \
              --prefix ${PREFIX} --compliant --kingdom ${KINDOM} --addgenes --addmrna
    done
    
elif [[ -e ${INPUT} ]]; then
    BASENAME=$(basename ${INPUT})
    PREFIX="${BASENAME%.*}"
    ${PROKKA} ${INPUT} --outdir ${OUTPUT} --cpus ${NPROC} --metagenome ${METAGENOME} \
              --prefix ${PREFIX} --compliant --kingdom ${KINDOM} --addgenes --addmrna
fi