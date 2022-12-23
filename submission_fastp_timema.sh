#!/bin/bash
#$ -S /bin/bash
#$ -N fastp_mlon
#$ -cwd
#$ -l h_rt=999:00:00
#$ -m easb
#$ -M yunqi.song@etu.umontpellier.fr
#$ -o log.out
#$ -e log.err
#$ -V
module load python/3
source activate miniconda3-4.3.30 #nom de l'environnement conda, dans lequel il y a picard et bwa
snakemake --unlock --snakefile /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Timema/Scripts/Snakefile_timema_fastp
snakemake -n --snakefile /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Timema/Scripts/Snakefile_timema_fastp
snakemake --snakefile /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Timema/Scripts/Snakefile_timema_fastp --cluster "qsub -cwd -l h_rt=999:00:00 -V -o job.out -e job.err -m easb -l h_vmem=60G" -j 20 -k

