# Pangenome Reconstruction for Prokaryotic Genome

## Brief Description
Pangenome reconstruction helps identify core genes within any bacterial group (inter-/intra-species specific) using **GFF files**. This guide details using the computational tool Roary with SLURM clusters to scale up annotation tasks.

## How to Use It?
The script `roary_dispatch.sh` facilitates the process.

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

1. Directory containing GFF files: `/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/demo/s__Clostridium_sp_AF15_49_GFF/`
2. File listing directories with GFF files: `/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/demo/multi_gff_dir.tsv`

## Example Command Lines

### Using a Directory Containing GFF Files

~~~Bash
# Define input, output, and log directories
INPUT="/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/demo/s__Clostridium_sp_AF15_49_GFF/"
OUTPUT="/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/single_res/"
LOG="/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/logs/"

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

### Using a File Listing Directories with GFF Files

~~~Bash
# Define input, output, and log directories
INPUT="/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/demo/multi_gff_dir.tsv"
OUTPUT="/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/multi_res/"
LOG="/vol/projects/psivapor/projects/SelfTraning/Test_Slurm_family/Test_Roary_29_06_2024/logs/"

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
