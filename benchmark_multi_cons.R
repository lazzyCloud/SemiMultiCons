#--------------------#
# Iris dataset input #
#--------------------#
LinkFolder <- "constraints/iris1/"
#LinkFolder <- "constraints/iris2/"
#LinkFolder <- "constraints/iris3/"
#LinkFolder <- "constraints/iris4/"
#LinkFolder <- "constraints/iris5/"
conNumList <- seq(0.0004,0.02,0.0004)

#--------------------#
# Wine dataset input #
#--------------------#
#LinkFolder <- "constraints/wine1/"
#LinkFolder <- "constraints/wine2/"
#LinkFolder <- "constraints/wine3/"
#LinkFolder <- "constraints/wine4/"
#LinkFolder <- "constraints/wine5/"
#conNumList <- seq(0.0004,0.02,0.0004)

#--------------------#
# Zoo dataset input #
#--------------------#
#LinkFolder <- "constraints/zoo1/"
#LinkFolder <- "constraints/zoo2/"
#LinkFolder <- "constraints/zoo3/"
#LinkFolder <- "constraints/zoo4/"
#LinkFolder <- "constraints/zoo5/"
#conNumList <- seq(0.0004,0.02,0.0004)

#--------------------#
# MNIST3 dataset input #
#--------------------#
#LinkFolder <- "constraints/mnist31/"
#LinkFolder <- "constraints/mnist32/"
#LinkFolder <- "constraints/mnist33/"
#LinkFolder <- "constraints/mnist34/"
#LinkFolder <- "constraints/mnist35/"
#conNumList <- seq(0.000000045,0.000002,0.0000001)

#--------------------#
# MNIST5 dataset input #
#--------------------#
#LinkFolder <- "constraints/mnist51/"
#LinkFolder <- "constraints/mnist52/"
#LinkFolder <- "constraints/mnist53/"
#LinkFolder <- "constraints/mnist54/"
#LinkFolder <- "constraints/mnist55/"
#conNumList <- seq(0.000000045,0.000002,0.0000001)

LinkNames <- list.files(path=LinkFolder, full.names = FALSE)

for (conNum in conNumList) {
  mFile <- NULL
  cFile <- NULL
  
  MT <- 0.5
  #--------------------#
  # Iris dataset input #
  #--------------------#
  OutDir <- "results/iris1/"
  #OutDir <- "results/iris2/"
  #OutDir <- "results/iris3/"
  #OutDir <- "results/iris4/"
  #OutDir <- "results/iris5/"
  InDir <- "ensemble members/iris/"
  Name <- paste("iris",conNum,sep="_") 
  
  #--------------------#
  # Wine dataset input #
  #--------------------#
  #OutDir <- "results/wine1/"
  #OutDir <- "results/wine2/"
  #OutDir <- "results/wine3/"
  #OutDir <- "results/wine4/"
  #OutDir <- "results/wine5/"
  #InDir <- "ensemble members/wine/"
  #Name <- paste("wine",conNum,sep="_") 
  
  #--------------------#
  # Zoo dataset input #
  #--------------------#
  #OutDir <- "results/zoo1/"
  #OutDir <- "results/zoo2/"
  #OutDir <- "results/zoo3/"
  #OutDir <- "results/zoo4/"
  #OutDir <- "results/zoo5/"
  #InDir <- "ensemble members/zoo/"
  #Name <- paste("zoo",conNum,sep="_") 
  
  #----------------------#
  # MNIST3 dataset input #
  #----------------------#
  #OutDir <- "results/mnist31/"
  #OutDir <- "results/mnist32/"
  #OutDir <- "results/mnist33/"
  #OutDir <- "results/mnist34/"
  #OutDir <- "results/mnist35/"
  #InDir <- "ensemble members/mnist3_all/"
  #Name <- paste("mnist3",conNum,sep="_") 
  
  #--------------------#
  # MNIST5 dataset input #
  #--------------------#
  #OutDir <- "results/mnist51/"
  #OutDir <- "results/mnist52/"
  #OutDir <- "results/mnist53/"
  #OutDir <- "results/mnist54/"
  #OutDir <- "results/mnist55/"
  #InDir <- "ensemble members/mnist5_all/"
  #Name <- paste("mnist5",conNum,sep="_") 
  
  for (LinkName in LinkNames) {
    temp = strsplit(LinkName,"_")
    c <- temp[[1]][3]
    
    if (c == conNum) {
      cat(c, conNum, "\n")
      t <- temp[[1]][1]
      if (t == "m") {mFile = paste(LinkFolder,LinkName,sep="")}
      else if (t == "c") {cFile = paste(LinkFolder,LinkName,sep="")}
      
    }
  }
  #rm(temp,c,t)
 
  if ((!is.null(mFile)) && (!is.null(cFile))) {
    source("multi_cons.R")  
  } 
  
  
}
rm(list = ls(all.names = TRUE))
