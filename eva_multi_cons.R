library(jsonlite)
library(clue)
#--------------------#
# Iris dataset input #
#--------------------#
InFile <- "dataset/iris.csv" # dataset file
InDir <- "results/iris1/"
#InDir <- "results/iris2/"
#InDir <- "results/iris3/"
#InDir <- "results/iris4/"
#InDir <- "results/iris5/"

#--------------------#
# Wine dataset input #
#--------------------#
#InFile <- "dataset/wine.csv" # dataset file
#InDir <- "results/wine1/"
#InDir <- "results/wine2/"
#InDir <- "results/wine3/"
#InDir <- "results/wine4/"
#InDir <- "results/wine5/"

#--------------------#
# Zoo dataset input #
#--------------------#
#InFile <- "dataset/zoo.csv" # dataset file
#InDir <- "results/zoo1/"
#InDir <- "results/zoo2/"
#InDir <- "results/zoo3/"
#InDir <- "results/zoo4/"
#InDir <- "results/zoo5/"

#----------------------#
# MNIST3 dataset input #
#----------------------#
#InFile <- "dataset/mnist3.csv" # dataset file
#InDir <- "results/mnist3/"
#InDir <- "results/mnist3_1/"
#InDir <- "results/mnist3_2/"
#InDir <- "results/mnist3_3/"
#InDir <- "results/mnist3_4/"

#----------------------#
# MNIST5 dataset input #
#----------------------#
#InFile <- "dataset/mnist5.csv" # dataset file
#InDir <- "results/mnist5/"
#InDir <- "results/mnist5_1/"
#InDir <- "results/mnist5_2/"
#InDir <- "results/mnist5_3/"
#InDir <- "results/mnist5_4/"

ResultsNames <- list.files(path=InDir, full.names = TRUE)

aaa = c()
for (ConsTree in ResultsNames) {
  conNum = strsplit(strsplit(ConsTree,"/")[[1]][3],"_")[[1]][2]
  
  Dataset <- read.csv(file = InFile, header = F)
  Data_Class <- Dataset[,ncol(Dataset)]
  
  #rm(Dataset)
  json <- read_json(ConsTree)
  Stabl_Cons_Vctrs <- json["Stabl_Cons_Vctrs"][[1]]
  
  Bst_Cons <- as.numeric(json["Bst_Cons"][[1]][[1]])
  Bst_Cons_con <- as.numeric(json["Bst_Cons_con"][[1]][[1]])
  Stability <- as.numeric(json["Stability"][[1]])
  Rmv_Inst <- as.numeric(json["Rmv_Inst"][[1]])
  Tme_consensus <- as.numeric(json["Tme_consensus"][[1]][[1]])
  Tme_FCI <- as.numeric(json["Tme_FCI"][[1]][[1]])
  
  LevelResults <- data.frame(level = numeric(), purity = numeric(), jaccard = numeric(), crand = numeric(), NMI=numeric())
  for (ii in Stabl_Cons_Vctrs) {
    i <- as.numeric(ii)
    LevelResults <- rbind(LevelResults,data.frame(level=length(unique(i)),
                                                  purity=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(i)), y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), method = "purity")[1],
                                                  jaccard=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(i)), y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), method = "Jaccard")[1],
                                                  crand=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(i)), y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), method = "cRand")[1],
                                                  NMI=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(i)), y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), method = "NMI")[1]
    ))
  }
  
  rrr = c()
  rrr[1] = as.numeric(conNum)
  # max accuracy
  rrr[2] = max(LevelResults$jaccard, na.rm=TRUE)
  # max accuracy cluster
  rrr[3] = LevelResults$level[which.max(LevelResults$jaccard)]
  # multicons recommend
  rrr[4] = LevelResults$jaccard[Bst_Cons]
  rrr[5] = length(table(as.numeric(Stabl_Cons_Vctrs[[Bst_Cons]])))
  # constrained multicons recommend
  rrr[6] = LevelResults$jaccard[Bst_Cons_con]
  rrr[7] = length(table(as.numeric(Stabl_Cons_Vctrs[[Bst_Cons_con]])))
  # outliers
  if (!is.null(Rmv_Inst)) {
    rrr[8] = length(Rmv_Inst)
  } else {
    rrr[8] = 0
  }
  # time
  rrr[9] = Tme_FCI
  rrr[10] = Tme_consensus
  aaa <- cbind(aaa,rrr)
}
aaa <- t(aaa)
aaa <- as.data.frame(aaa)
names(aaa) <- c("conNum","best jaccard", "k","selection", "k", "con-selection", "k","outliers", "FCI time", "consensus time")
aaa <- aaa[order(aaa$conNum),]
rownames(aaa) <- c(1:nrow(aaa))
#plot(aaa$'best jaccard')
write.table(aaa, file = paste(InDir,"evaluation.csv",sep=""),row.names=TRUE,sep = ",", col.names = TRUE)
#rm(list = ls(all.names = TRUE))
