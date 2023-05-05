# Title: HUMAaN3 job submission ==> ***run_humann3_arrayjobs_metagenomic***

This script will perform microbiome functional analysis based on `metagenomic datasets` on a Slurm-based high-performance computing (HPC) system.<br>

The parameters in the script can be edited based on `project requirements`, `Output directory`, and `FastQ directory`. <br>

The script below is a template of the `run_humann3_arrayjobs.sh` <br>

**Syntax**
`run_humann3_arrayjobs.sh
<FILENAME_LIST.txt>
<CLEANED_READ_PATH>
<HUMANN_OUTPUT_PATH>` 

<br>


## SLURM parameter
_________________________________________

``` json
#SBATCH --job-name=Humann3_run
#SBATCH --array=1-4
#SBATCH --ntasks=25
#SBATCH --partition=cpu
#SBATCH --output <stdout_path>/%x_%j.out
#SBATCH --error <stderr_path>/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=300G
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

## Compiling: `run_humann3_arrayjobs.sh`
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

/vol/projects/khuang/repos/slurm-humann3/run_humann3_per_sample.sh ${INPUT_FILENAME} ${PR} ${PO}
```
<br>

The script will take 4 arguments including `{INPUT_FILENAME}, ${PR}, and ${PO}` and pass to `run_humann3_per_sample_metatrans.sh`.
1. `SAMPLE_LIST`: A file containing a list of sample identifiers, one per line.
2. `PR`: Path to the directory containing cleaned reads.
3. `PO`: Path to the directory where the outputs will be stored.

## Compiling: `run_humann3_per_sample.sh`
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
conda activate humann3
export PATH=/vol/biotools/bin:$PATH

ps=${po}humann3/${s}
mkdir -p ${ps}
humann_ipt=${ps}/${s}.fastq
zcat ${pr}${s}*fastq.gz > ${ps}/${s}.fastq

/vol/projects/khuang/anaconda3/envs/humann3/bin/humann --input ${humann_ipt} --threads 30 --memory-use maximum --output ${ps}

rm $humann_ipt
```
<br>

From the passed agruments, the script will process as steps below:

1. The script first checks if the provided command-line arguments are not empty and assigns them to appropriate variables:
- `s`: An identifier for a sample.
- `pr`: A path to the directory containing cleaned reads in `FastQ.gz` format.
- `po`: A path to the directory where the outputs will be stored.

2. The script then unsets the `PYTHONPATH` variable and activates the `humann3 conda environment`. 
<br>
3. The script adds the `/vol/biotools/bin` directory to the PATH environment variable to make sure the required bioinformatics tools are available.
<br>
4. The script creates the output directory for the current sample by combining the output path `(po)` and the sample identifier `(s)`, and stores it in the `ps` variable.
<br>
5. The script concatenates all the `FastQ.gz` files related to the sample identifier `(s)` found in the `pr` directory and writes the combined data into a single `FastQ` file in the sample's output directory `(ps)` stored as `humann_ipt`.
<br>
6. The script runs the `HUMAnN3` with the following options:
- `--input`: Specifies the input `FastQ` file in `(humann_ipt)`.
- `--threads`: Specifies the number of threads to be used `(30 in this case)`.
- `--memory-use`: Specifies the memory usage strategy `(maximum in this case)`.
- `--output`: Specifies the output directory `(ps)`.
<br>
7. Finally, the script removes the `FastQ` file in `humann_ipt` to clean up the temporary data.

## Combination of two scripts
_________________________________________

This script is a combination of `run_humann3_arrayjobs.sh` and `run_humann3_per_sample.sh` for functional analysis of metagenomic datasets.
<br>
The agruments and concepts are the same as separated scripts above.

```bash
#!/bin/bash

#SBATCH --job-name=Humann3_run
#SBATCH --array=1-4
#SBATCH --ntasks=25
#SBATCH --partition=cpu
#SBATCH --output <stdout_path>/%x_%j.out
#SBATCH --error <stderr_path>/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=300G
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

# Start of the second script
if [ ! -z "$INPUT_FILENAME" ]
then
    s=$INPUT_FILENAME # an identifier for a sample
fi
if [ ! -z "$PR" ]
then
    pr=$PR # a path to cleaned reads, for example, /vol/projects/MIKI/Project-2022-RheumaVor/filteredReads/
fi
if [ ! -z "$PO" ]
then
    po=$PO # a path to outputs, for example, /vol/projects/khuang/projects/rheumavor/
fi

unset PYTHONPATH
. /vol/projects/khuang/anaconda3/etc/profile.d/conda.sh
conda activate humann3
export PATH=/vol/biotools/bin:$PATH

ps=${po}humann3/${s}
mkdir -p ${ps}
humann_ipt=${ps}/${s}.fastq
zcat ${pr}${s}*fastq.gz > ${ps}/${s}.fastq

/vol/projects/khuang/anaconda3/envs/humann3/bin/humann --input ${humann_ipt} --threads 30 --memory-use maximum --output ${ps}

rm $humann_ipt

```

_________________________________________
##### More information 
1. [Slurm tutorial](https://slurm.schedmd.com/tutorials.html)
2. [HUMAnN3 User Guide](https://github.com/biobakery/humann)