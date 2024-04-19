# Calculating average nucleotide identity (ANI) by pyani

## Brief description
Estimating the average nucleotide idenity (ANI) between genomic sequences (including MAGs) has become a common practice to understand how closely two genomes (representing strains) are related. Here, we introduce `slurm-pyani` to launch one folder of genomes or multuple folder of genomes onto SLURM cluster simultaneouly so as to maximize the use of computational resources. <br>

## How to use it?
`pyani_dispatch.sh` will simply do the magic!

~~~Bash
pyani_dispatch.sh -h

Pipeline version: v=1.0.0
Usage: pyani_dispatch.sh -i [input] -o [output] -m [method] -n [nproc]

 -i       A directory of input genomes or a file of directory paths leading input genomes.
 -o       A directory for storing output results.
 -m       ANI estimating methods: ANIm/ANIb/ANIblastall. Default: ANIb.
 -n       The number of processors to use. Default: 20
 -mem     Specify the memory in need. Default = 64, Gb
 -time    Specify the walltime. Default = 24, hours
 -log_dir Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)
 -log_id  Specify the identifiable label for log outputs.
 --help | -h   Show this help page
 !NOTE!: Both input and output should be given with an absolute path!
~~~

## Example input data

1. Single folder of genomes: `/vol/projects/khuang/repo_demo/slurm-computing-family/average_nucleotide_identity_demo/single_folder/mags_50_strains_input_dir`
2. Multiple folders of genomes: `/vol/projects/khuang/repo_demo/slurm-computing-family/average_nucleotide_identity_demo/multi_folder/multiple_folder_paths.txt`

## Example command lines
1. Single folder of genomes:
~~~Bash
pyani_dispatch.sh \ 
-i /vol/projects/khuang/repo_demo/slurm-computing-family/average_nucleotide_identity_demo/single_folder/mags_50_strains_input_dir \
-o /vol/projects/khuang/repo_demo/slurm-computing-family/average_nucleotide_identity_demo/single_folder/mags_50_strains_output_dir \
-n 60
~~~

## Multiple folders of genomes:
~~~Bash
pyani_dispatch.sh \
-i /vol/projects/khuang/repo_demo/slurm-computing-family/average_nucleotide_identity_demo/multi_folder/multiple_folder_paths.txt \
-o /vol/projects/khuang/repo_demo/slurm-computing-family/average_nucleotide_identity_demo/multi_folder/multiple_folder_outputs \
-n 60
~~~

Note: Example outputs are available following the output pathway specified as above.