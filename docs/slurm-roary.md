# Core & Pangenome Reconstruction for Prokaryotic Genomes

## Brief description
Core and pangenomes can be used for studying the genomic differences (SNVs and gene gain and loss) between microbial genomes. In this utility, we implement a commonly-used computational approach - Roary - in our slurm computing family in order to scale up core & pangenome reconstruction leveraging SLURM clusters.

## How to use it?
Launch your tasks using `roary_dispatch.sh`.

~~~Bash
roary_dispatch.sh -h

Pipeline version: v=1.0.0
Usage: roary_dispatch.sh -i [input] -o [output] -n [nproc]
    -i       Input folder of GFF files or a file listing directories containing GFF files.
    -o       Output folder for storing results.
    -id      Minimum percentage identity for BLASTP (default: 95).
    -n       Number of processors to use (default: 20).
    -cd      Percentage of isolates a gene must be in to be core (default: 99).
    -mem     Memory requirement in GB (default: 6).
    -time    Walltime in hours (default: 24).
    -log_dir Directory for logs (default: /vol/cluster-data/khuang/slurm_logs).
    -log_id  Identifiable label for log outputs.
    --help | -h   Show this help page.
    !NOTE!: Use absolute paths for input and output.
~~~

## Example Input Data

1. A single directory containing GFF files: `/vol/projects/khuang/repo_demo/slurm-computing-family/roary_demo/single_folder`
2. Multiple folders of GFF files: `/vol/projects/khuang/repo_demo/slurm-computing-family/roary_demo/multi_folders/multi_gff_dir.tsv`

## Example command lines

### Input is a single directory containing GFF files

~~~Bash
# Define input, output, and log directories
INPUT="/vol/projects/khuang/repo_demo/slurm-computing-family/roary_demo/single_folder"
OUTPUT="/vol/projects/khuang/repo_demo/slurm-computing-family/roary_demo/single_folder_output"
LOG="/vol/cluster-data/khuang/slurm_logs"

# Print the parameters for verification
echo "Input directory: ${INPUT}"
echo "Output directory: ${OUTPUT}"
echo "Log directory: ${LOG}"

# Run Roary with specified parameters
roary_dispatch.sh \
    -i ${INPUT} \
    -o ${OUTPUT} \
    -id 85 \                # Minimum percentage identity for BLASTP
    -mem 64 \               # Maximum memory to use (in GB)
    -cd 95 \                # Minimum percentage of isolates a gene must be present in
    -n 50 \                 # Number of threads to use
    -time 48 \              # Maximum runtime (in hours)
    -log_id Roary \         # Identifier for the log files
    -log_dir ${LOG}         # Directory for log files

# Print completion message
echo "Roary dispatch complete. Check ${LOG} for log files."
~~~

### Input is multiple folders of GFF files

~~~Bash
# Define input, output, and log directories
INPUT="/vol/projects/khuang/repo_demo/slurm-computing-family/roary_demo/multi_folders/multi_gff_dir.tsv"
OUTPUT="/vol/projects/khuang/repo_demo/slurm-computing-family/roary_demo/multi_folders_output"
LOG="/vol/cluster-data/khuang/slurm_logs"

# Print the parameters for verification
echo "Input directory: ${INPUT}"
echo "Output directory: ${OUTPUT}"
echo "Log directory: ${LOG}"

# Run Roary with specified parameters
roary_dispatch.sh \
    -i ${INPUT} \
    -o ${OUTPUT} \
    -id 85 \                # Minimum percentage identity for BLASTP
    -mem 64 \               # Maximum memory to use (in GB)
    -cd 95 \                # Minimum percentage of isolates a gene must be present in
    -n 50 \                 # Number of threads to use
    -time 48 \              # Maximum runtime (in hours)
    -log_id Roary \         # Identifier for the log files
    -log_dir ${LOG}         # Directory for log files

# Print completion message
echo "Roary dispatch complete. Check ${LOG} for log files."
~~~

## Notes
- Ensure absolute paths are used for input and output.
- Adjust parameters like memory, number of threads, and runtime according to the dataset and computational resources available.
