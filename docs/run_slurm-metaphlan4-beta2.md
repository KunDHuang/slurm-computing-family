# Title: MetaPhlAn job submission ==> ***run_humann3_arrayjobs_metagenomic***

This script will perform microbiome taxonomic analysis based on `metagenomic datasets` on a Slurm-based high-performance computing (HPC) system.<br>

The parameters in the script can be edited based on `project requirements`, `Output directory`, and `FastQ directory`. <br>

The script below is a template of the `run_mpa4_array_jobs.sh` <br>

**Syntax**
`run_mpa4_array_jobs.sh
<FILENAME_LIST.txt>
<CLEANED_READ_PATH>
<MetaPhlAn_OUTPUT_PATH>` 

<br>


## SLURM parameter
_________________________________________

``` json
#SBATCH --job-name=MetaPhlAn_run
#SBATCH --array=1-4
#SBATCH --ntasks=25
#SBATCH --partition=cpu
#SBATCH --output <stdout_path>/%x_%j.out
#SBATCH --error <stderr_path>/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=40
#SBATCH --time=10-00:00:00
```

| Component | Description  |
|:----    |:----    |
| --job-name | Job name    |
| --array | Number of array job (i.e., `#SBATCH --array=1-20` ==> we submit an array job with 20 tasks and 4 groups.)|
| --ntasks |    Number of tasks to be executed in parallel    |
| --partition |    Where the job to be executed (CPU or GPU)    |
| --output |    Location for standard output (stdout) log, *slurm report*, of the job    |
| --error |    Location for standard error (stderr) log, *slurm report*, of the job     |
| --clusters |    Harware cluster name for job execution   |
| --mem |    The amount of memory required for each task    |
| --time |    The maximum time limit for the job to complete |
<br>

## Compiling: `run_mpa4_array_jobs.sh`
_________________________________________

```bash
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

/vol/projects/khuang/repos/slurm-metaphlan4-beta2/run_mpa4_per_sample_for_array_jobs.sh ${INPUT_FILENAME} ${PR} ${PO}
```
<br>

The script will take 4 arguments including `{INPUT_FILENAME}, ${PR}, and ${PO}` and pass to `run_mpa4_per_sample_for_array_jobs.sh`.
1. `SAMPLE_LIST`: A file containing a list of sample identifiers, one per line.
2. `PR`: Path to the directory containing cleaned reads.
3. `PO`: Path to the directory where the outputs will be stored.

## Compiling: `run_mpa4_per_sample_for_array_jobs.sh`
_________________________________________

```bash
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

unset PYTHONPATH
. /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
conda activate metaphlan-4beta

mpa_version=`metaphlan --version | cut -f3 -d ' '`
mdb_version=mpa_vJan21_CHOCOPhlAnSGB_202103
ps=${po}metaphlan-${mpa_version}_${mdb_version#*_}_read_stats/${s}
mkdir -p ${ps}

zcat `ls -1 ${pr}${s}*fastq.gz | paste -sd ' ' -` | \
/vol/projects/khuang/anaconda3/envs/metaphlan-4beta/bin/metaphlan \
    --nproc 10 \
    --input_type fastq \
    --index ${mdb_version} \
    --force \
    -t rel_ab_w_read_stats \
    --sgb \
    --bowtie2out ${ps}/${s}.bowtie2.bz2 \
    --samout ${ps}/${s}.sam.bz2 \
    -o ${ps}/${s}_profile.tsv

```
<br>

From the passed agruments, the script will process as steps below:

1. The script first checks if the provided command-line arguments are not empty and assigns them to appropriate variables:
- `s`: An identifier for a sample.
- `pr`: A path to the directory containing cleaned reads in `FastQ.gz` format.
- `po`: A path to the directory where the outputs will be stored.
2. Unset the `PYTHONPATH` environment variable and activate the metaphlan-4beta conda environment.
3. Get the version of MetaPhlAn and the version of the MetaPhlAn database, then set the output directory `(ps=${po}metaphlan-${mpa_version}_${mdb_version#*_}_read_stats/${s})` for the results based on the provided output path, the tool version, and the database version.
4. The script concatenates all `FastQ.gz` files associated with the sample and pipes the output directly to MetaPhlAn. This will provide 3 output file types in `${s}`:
- `${s}.bowtie2.bz2` file
- `${s}.sam.bz2` file
- `${s}_profile.tsv` file. This is taxonomic profile.


## Combination of two scripts
_________________________________________

This script is a combination of `run_mpa4_array_jobs.sh` and `run_mpa4_per_sample_for_array_jobs.sh` for taxonomic analysis of metagenomic datasets.
<br>
The agruments and concepts are the same as separated scripts above.

```bash
#!/bin/bash

#SBATCH --job-name=MetaPhlAn_run
#SBATCH --array=1-365
#SBATCH --ntasks=25
#SBATCH --partition=cpu
#SBATCH --output <stdout_path>/%x_%j.out
#SBATCH --error <stderr_path>/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=40G
#SBATCH --time=10-00:00:00


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

# Run the second script as a function
run_mpa4_per_sample() {
    s=$1
    pr=$2
    po=$3

    unset PYTHONPATH
    . /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
    conda activate metaphlan-4beta

    mpa_version=`metaphlan --version | cut -f3 -d ' '`
    mdb_version=mpa_vJan21_CHOCOPhlAnSGB_202103

    ps=${po}metaphlan-${mpa_version}_${mdb_version#*_}_read_stats/${s}
    mkdir -p ${ps}

    zcat `ls -1 ${pr}${s}*fastq.gz | paste -sd ' ' -` | \
    /vol/projects/khuang/anaconda3/envs/metaphlan-4beta/bin/metaphlan \
        --nproc 10 \
        --input_type fastq \
        --index ${mdb_version} \
        --force \
        -t rel_ab_w_read_stats \
        --sgb \
        --bowtie2out ${ps}/${s}.bowtie2.bz2 \
        --samout ${ps}/${s}.sam.bz2 \
        -o ${ps}/${s}_profile.tsv
}

run_mpa4_per_sample ${INPUT_FILENAME} ${PR} ${PO}

```

_________________________________________
##### More information 
1. [Slurm tutorial](https://slurm.schedmd.com/tutorials.html)
2. [MetaPhlAn User Guide](https://github.com/biobakery/MetaPhlAn)