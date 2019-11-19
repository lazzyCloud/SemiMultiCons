#--------------------#
# Iris dataset input #
#--------------------#
InFile <- "dataset/iris.csv" # dataset file
InDir <- "ensemble members/iris/"

#--------------------#
# Wine dataset input #
#--------------------#
#InFile <- "dataset/wine.csv" # dataset file
#InDir <- "ensemble members/wine/"

#--------------------#
# Zoo dataset input #
#--------------------#
#InFile <- "dataset/zoo.csv" # dataset file
#InDir <- "ensemble members/zoo/"

#----------------------#
# MNIST3 dataset input #
#----------------------#
#InFile <- "dataset/mnist3_all.csv" # dataset file
#InDir <- "ensemble members/mnist3_all/"

#----------------------#
# MNIST5 dataset input #
#----------------------#
#InFile <- "dataset/mnist5_all.csv" # dataset file
#InDir <- "ensemble members/mnist5_all/"

library(clue)
#---------------------#
# READ DATA FROM FILE #
#---------------------#
Dataset <- read.csv(file = InFile, header = F)
Data_Class <- Dataset[,ncol(Dataset)]
Data_Size <- nrow(Dataset)

#-----------------------------------#
# READ BASE CLUSTERINGS FROM FOLDER #
#-----------------------------------#
ResultsNames <- list.files(path=InDir, full.names = TRUE)
Results <- list()
Methods <- list()
Clstrings <- 0

for (ResultName in ResultsNames) {
  Clstrings <- Clstrings + 1
  Results[[Clstrings]] <- read.csv(file=ResultName, header=FALSE)$V1
  Methods[[Clstrings]] <- strsplit(tail(strsplit(ResultName, "/")[[1]],n=1), ".csv")[[1]][1]
  
  Temp_Size <- length(Results[[Clstrings]])
  if (Data_Size != Temp_Size) {
      cat("Different data size in base clusterings, please check!")
      exit()
  }
}

rm(Temp_Size, ResultName, ResultsNames, Dataset)

BaseResults <- data.frame(name = character(), k = numeric(), cRand = numeric(), NMI = numeric(), Jaccard = numeric(), purity = numeric())
for (i in 1:Clstrings) {
  Algo <- strsplit(Methods[[i]],"_")[[1]][1]
  
  Cluster <- Results[[i]]
  BaseResults <- rbind(BaseResults,data.frame(name=Algo, 
                                              k=length(unique(Cluster)),
                                              cRand=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(Cluster)), 
                                                                 y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), 
                                                                 method = "cRand")[1],
                                              NMI=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(Cluster)), 
                                                               y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), 
                                                               method = "NMI")[1],
                                              Jaccard=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(Cluster)), 
                                                                   y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), 
                                                                   method = "Jaccard")[1],
                                              purity=cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(Cluster)), 
                                                                  y= as.cl_hard_partition(as.cl_class_ids(Data_Class)), 
                                                                  method = "purity")[1]
  ))
}
