library(ggplot2)
library(dplyr)
library(reshape)
if (grepl('Mlon_fg',Summary_mlon$V1[1]) ==TRUE){
  print('TRUE')
}
species<-rep(NA,times=40)
Summary_mlon <- read.csv("~/MEME/Montpellier/Fall_Projects/Data/Microvelia/Stats/Summary_fastp.txt", header=FALSE, sep=";")
Summary_Ti <- read.csv("~/MEME/Montpellier/Fall_Projects/Data/Timema/Stats/Summary_fastp.txt", header=FALSE, sep=";")
Summary_mlon<-cbind(Summary_mlon,species)
for (v in c(1,length(Summary_mlon$V1))){
  if (grep('fg',Summary_mlon$V1[v]) == FALSE){
    Summary_mlon$species[v]<-'mi'
  }
  else {
    Summary_mlon$species[v]<-'fg' 
  }
}
Summary_mlon
Mlon_qc20<-as.data.frame(cbind(Summary_mlon$V5,Summary_mlon$V17))
Mlon_qc30<-as.data.frame(cbind(Summary_mlon$V6,Summary_mlon$V18))
Mlon_gc<-as.data.frame(cbind(Summary_mlon$V4,Summary_mlon$V16))

colnames(Mlon_qc20)<-c('before_filtering_q20','after_filtering_q20')
colnames(Mlon_qc30)<-c('before_filtering_q30','after_filtering_q30')
colnames(Mlon_gc)<-c('before_filtering_gc','after_filtering_gc')

Mlon_qc20_id<-as.data.frame(cbind(Mlon_qc20,Summary_mlon$V1))
Mlon_qc30_id<-as.data.frame(cbind(Mlon_qc30,Summary_mlon$V1))
Mlon_gc_id<-as.data.frame(cbind(Mlon_gc,Summary_mlon$V1))
Mlon_qc20_reshaped<-melt(Mlon_qc20_id,id=c('Summary_mlon$V1'))
Mlon_qc30_reshaped<-melt(Mlon_qc30_id,id=c('Summary_mlon$V1'))
Mlon_gc_reshaped<-melt(Mlon_gc_id,id=c('Summary_mlon$V1'))

ggplot(Mlon_qc20_reshaped, aes(value, fill = variable)) + geom_histogram()
ggplot(Mlon_qc30_reshaped, aes(value, fill = variable)) + geom_histogram()
ggplot(Mlon_gc_reshaped, aes(value, fill = variable)) + geom_histogram()


Ti_qc20<-as.data.frame(cbind(Summary_Ti$V5,Summary_Ti$V17))
Ti_qc30<-as.data.frame(cbind(Summary_Ti$V6,Summary_Ti$V18))
Ti_gc<-as.data.frame(cbind(Summary_Ti$V4,Summary_Ti$V16))

colnames(Ti_qc20)<-c('before_filtering_q20','after_filtering_q20')
colnames(Ti_qc30)<-c('before_filtering_q30','after_filtering_q30')
colnames(Ti_gc)<-c('before_filtering_gc','after_filtering_gc')

Ti_qc20_id<-as.data.frame(cbind(Ti_qc20,Summary_Ti$V1))
Ti_qc30_id<-as.data.frame(cbind(Ti_qc30,Summary_mTi$V1))
Ti_gc_id<-as.data.frame(cbind(Mlon_gc,Summary_Ti$V1))
Ti_qc20_reshaped<-melt(Ti_qc20_id,id=c('Summary_Ti$V1'))
Ti_qc30_reshaped<-melt(Ti_qc30_id,id=c('Summary_Ti$V1'))
Ti_gc_reshaped<-melt(Ti_gc_id,id=c('Summary_Ti$V1'))

ggplot(Mlon_qc20_reshaped, aes(value, fill = variable)) + geom_histogram()
ggplot(Mlon_qc30_reshaped, aes(value, fill = variable)) + geom_histogram()
ggplot(Mlon_gc_reshaped, aes(value, fill = variable)) + geom_histogram()
