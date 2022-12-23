import os
from itertools import product
import subprocess

test=0
if test==1: #test run
	SAMPLES=['Mlon_mi_01'] 
	SPECIES=['Mlon_mi']
else:
	## Run all the samples
	SPECIES=["Mlon_mi", "Mlon_fg"] #vector of the species names
	SAMPLES=[] #empty sample vector which will contain the list of all the samples (=fastq)
	for i in SPECIES:
		path= "/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/"+i+"/Primary_Data/PopGen_Data/"
		print(path)
		output = subprocess.check_output("ls "+ path + " | grep '.fastq' | sed -e 's/\.fastq\.gz$//' | sed -r 's/.{8}$//'", shell=True) #list files keeping just the sample prefix. sed -e 's/\.fastq\.gz$//' removed the .fastq.gz suffix and sed -r 's/.{8}$//' removed the 8 last letters that remained
		#the subprocess.check_output command allows to apply a bash function in a python script
		out=output.split('\n') #decode() : decode part is to change the binary format, split is to have a classic python vector format
		del out[-1] #to remove the last empty element of the vector
		#the vector out contains all the sample names
		SAMPLES+=[out] #c'est ce vecteur SAMPLES qui va etre reutilise dans tout le script, le + permet de concatener a la suite une fois qu'on passe dans la nouvelle espece
		#met dans un vecteur tous les fastq de tous les echantillons, pour toutes les especes = liste des noms des fastq. Ca genere un vecteur qui contient autant de sous vecteurs que d'espece. Pour avoir un echantillon en particulier, il faut faire SAMPLE[i][j]. 
	SAMPLES= SAMPLES[0] + SAMPLES[1] #merge the two sublist
	
	
	def filter_combinator(combinator, blacklist):
		def filtered_combinator(*args, **kwargs):
			for wc_comb in combinator(*args, **kwargs):
				# Use frozenset instead of tuple
				# in order to accomodate
				# unpredictable wildcard order
				if frozenset(wc_comb) not in blacklist:
					yield wc_comb
		return filtered_combinator
		
	forbidden={'start'}
	for i in range(len(SPECIES)):
		for j in range(len(SAMPLES)):
			if SPECIES[i]!=SAMPLES[j][0:7]:
				forbidden|={frozenset({("sample",SAMPLES[j]),("species",SPECIES[i])})}
				
	forbidden.remove('start')
	filtered_product = filter_combinator(product, forbidden)

print(SPECIES)
print(SAMPLES)

## Fichier de sortie
rule all:  
	input:
		expand("/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}_R1.fastp.v1_1.fastq.gz",filtered_product,sample=SAMPLES,species=SPECIES),
		expand("/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}_R2.fastp.v1_1.fastq.gz",filtered_product,sample=SAMPLES,species=SPECIES),
        	expand("/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}.fastp_report.v1_1.html",filtered_product,sample=SAMPLES,species=SPECIES),
        	expand("/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}.fastp_report.v1_1.json",filtered_product,sample=SAMPLES,species=SPECIES)
		
## Fastp
rule process_fastp:
	input:
		raw_R1="/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/PopGen_Data/{sample}_R1.v1_1.fastq.gz",
		raw_R2="/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/PopGen_Data/{sample}_R2.v1_1.fastq.gz"
	output:
        	fastp_R1="/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}_R1.fastp.v1_1.fastq.gz",
        	fastp_R2="/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}_R2.fastp.v1_1.fastq.gz",
        	report_html="/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}.fastp_report.v1_1.html",
        	report_json="/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/{species}/Primary_Data/FastP/{sample}.fastp_report.v1_1.json"
	message:
		"Fastp processing : {wildcards.sample}"
	shell : 
        	"fastp "
        	"-i {input.raw_R1} "
        	"-I {input.raw_R2} "
        	"-o {output.fastp_R1} "
        	"-O {output.fastp_R2} "
        	"--trim_poly_g "
        	"--correction "
        	"--low_complexity_filter "
        	"--html {output.report_html} "
        	"--json {output.report_json} "
        	"--report_title {wildcards.sample} "
        	"--thread 8 "
		"--dont_overwrite && "
        	"python /share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Microvelia/Scripts/Extract_fastp_info.py {wildcards.species} {wildcards.sample}"
