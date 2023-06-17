# MetaPhlAn -- Species-level taxonomic analysis
!["Metaphlan4"](../figs/slurm-metaphlan/Slurm-family%20metaphlan.png)

## Brief description
This script will perform microbiome taxonomic analysis based on metagenomic datasets on a Slurm-based high-performance computing (HPC) system.<br>

**Syntax**
``` bash
run_mpa4_array_jobs.sh <FILENAME_LIST.txt> \
<CLEANED_READ_PATH> \
<MetaPhlAn_OUTPUT_PATH>
```

**Warning**: The script expects arguments to be provided in a specific order, and it will pass those arguments internally for processing.

## Steps to follow (around 1-hour learning journey)
First of first, please copy scripts `run_mpa4_array_jobs.sh` and `run_mpa4_per_sample_for_array_jobs.sh` to your desired folder.

### Step 1. Open & Edit `run_mpa4_array_jobs.sh`
For launching jobs on SLURM or other cluster-structured HPC, we config parameters inside the script for the merit of keeping parameter settings recorded. Therefore, we still know what parameters we used after many days, if not months, when the computation is completed. Here, we recommend two common editors for configuring the script:
* [VIM](https://www.vim.org/)
* [Visual Studio Code](https://code.visualstudio.com/)   

Only sections `Configure SLURM parameters` and MetaPhlan parameters in the`run_mpa4_per_sample_for_array_jobs.sh` should be configured and other codes should remain unchanged. Step-by-Step configuration will be explained at length in [Step 2](#step-2-allocate-appropriate-computational-sources) and [Step 3](#step-3-set-parameters-for-the-computational-tool). <br>

**Note:** Please update the path in line 33 of the `run_mpa4_array_jobs.sh` script to match your specific path for `run_mpa4_per_sample_for_array_jobs.sh`. To locate the line, look for the <span style="color:red;font-weight:bold;">line 33</span> within the script file.

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


### Step 3. Execute the script

```java
sbatch --qos long /vol/projects/user/script/slurm-metaphlan4-beta2/run_mpa4_array_jobs.sh \
/vol/projects/user/metaphlan/FileListRawNames.txt \
/vol/projects/user/metaphlan/filteredReads/CleanedRead/ \
/vol/projects/user/metaphlan/metaphlan_out/
```

**Please take a look for [FileListRawNames.txt](../demo_data/demo_file/FileListRawNames.txt)**

### Step 4. Check outputs
Once the MetaPhlAn4 is completed, in the `WorkingDir` 3 not-empty output files will be generated:

* `Sample_ID.bowtie2.bz2`
* `Sample_ID_profile.tsv`
* `Sample_ID.sam.bz2`

**Example for MetaPhlAn4 microbiome profiling: [metaphlan_profile.tsv](../demo_data/metaphlan_out/metaphlan_profile.tsv)**
_________________________________________
##### More information 
1. [MetaPhlAn User Guide](https://github.com/biobakery/MetaPhlAn)
2. [Bowtie output interpretation](https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml)