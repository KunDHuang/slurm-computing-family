# Taxonomic Profiling using MetaPhlAn4 
!["Metaphlan4"](../figs/slurm-metaphlan/Slurm-family%20metaphlan.png)

## Brief description
This module allows to launch species-level microbiome taxonomic profiling on many shotgun metagenomic samples simultaneously. The master script [metaphlan4_dispatch.sh](../slurm-metaphlan4/metaphlan4_dispatch.sh) arranges a list of samples and send them all to SLURM HPC clusters for [MetaPhlAn4](https://github.com/biobakery/MetaPhlAn) profiling with a flexible version choice (currently `4.beta.2` and `4.1.0` available). <br> 

**Usage**
```
$ PATH_TO_PACKAGE/slurm-computing-family/slurm-metaphlan4/metaphlan4_dispatch.sh -h

Pipeline version: v=1.0.1
Usage: metaphlan4_dispatch.sh -i_file [input_file] -i_dir [input_dir] -o [output] -n [nproc]

 -i_file  A file in which each row indicates a sample identifier.
 -i_dir   A folder holding metagenomic reads corresponding to sample identifiers in [-i_file].
 -o       A folder for holding output results.
 -v       Choose MetaPhlAn 4 version between [mpa4.beta.2] or [mpa4.1.0]. default = [mpa4.1.0]
 -n       The number of processors to use. default = 15
 -mem     Specify the memory (Gb) in need. default = 24
 -time    Specify the walltime (hours). default = 2
 -log_dir Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)
 -log_id  Specify the identifiable label for log outputs. default = mpa4_profiling
 --help | -h   Show this help page
 !NOTE!: All inputs and outputs should be given with an absolute path!

```

**Quick start**
``` bash
metaphlan4_dispatch.sh -i_file sample_ids.txt -i_dir metagenomic_samples_dir -o collective_output_folder
```

**NOTE**: Absolute paths should be given !


**Required inputs**

* `sample_ids.txt`
* `metagenomic_samples_dir`
* `collective_output_folder`

**Naming pattern of outputs**

* `Sample_ID.bowtie2.bz2`
* `Sample_ID_profile.tsv`
* `Sample_ID.sam.bz2`
* `Sample_ID_vsc.txt` (if version `mpa4.1.0` was chosen)

**Some examples**

You can find example inputs and outputs in this folder:

`/vol/projects/khuang/repo_demo/slurm-computing-family/taxonomic_profiling`

##### More information 
1. [MetaPhlAn User Guide](https://github.com/biobakery/MetaPhlAn)
2. [Bowtie output interpretation](https://bowtie-bio.sourceforge.net/bowtie2/manual.shtml)