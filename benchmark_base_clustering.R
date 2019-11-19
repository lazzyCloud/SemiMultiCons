#--------------------#
# Iris dataset input #
#--------------------#
KList <- c(2,3,4,5,6)
AlgoList <- c("kmeans","clara")
Rpt <- c(1)

#--------------------#
# Wine dataset input #
#--------------------#
#KList <- c(2,3,4,5,6)
#AlgoList <- c("kmeans","clara")
#Rpt <- c(1)

#--------------------#
# Zoo dataset input #
#--------------------#
#KList <- c(5, 6, 7, 8, 9)
#AlgoList <- c("kmeans","clara")
#Rpt <- c(1)

#----------------------#
# MNIST3 dataset input #
#----------------------#
#KList <- c(2,3,4,5,6)
#AlgoList <- c("kmeans","clara")
#Rpt <- c(1)

#----------------------#
# MNIST5 dataset input #
#----------------------#
#KList <- c(3, 4, 5, 6, 7)
#AlgoList <- c("kmeans","clara")
#Rpt <- c(1)


for (rpt in Rpt) {
  for (k in KList) {
    for (algo in AlgoList) {
      K <- k
      Algo <- algo
      #--------------------#
      # Iris dataset input #
      #--------------------#
      DataFile <- "dataset/iris.csv" # dataset file
      OutDir <- "ensemble members/iris/"
      
      #--------------------#
      # Wine dataset input #
      #--------------------#
#      DataFile <- "dataset/wine.csv" # dataset file
#      OutDir <- "ensemble members/wine/"
      
      #--------------------#
      # Zoo dataset input #
      #--------------------#
#      DataFile <- "dataset/zoo.csv" # dataset file
#      OutDir <- "ensemble members/zoo/"
      
      #----------------------#
      # MNIST3 dataset input #
      #----------------------#
#      DataFile <- "dataset/mnist3_all.csv" # dataset file
#      OutDir <- "ensemble members/mnist3_all/"
      
      #----------------------#
      # MNIST5 dataset input #
      #----------------------#
#      DataFile <- "dataset/mnist5_all.csv" # dataset file
#      OutDir <- "ensemble members/mnist5_all/"
  
      source("base_clustering.R")
      
    }
  }
}