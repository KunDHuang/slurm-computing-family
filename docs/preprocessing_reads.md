# Preprocessing metagenomic reads with `preprocessing_reads.sh`

!["Title"](../figs/slurm-preprocessing/overall_workflow.png)


## Brief description
This manual is for preprocessing metagenomic reads sequenced by Illumina and performinng basic statistics for output preprocessed reads. Preprocessing procedure includes filtering out host DNA, removing low-quality reads and trimming adapters. <br>


## Environment preparation

#### Dependency
- **[BBDuk](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/)**
- **[BBMap](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/)**


NOTE: *You can skip environment preparation if you are working on HZI servers.*


## Steps to follow (around 1-hour learning journey)
First of first, please copy scripts `preprocessing_reads.sh` and `reads_stats.sh` to your desired folder.

### Step 1. Open & Edit `preprocessing_reads.sh`
For launching jobs on SLURM or other cluster-structured HPC, we config parameters inside the script for the merit of keeping parameter settings recorded. Therefore, we still know what parameters we used after many days, if not months, when the computation is completed. Here, we recommend two common editors for configuring the script:
* [VIM](https://www.vim.org/)
* [Visual Studio Code](https://code.visualstudio.com/)   

Only sections `Configure SLURM parameters` and `Configure tool parameters` should be configured and other codes should remain unchanged. Step-by-Step configuration will be explained at length in [Step 2](#step-2-allocate-appropriate-computational-sources) and [Step 3](#step-3-set-parameters-for-the-computational-tool).
### Step 2. Allocate appropriate computational sources
To ensure that appropriate computational sources (enough but not too much) will be used for computing your samples, please focus on section `Configuration SLURM parameters` as elaborated below.

`Configuration SLURM parameters` section looks like:
```
##########Configure SLURM parameters##########
#SBATCH --job-name=<job_name>
#SBATCH --array=<i-j%n>   
#SBATCH --ntasks=<n_cpus> 
#SBATCH --partition=cpu # fixed parameter
#SBATCH --output <path_for_output_log>
#SBATCH --error <path_for_error_log>
#SBATCH --clusters=bioinf # fixed parameter
#SBATCH --mem=<XXg>
#SBATCH --time=<HH:MM:SS> # wall time, e.g., 2:00:00 for 2 hours needed to complete running for each sample 
##########Configure SLURM parameters##########
```

| Flag | Description  |
|:----    |:----    |
| `--job-name` | Job name; e.g., `--job-name=six_metagenome_samples` |
| `--array` | Number of samples submitted to the array job; e.g., `--array=1-6%2` -- we submit a total of 6 samples but only 2 samples were computed in parallel each time instead of 6 all together.|
| `--ntasks` |    Number of CPUs for each sample; e.g., `--ntasks=4` -- 4 CPUs were allocated to each sample (8 CPUs will be used simultaneously if 2 samples were computed in parallel)    |
| `--partition` |    Where the job to be executed (CPU or GPU); [CPU] by default     |
| `--output` |    Location for standard output (stdout) log, *slurm report*, of the job; It is suggested to redirect the logs to a stable path, e.g., `/vol/cluster-data/khuang/slurm_stdout_logs/` where user `khuang` stores his output logs. |
| `--error` |    Location for standard error (stderr) log, *slurm report*, of the job; it is suggested to redirect the logs to a stable path, e.g., `/vol/cluster-data/khuang/slurm_stderr_logs/` where user `khuang` stores his error logs. |
| `--clusters` |    Hardware cluster name for job execution; [bioinf] by default  |
| `--mem` |    The total amount of memory allocated for simultaneouly-computed samples; e.g. `88g` - 88 Gb memory will be used    |
| `--time` |    The maximum time limit for the job to complete |


**Note:** 
- `--array` and `--ntask` should be fitted to the number of samples to be processed.
- `--time` should be fitted to the time usage of the tools.

An example configuration:
```
##########Configure SLURM parameters##########
#SBATCH --job-name=my_first_six_samples
#SBATCH --array=1-6%2   
#SBATCH --ntasks=10 
#SBATCH --partition=cpu # fixed parameter
#SBATCH --output /vol/cluster-data/khuang/slurm_stdout_logs/%x_%j.out
#SBATCH --error /vol/cluster-data/khuang/slurm_stderr_logs/%x_%j.err
#SBATCH --clusters=bioinf # fixed parameter
#SBATCH --mem=88g
#SBATCH --time=2:00:00 
##########Configure SLURM parameters##########
```
Code interpretation:
* `--job-name=my_first_six_samples`: The prefix of output and error logs will be *my_first_six_sample*.
* `--array=1-6%2`: 6 samples are submitted together but only 2 samples will be computed simultaneously following a batch-by-batch style. This can prevent HPC from being crushed by computing too many samples at the same time. 
* `--ntasks=10`: 10 CPUs will be used for each sample. Of note, not for six samples.
* `--output /vol/cluster-data/khuang/slurm_stdout_logs/%x_%j.out`: User `khuang` used path `/vol/cluster-data/khuang/slurm_stdout_logs` for storing output logs. As for `%x_%j.out`, it is a naming pattern for output file -- `x` and `y` are for constructing array job running IDs and `.out` is the suffix, e.g., `my_first_six_samples_2283.aa_973282.out`.
* `--error`: same as `--output`.
* `--mem=88g`: 88 Gb memory will be requested for computing 2 samples in parallel.
* `--time=2:00:00`: 2 hours are set as wall time for completing computation for each sample. 

To change more SLURM parameters we suggest you to visit [Slurm tutorial](https://slurm.schedmd.com/tutorials.html) or [HZI HPC architecture](https://bioinfhead01.helmholtz-hzi.de/docs/index.html#).

### Step 3. Set parameters for the computational tool
Having allocated appropriate computational sources, we now need to config parameters to run the computational tool which has been mounted on the SLURM editing the section of `Configure tool parameters`.

```
##########Configure tool parameters##########
usedCores=<n_cpus>
WorkingDir=<working_dir>
RefDir=<human_ref_dir>
FileListR1=<R1_reads_file>
FileListR2=<R2_reads_file>
FileListNames=<sample_name_file>
##########Configure SLURM parameters##########
```    
| Flag | Description  |
|:----    |:----    |
| `usedCores` | The number of CPUs to use. |
| `WorkingDir` | The working directory (absolute path).|
| `RefDir` |    The input directory hosting human reference genome (absolute path).    |
| `FileListR1` |  The input file which contains absolute paths for R1 reads files, each file taking one row. Check the [example file](../demo_data/slurm-preprocessing/FileListR1.txt).|
| `FileListR2` |  The input file which contains absolute paths for R2 reads files, each file taking one row. Check the [example file](../demo_data/slurm-preprocessing/FileListR2.txt).|
| `FileListNames` | The input file which contains identifiable names of samples, each name taking one row. Check the [example file](../demo_data/slurm-preprocessing/FileListNames.txt).|

An example configuration:
```
##########Configure tool parameters##########
usedCores=10
WorkingDir=/vol/projects/khuang/repo_demo/slurm-computing-family/preprocessing_reads_demo/filteredReads
RefDir=/vol/projects/trlesker/filtering/ref-human-mask
FileListR1=/vol/projects/khuang/repo_demo/slurm-computing-family/preprocessing_reads_demo/FileListR1.txt
FileListR2=/vol/projects/khuang/repo_demo/slurm-computing-family/preprocessing_reads_demo/FileListR2.txt
FileListNames=/vol/projects/khuang/repo_demo/slurm-computing-family/preprocessing_reads_demo/FileListNames.txt
##########Configure tool parameters###########
```
Everything has been set in the folder `/vol/projects/khuang/repo_demo/slurm-computing-family/preprocessing_reads_demo` for demostration, MIKI members can access for more details. 
### Step 4. Run `preprocessing_reads.sh`
To launch the `preprocessing_reads.sh` that has been configured accordingly:
```
sbatch preprocessing_reads.sh
```


### Step 5. Check outputs
Once the preprocessing is completed, in the `WorkingDir` seven not-empty output files will be generated:
 * `<sample_name>_cleaned_R1.fastq.gz`
 * `<sample_name>_cleaned_R2.fastq.gz`
 * `<sample_name>_contaminant_filtering_ref.stats`
 * `<sample_name>_truseq.stats`
 * `<sample_name>_truseq_ref.stats`
 * `bbduk-<sample_name>.log`
 * `bbmap-<sample_name>.log`

To make sure that eveyrthing went well, we also need to check log files produced from SLURM:
 * `<job_name>_<job_id>.out`
 For example,
```
########################################
#            Job Accounting            #
########################################
Name                : my_first_six_samples
User                : khuang
Account             : miki
Partition           : cpu
QOS                 : normal
NNodes              : 1
Nodes               : bioinf016
Cores               : 20
GPUs                : 0
State               : COMPLETED
ExitCode            : 0:0
Submit              : 2023-05-27T04:35:30
Start               : 2023-05-27T04:35:31
End                 : 2023-05-27T04:52:33
Waited              : 00:00:00
Reserved walltime   : 02:00:00
Used walltime       : 00:17:02
Used CPU time       : 02:57:19 (Efficiency: 52.05%)
% User (Computation): 98.91%
% System (I/O)      :  1.09%
Mem reserved        : 88G
Max Mem used        : 16.02G (bioinf016)
Max Disk Write      : 33.59G (bioinf016)
Max Disk Read       : 33.52G (bioinf016)
```  
* `<job_name>_<job_id>.err`
This file should be empty if no errors occured.



### Step 6. Statistics analysis for preprocessed reads
To perform basic stats for preprocessed reads, including the number of reads, the number of bases and averaged read length, we can use script `reads_stats.sh`. 

Please revisit [Step 2](#step-2-allocate-appropriate-computational-sources) to learn how to allocate computational sources.
Here, no need to configure parameters for computational tool, so we just launch the script:
```
sbatch reads_stats.sh <file_list_names> <preprocessed_reads_folder> <output_folder>
```

* `<file_list_names>`: The same file used in `FileListNames` in [Step 3](#step-3-set-parameters-for-the-computational-tool).
* `<preprocessed_reads_foler>`: The folder containing the preprocessed reads, which should be the same folder specified for `WorkingDir` in [Step 3](#step-3-set-parameters-for-the-computational-tool). Note: using absolute path.
* `<output_folder>`: Specify the folder for holding output stats. Note: using absolute path.

The output looks like:

| Reads | Nr_reads  | Nr_bases| Avg_read_length|
|:----    |:----    | :----| :----|
| R1 | 21141749 | 3208936193 | 151 |
| R2 | 21141749 | 3213441923 | 151 |







