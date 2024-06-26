# Prokaryotic genome annotation by prokka

## Brief description
Prokaryotic genome annotation is the first step of assigning identities to genomic features (CDS, mRNA, rRNA etc). Here, we implement a commonly-used computational approach - prokka - in our slurm computing family in order to scale up annotation tasks leveraging SLURM clusters. 

## How to use it?
`prokka_dispatch.sh` will simply do the magic!

~~~Bash
prokka_dispatch.sh -h

Pipeline version: v=1.0.0
Usage: prokka_dispatch.sh -i [input] -o [output] -n [nproc]

 -i       A directory of input genome fasta files or a single fasta file.
 -o       A directory for storing output results.
 -k       Kindom for annotation: Bacteria|Viruses. Default: Bacteria
 -n       The number of processors to use. Default: 20
 -m       Adjust for highly fragmented metagenome: ON|OFF. Default: OFF
 -mem     Specify the memory in need. Default = 6, Gb
 -time    Specify the walltime. Default = 24, hours
 -log_dir Specify the directory to hold logs (default = /vol/cluster-data/khuang/slurm_logs)
 -log_id  Specify the identifiable label for log outputs.
 --help | -h   Show this help page
 !NOTE!: Both input and output should be given with an absolute path!
~~~

## Example input data

1. A FASTA file containing one single genome: `/vol/projects/khuang/repo_demo/slurm-computing-family/prokka_annotation/one_file_demo/ZellerG_2014__CCMD34381688ST-21-0__bin.4.fna`
2. A folder containing multiple FASTA files, each corresponding to one genome: `/vol/projects/khuang/repo_demo/slurm-computing-family/prokka_annotation/one_folder_demo/genomes_annotate`

## Example command lines:

1. A FASTA file:

~~~Bash
prokka_dispatch.sh \
-i /vol/projects/khuang/repo_demo/slurm-computing-family/prokka_annotation/one_file_demo/ZellerG_2014__CCMD34381688ST-21-0__bin.4.fna \
-o /vol/projects/khuang/repo_demo/slurm-computing-family/prokka_annotation/one_file_demo/one_file_demo_output \ 
-n 10
~~~

2. A folder:

~~~Bash
prokka_dispatch.sh \
-i /vol/projects/khuang/repo_demo/slurm-computing-family/prokka_annotation/one_folder_demo/genomes_annotate \
-o /vol/projects/khuang/repo_demo/slurm-computing-family/prokka_annotation/one_folder_demo/one_folder_demo_output \
-n 10
~~~

Note: Example outputs are available by following the output pathway as specified above