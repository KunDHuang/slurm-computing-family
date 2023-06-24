# HUMAnN3 -- Microbiome Functionality Analysis

!["HUMAnN3"](../figs/slurm-humann/Slurm-family%20humann3.jpg)


## Brief description
This script will perform microbiome functional analysis based on metagenomic or metatranscriptomic datasets on a Slurm-based high-performance computing (HPC) system. The utility [slurm-humann3](../slurm-humann3) constitutes main script [run_humann3_arrayjobs.sh](../slurm-humann3/run_humann3_arrayjobs.sh) which arranges a list of samples in an array and support script [run_humann3_per_sample.sh](../slurm-humann3/run_humann3_per_sample.sh) which executes [HUMAnN3](https://github.com/biobakery/humann) on each single sample. <br>

**Syntax**
``` bash
run_humann3_arrayjobs.sh <FILENAME_LIST.txt> <CLEANED_READ_PATH> <HUMANN_OUTPUT_PATH>
```

**Warning**: The script expects arguments to be provided in a specific order, and all arguments should be given with the absolute path.

## Steps to follow (around 1-hour learning journey)
First of first, please copy scripts [run_humann3_arrayjobs.sh](../slurm-humann3/run_humann3_arrayjobs.sh) and [run_humann3_per_sample.sh](../slurm-humann3/run_humann3_per_sample.sh) to your desired folder.

### Step 1. Open & Edit `run_humann3_arrayjobs.sh`
For launching jobs on SLURM or other cluster-structured HPC, we config parameters inside the script for the merit of keeping parameter settings recorded. Therefore, we still know what parameters we used after many days, if not months, when the computation is completed. Here, we recommend two common editors for configuring the script:
* [VIM](https://www.vim.org/)
* [Visual Studio Code](https://code.visualstudio.com/)   

Only sections `Configure SLURM parameters` and HUMAnN3 parameters in the `run_humann3_arrayjobs.sh` should be configured and other codes should remain unchanged. Step-by-Step configuration will be explained at length in [Step 2](#step-2-allocate-appropriate-computational-sources) and [Step 3](#step-3-set-parameters-for-the-computational-tool). <br>


**Note:** `run_humann3_per_sample.sh` embedded in `run_humann3_arrayjobs.sh` is executed in the current working directory (i.e. `PWD`) by default. So if `run_humann3_per_sample.sh` is stored somewhere else rather than current working directory please change the path accordingly.<br>

### Step 2. Allocate appropriate computational sources
To ensure that appropriate computational sources (enough but not too much) will be used for computing your samples, please focus on section `Configuration SLURM parameters` as described in [preprocessing reads](./preprocessing_reads.md) <br>

#### Example parameter setting
``` css
##########Configure SLURM parameters##########
#SBATCH --job-name=humann3                 # Job name
#SBATCH --array=1-4                        # Total number of processes
#SBATCH --ntasks=25                        # Number of tasks, referring to cores in the Slurm context
#SBATCH --partition=cpu                    # Partition to queue the job
#SBATCH --output %x_%j.out                 # stdout
#SBATCH --error %x_%j.err                  # stderr
#SBATCH --cluster=bioinf        
#SBATCH --mem=300G                         # stderr
#SBATCH --time=10-00:00:00                 # Walltime for running
##########Configure SLURM parameters##########
```
Code interpretation:

* `--job-name=humann3`: The prefix of output and error logs will be *humann3*.
* `--array=1-4`: 4 samples are submitted together and queued. 
* `--ntasks=10`: 10 cores will be allocated for running humann for each sample.
* `--output %x_%j.out`: The file for storing standard output. As for `%x_%j.out`, it is a naming pattern for output file -- `x` and `j` are for constructing array job running IDs and `.out` is the file suffix.
* `--error %x_%j.err`: same as `--output` but for saving standard errors.
* `--mem=300`: 300 Gb memory will be allocated on one node for computing a sample.
* `--time=10-00:00:00`: 10 days are set as wall time for completing computation for each sample. 

To change more SLURM parameters we suggest you to visit [Slurm tutorial](https://slurm.schedmd.com/tutorials.html) or [HZI HPC architecture](https://bioinfhead01.helmholtz-hzi.de/docs/index.html#).

<span style="color:#FF5733;font-weight:bold;"> Note: In some cases, the wall-time limit may be reached before the sample processing on the node is complete. As a result, only intermediate temporary files will be retained in the output. It is important to note that increasing the `number of CPUs per task (--cpus_per_task)` in Slurm can potentially expedite the running time of HUMAnN3.</span>

### Step 3. Execute the script

```bash
sbatch --qos long run_humann3_arrayjobs.sh FileListRawNames.txt cleaned_reads_abspath humann_output_abspath
```
##### Please take a look for [FileListRawNames.txt](../demo_data/demo_file/FileListRawNames.txt)

### Step 4. Check outputs
Once the HUMAnN3 is completed, in the `humann_output_abspath` three main output files and 15 intermediate temp output files will be generated:

**Three main output files:**
* `SampleID_genefamilies.tsv`
* `SampleID_pathabundance.tsv`
* `SampleID_pathcoverage.tsv`

**Example for HUMAnN [Three main output files](../demo_data/humann_out/)** <br>

**15 intermediate temp output files**
* `SampleID_bowtie2_aligned.sam `     
* `SampleID_bowtie2_unaligned.fa`
* `SampleID_bowtie2_aligned.tsv`      
* `SampleID_custom_chocophlan_database.ffn`
* `SampleID_bowtie2_index.1.bt2`      
* `SampleID_diamond_aligned.tsv`
* `SampleID_bowtie2_index.2.bt2`      
* `SampleID_diamond_unaligned.fa`
* `SampleID_bowtie2_index.3.bt2`      
* `SampleID.log`
* `SampleID_bowtie2_index.4.bt2`      
* `SampleID_metaphlan_bowtie2.txt`
* `SampleID_bowtie2_index.rev.1.bt2`  
* `SampleID_metaphlan_bugs_list.tsv`
* `SampleID_bowtie2_index.rev.2.bt2`

_________________________________________
##### More information 
1. [Slurm tutorial](https://slurm.schedmd.com/tutorials.html)
2. [HUMAnN3 User Guide](https://github.com/biobakery/humann)