#!/bin/bash
#$ -S /bin/bash
#$ -N fastp_mlon
#$ -cwd
#$ -l h_rt=999:00:00
#$ -m easb
#$ -M yunqi.song@etu.umontpellier.fr
#$ -o logtry.out
#$ -e logtry.err
#$ -V
module load python/3
/home/ysong/.pyenv/versions/miniconda3-4.3.30/bin/fastp \
-i /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/Mlon_mi/Primary_Data/PopGen_Data/Mlon_mi_01_R1.v1_1.fastq.gz \
-I /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/Mlon_mi/Primary_Data/PopGen_Data/Mlon_mi_01_R2.v1_1.fastq.gz \
-o /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/Mlon_mi/Primary_Data/FastP/Mlon_mi_01_R1.fastp.v1_1.fastq.gz \
-O /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/Mlon_mi/Primary_Data/FastP/Mlon_mi_01_R2.fastp.v1_1.fastq.gz \
--trim_poly_g --correction --low_complexity_filter --html /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/Mlon_mi/Primary_Data/FastP/Mlon_mi_01.fastp_report.v1_1.html \
--json /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/Mlon_mi/Primary_Data/FastP/Mlon_mi_01.fastp_report.v1_1.json \
--thread 8 --dont_overwrite