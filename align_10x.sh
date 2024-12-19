#!/bin/bash
#SBATCH --job-name=align_10x
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --output=logs/out/10xstar_output_%j.txt
#SBATCH --error=logs/err/10xstar_error_%j.txt

echo "===== Script Started ====="

# Set the directory paths
GENOME_DIR=../../../genomes/amex/split_genomes/chr14
RAW_DATA_DIR=../data
OUTPUT_DIR=../results/split_star_aligned/chr14

echo "Directory paths set as:"
echo "GENOME_DIR: ${GENOME_DIR}"
echo "RAW_DATA_DIR: ${RAW_DATA_DIR}"
echo "OUTPUT_DIR: ${OUTPUT_DIR}"


# Extract the SRR accession based on the array task ID
ACCESSION=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ../data/lee_mphage_acc.txt)
echo "SLURM Array Task ID: ${SLURM_ARRAY_TASK_ID}"
echo "Accession Number extracted: ${ACCESSION}"

# Ensure the output directory exists
mkdir -p ${OUTPUT_DIR}/${ACCESSION}
echo "Directory ${OUTPUT_DIR}/${ACCESSION} created."

# Run STAR alignment
echo "Starting STAR alignment..."

# Removed Parameters
#  1   --twopassMode Basic \
#  2    --outSAMunmapped Within \
#  3    --alignIntronMax 275000 \
# 4      --soloMultiMappers Uniform \


#  6        --soloCellFilter  EmptyDrops_CR \ --soloBarcodeReadLength 0 \ --soloUMIlen 10 
# 7 GeneFull SJ
# GeneFull SJ Velocyto
module load singularity/3.5.3

STAR=/shared/container_repository/star/star_2.7.10b.sif

singularity exec -B /work:/work/ ${STAR} STAR --genomeDir ${GENOME_DIR} \
     --runThreadN 64 \
     --readFilesIn ${RAW_DATA_DIR}/${ACCESSION}/${ACCESSION}_2.fastq.gz ${RAW_DATA_DIR}/${ACCESSION}/${ACCESSION}_1.fastq.gz \
     --outFileNamePrefix ${OUTPUT_DIR}/${ACCESSION}/ \
     --outSAMtype BAM SortedByCoordinate \
     --twopassMode Basic \
     --readFilesCommand zcat \
     --outSAMattributes Standard \
     --soloType CB_UMI_Simple \
     --outWigType None \
     --soloMultiMappers Uniform \
     --soloCBwhitelist ../../../common_data/cellranger_barcodes/737K-august-2016.txt \
     --soloFeatures Gene Velocyto \
     --soloCellFilter  EmptyDrops_CR \
     --soloBarcodeReadLength 0 \
     --soloUMIlen 10 

     
echo "STAR alignment completed."

echo "===== Script Ended ====="

