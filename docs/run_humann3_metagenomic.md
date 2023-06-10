# HUMAnN3 -- Gene-level analysis

!["HUMAnN3"](../figs/slurm-humann/Slurm-family%20humann3.jpg)


## Brief description
This script will perform microbiome functional analysis based on `metagenomic or metatranscriptomic datasets` on a Slurm-based high-performance computing (HPC) system. <br>

**Syntax**
`run_humann3_arrayjobs.sh
<FILENAME_LIST.txt>
<CLEANED_READ_PATH>
<HUMANN_OUTPUT_PATH>`  <br>

**Warning**: The script expects arguments to be provided in a specific order, and it will pass those arguments internally for processing.

## Steps to follow (around 1-hour learning journey)
First of first, please copy scripts `run_humann3_arrayjobs.sh` and `run_humann3_per_sample.sh` to your desired folder.

### Step 1. Open & Edit `run_humann3_arrayjobs.sh`
For launching jobs on SLURM or other cluster-structured HPC, we config parameters inside the script for the merit of keeping parameter settings recorded. Therefore, we still know what parameters we used after many days, if not months, when the computation is completed. Here, we recommend two common editors for configuring the script:
* [VIM](https://www.vim.org/)
* [Visual Studio Code](https://code.visualstudio.com/)   

Only sections `Configure SLURM parameters` and `Configure tool parameters` should be configured and other codes should remain unchanged. Step-by-Step configuration will be explained at length in [Step 2](#step-2-allocate-appropriate-computational-sources) and [Step 3](#step-3-set-parameters-for-the-computational-tool). <br>

**Note:** Please update the path in line 29 of the `run_humann3_arrayjobs.sh` script to match your specific path for `run_humann3_per_sample.sh`. To locate the line, look for the <span style="color:red;font-weight:bold;">line 29</span> within the script file.

### Step 2. Allocate appropriate computational sources
To ensure that appropriate computational sources (enough but not too much) will be used for computing your samples, please focus on section `Configuration SLURM parameters` as described in [preprocessing reads](./preprocessing_reads.md) <br>

#### Example parameter setting
``` css
##########Configure SLURM parameters##########
#SBATCH --job-name=metaphlan4
#SBATCH --array=1-265
#SBATCH --ntasks=10
#SBATCH --ntasks-per-core=20
#SBATCH --partition=cpu
#SBATCH --output /vol/projects/names/log/%x_%j.out
#SBATCH --error /vol/projects/names/log/%x_%j.err
#SBATCH --cluster=bioinf
#SBATCH --mem=64g
#SBATCH --time=10:00:00
##########Configure SLURM parameters##########
```
Code interpretation:
* `--job-name=metaphlan4`: The prefix of output and error logs will be *metaphlan4*.
* `--array=1-265`: 265 samples are submitted together and queued. 
* `--ntasks=10`: 10 samples will be computed simultaneously, if the resource is sufficient.
* `--ntasks-per-core=20`: 20 CPUs will be used for each sample.
* `--output /vol/projects/names/log/%x_%j.out`: User `names` used path `/vol/projects/names/log/` for storing output logs. As for `%x_%j.out`, it is a naming pattern for output file -- `x` and `j` are for constructing array job running IDs and `.out` is the suffix.
* `--error`: same as `--output`.
* `--mem=64`: 64 Gb memory will be requested for computing 10 samples in parallel.
* `--time=10:00:00`: 10 hours are set as wall time for completing computation for each sample. 

To change more SLURM parameters we suggest you to visit [Slurm tutorial](https://slurm.schedmd.com/tutorials.html) or [HZI HPC architecture](https://bioinfhead01.helmholtz-hzi.de/docs/index.html#).

<span style="color:#FF5733;font-weight:bold;"> Note: In some cases, the wall-time limit may be reached before the sample processing on the node is complete. As a result, only intermediate temporary files will be retained in the output. It is important to note that increasing the `number of CPUs per task` in Slurm can potentially expedite the running time of HUMAnN3.</span>

### Step 3. Execute the script

```java
sbatch --qos long /vol/projects/user/script/humann3/run_humann3_arrayjobs.sh \
/vol/projects/user/reads/FileListRawNames.txt \
/vol/projects/user/reads/filteredRead/ \
/vol/projects/user/reads/Humann3_out/
```
##### Please take a look for [FileListRawNames.txt](../demo_data/demo_file/FileListRawNames.txt)

### Step 4. Check outputs
Once the HUMAnN3 is completed, in the `WorkingDir` 3 main output files and 15 intermediate temp output files will be generated:

**3 main output files:**
* `SampleID_genefamilies.tsv`
* `SampleID_pathabundance.tsv`
* `SampleID_pathcoverage.tsv`

**Example for HUMAnN [3 main output files](../demo_data/humann_out/)** <br>

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