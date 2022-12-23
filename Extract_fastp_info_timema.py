import numpy as np
import json
import sys

SPECIES=['Tcri','Tpop']
NUMBERpop=['01','02','03','04','05','06','07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '21', '24']
NUMBERcri=['01','02','03','04','05','06','07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18']

SAMPLES=[]
for i in range(2):
	if SPECIES[i]=='Tcri':
		for k in range(len(NUMBERcri)):
			SAMPLES+=[SPECIES[i]+NUMBERcri[k]]
	else:
		for k in range(len(NUMBERpop)):
			SAMPLES+=[SPECIES[i]+NUMBERpop[k]]


with open('/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Timema/'+str(sys.argv[1])+'/Primary_Data/FastP/'+str(sys.argv[2])+'.fastp_report.v1_1.json') as json_fastp:
    a = json.load(json_fastp)

#with open(str(sys.argv[3]) as json_fastp:
#     a = json.load(json_fastp

result=[]
# get sample
#c=a['command']
#for i in range(24*4*6):
#    if c.find(SAMPLES[i])>0:
#        sample=c[73:81]
#        break

#if sample[0:1]=="Dl":
#    c=a['command']
#    for i in range(24*4*6):
#        if c.find(SAMPLES[i])>0:
#            sample=c[73:80]
 #           break

result+=[str(sys.argv[2])]
## total reads_before_filtering
result+=[a['summary']['before_filtering']['total_reads']]
result+=[a['summary']['before_filtering']['total_bases']]
result+=[a['summary']['before_filtering']['gc_content']]
result+=[a['summary']['before_filtering']['q20_rate']]
result+=[a['summary']['before_filtering']['q30_rate']]

## filtering result

reads_inital=a['summary']['before_filtering']['total_reads']
base_inital=a['summary']['before_filtering']['total_bases']
result+=[a['filtering_result']['passed_filter_reads']/reads_inital*100]
result+=[a['filtering_result']['corrected_reads']/reads_inital*100]
result+=[a['filtering_result']['corrected_bases']/base_inital*100]
result+=[a['filtering_result']['low_quality_reads']/reads_inital*100]
result+=[a['filtering_result']['too_many_N_reads']/reads_inital*100]
result+=[a['filtering_result']['too_short_reads']/reads_inital*100]
result+=[a['filtering_result']['low_complexity_reads']/reads_inital*100]

## total after_filtering

result+=[a['summary']['after_filtering']['total_reads']]
result+=[a['summary']['after_filtering']['total_bases']]
result+=[a['summary']['after_filtering']['gc_content']]
result+=[a['summary']['after_filtering']['q20_rate']]
result+=[a['summary']['after_filtering']['q30_rate']]
result+=[a['duplication']['rate']]

with open('/share/tycho_poolz1/pagagnaire/BEM/TMP_Emma/Timema/Stats/Summary_fastp.txt',"a+") as f:
	np.savetxt(f, [result],newline='\n', fmt='%s', delimiter=";")
     
         
   
