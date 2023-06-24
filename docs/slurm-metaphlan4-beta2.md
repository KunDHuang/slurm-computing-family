# MetaPhlAn -- Species-level taxonomic analysis
!["Metaphlan4"](../figs/slurm-metaphlan/Slurm-family%20metaphlan.png)

## Brief description
This utility will perform species-level microbiome taxonomic profiling on shotgun metagenomic samples leveraging a Slurm-based high-performance computing (HPC) system. The utility [slurm-metaphlan4-beta2](../slurm-metaphlan4-beta2) constitutes main script [run_mpa4_array_jobs.sh](../slurm-metaphlan4-beta2/run_mpa4_array_jobs.sh) which arranges a list of samples in an array and support script [run_mpa4_per_sample_for_array_jobs.sh](../slurm-metaphlan4-beta2/run_mpa4_per_sample_for_array_jobs.sh) which executes [MetaPhlAn](https://github.com/biobakery/MetaPhlAn) on each single sample. <br> 

**Syntax**
``` bash
sbatch run_mpa4_array_jobs.sh <FILENAME_LIST.txt> <CLEANED_READ_PATH> <OUTPUT_DIR_PATH>
```

**NOTE**: The script expects arguments to be provided in a fixed order as shown above, and all paths should be given as absolute paths.

## Steps to follow (around 1-hour learning journey)
First of first, please copy scripts [run_mpa4_array_jobs.sh](../slurm-metaphlan4-beta2/run_mpa4_array_jobs.sh) and [run_mpa4_per_sample_for_array_jobs.sh](../slurm-metaphlan4-beta2/run_mpa4_per_sample_for_array_jobs.sh) to your desired folder.

### Step 1. Open & Edit `run_mpa4_array_jobs.sh`
For launching jobs on SLURM or other cluster-structured HPC, we config parameters inside the script for the merit of keeping parameter settings recorded. Therefore, we still remember what parameters we used after many days, if not months, when the computation is completed. Here, we recommend two common editors for configuring the script:
* [VIM](https://www.vim.org/)
* [Visual Studio Code](https://code.visualstudio.com/)   

Only the section `Configure SLURM parameters` and MetaPhlan parameters in the [run_mpa4_per_sample_for_array_jobs.sh](../slurm-metaphlan4-beta2/run_mpa4_per_sample_for_array_jobs.sh) should be configured and other codes should remain unchanged. Step-by-Step configuration will be explained at length in [Step 2](#step-2-allocate-appropriate-computational-sources) and [Step 3](#step-3-set-parameters-for-the-computational-tool). <br>

**Note:** `run_mpa4_per_sample_for_array_jobs.sh` embedded in `run_mpa4_array_jobs.sh` is executed in the current working directory (i.e. `PWD`) by default. So if `run_mpa4_per_sample_for_array_jobs.sh` is stored somewhere else rather than current working directory please change the path accordingly.

### Step 2. Allocate appropriate computational sources
To ensure that appropriate computational sources (enough but not too much) will be used for computing your samples, please focus on section `Configuration SLURM parameters` as described in [preprocessing reads](./preprocessing_reads.md) <br>

#### Example parameter setting
``` css
##########Configure SLURM parameters##########
#SBATCH --job-name=metaphlan4         # Job name
#SBATCH --array=1-265                 # Total number of processes 
#SBARCH --nodes=1                     # Number of nodes
#SBATCH --ntasks=10                   # Number of tasks, referring to cores in the Slurm context
#SBATCH --partition=cpu               # Partition to queue the job
#SBATCH --output %x_%j.out            # stdout
#SBATCH --error %x_%j.err             # stderr
#SBATCH --cluster=bioinf
#SBATCH --mem=12g                     # memory needed per node
#SBATCH --time=10:00:00
##########Configure SLURM parameters##########
```
Code interpretation:
* `--job-name=metaphlan4`: The prefix of output and error logs will be *metaphlan4*.
* `--array=1-265`: 265 samples are submitted together and queued. 
* `--ntasks=10`: 10 cores will be allocated for running metaphlan for each sample.
* `--output %x_%j.out`: The file for storing standard output. As for `%x_%j.out`, it is a naming pattern for output file -- `x` and `j` are for constructing array job running IDs and `.out` is the file suffix.
* `--error %x_%j.err`: same as `--output` but for saving standard errors.
* `--mem=12`: 12 Gb memory will be allocated on one node for computing a sample.
* `--time=10:00:00`: 10 hours are set as wall time for completing computation for each sample. 

To change more SLURM parameters we suggest you to visit [Slurm tutorial](https://slurm.schedmd.com/tutorials.html) or [HZI HPC architecture](https://bioinfhead01.helmholtz-hzi.de/docs/index.html#).


### Step 3. Execute the script

```bash
sbatch run_mpa4_array_jobs.sh FileListRawNames.txt cleaned_reads_abspath mpa_output_abspath
```

**Please take a look for [FileListRawNames.txt](../demo_data/demo_file/FileListRawNames.txt)**

### Step 4. Check outputs
Once the MetaPhlAn4 is completed, in the `mpa_output_abspath` three not-empty output files will be generated:

* `Sample_ID.bowtie2.bz2`
* `Sample_ID_profile.tsv`
* `Sample_ID.sam.bz2`

**Example for MetaPhlAn4 microbiome profiling: [metaphlan_profile.tsv](../demo_data/metaphlan_out/metaphlan_profile.tsv)**
_________________________________________
##### More information 
1. [MetaPhlAn User Guide](https://github.com/biobakery/MetaPhlAn)
2. [Bowtie output interpretation](https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml)