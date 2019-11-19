########################
# MULTI CONS ALGORITHM #
########################
library(hash)
#------------------#
# INPUT PARAMETERS #
#------------------#
#InDir <- "ensemble members/iris/"

#mFile = "constraints/iris1/m_iris_0.01_1569594999120.csv"
#cFile = "constraints/iris1/c_iris_0.01_1569594999120.csv"

#MT <- 0.5

#OutDir <- "results/iris1/"

#Name <- "iris"

#-----------------------------------#
# READ BASE CLUSTERINGS FROM FOLDER #
#-----------------------------------#
ResultsNames <- list.files(path=InDir, full.names = TRUE)
Results <- list()
Methods <- list()
Clstrings <- 0

Data_Size <- -1
for (ResultName in ResultsNames) {
  Clstrings <- Clstrings + 1
  Results[[Clstrings]] <- read.csv(file=ResultName, header=FALSE)$V1
  Methods[[Clstrings]] <- strsplit(strsplit(ResultName, "/")[[1]][3], ".csv")[[1]][1]
  
  Temp_Size <- length(Results[[Clstrings]])
  if (Data_Size < 0) {
    Data_Size <- Temp_Size
  } else {
    if (Data_Size != Temp_Size) {
      cat("Different data size in base clusterings, please check!")
      exit()
    }
  }
}

# clean environment
rm(ResultsNames, ResultName, Temp_Size)

#---------------------------------#
# FILTER MEANINGLESS BASE RESULTS #
#---------------------------------#
source("refine_clusterings.R") # removes the base clustering that consist of 1 big cluster
Clstrings <- length(Results)
source("check_similar_clusterings.R") # removes identical clusterings

#-----------------------------------#
# GENERATE BINARY MEMBERSHIP MATRIX #
#-----------------------------------#
source("binary_membership_matrix.R")

#--------------------------#
# GENERATE CLOSED PATTERNS #
#--------------------------#
source("closed_patterns.R")

#------------------------------#
# READ CONSTRAINTS FROM FOLDER #
#------------------------------#
Must_Link <- tryCatch(read.csv(mFile, header = FALSE), error=function(e) NULL)
Cannot_Link <- tryCatch(read.csv(cFile, header = FALSE), error=function(e) NULL)

cons_n <- unique(c(Must_Link[,1],Must_Link[,2],Cannot_Link[,1],Cannot_Link[,2]))
idx_list = hash()
.set(idx_list, keys=as.character(c(1:Data_Size)),values=length(cons_n)+1)
.set(idx_list, keys=as.character(cons_n), values=1:length(cons_n))

#Must_Link <- read.csv(mFile, header=FALSE)
#Cannot_Link <- read.csv(cFile, header=FALSE)
constraints = matrix(0L, nrow=(length(cons_n) + 1), ncol=(length(cons_n) + 1))


if (!is.null(Must_Link)) {
#  constraints[unname(values(idx_list, keys=as.character(Must_Link[,]$V1))),
#              unname(values(idx_list, keys=as.character(Must_Link[,]$V2)))] <- 1
#  constraints[unname(values(idx_list, keys=as.character(Must_Link[,]$V2))),
#              unname(values(idx_list, keys=as.character(Must_Link[,]$V1)))] <- 1
#}
#if (!is.null(Cannot_Link)) {
#  constraints[unname(values(idx_list, keys=as.character(Cannot_Link[,]$V1))),
#              unname(values(idx_list, keys=as.character(Cannot_Link[,]$V2)))] <- -1
#  constraints[unname(values(idx_list, keys=as.character(Cannot_Link[,]$V2))),
#              unname(values(idx_list, keys=as.character(Cannot_Link[,]$V1)))] <- -1
#}

for (i in c(1:nrow(Must_Link))) {
  constraints[idx_list[[toString(Must_Link[i,]$V1)]], idx_list[[toString(Must_Link[i,]$V2)]]] <- 1
  constraints[idx_list[[toString(Must_Link[i,]$V2)]], idx_list[[toString(Must_Link[i,]$V1)]]] <- 1
  #constraints[[paste(toString(Must_Link[i,]$V2),toString(Must_Link[i,]$V1),sep="_")]] <- 1
  
  #constraints[, Must_Link[i,]$V2] = 1
  #constraints[Must_Link[i,]$V2, Must_Link[i,]$V1] = 1
}
}
if (!is.null(Cannot_Link))
for (i in c(1:nrow(Cannot_Link))) {
  constraints[idx_list[[toString(Cannot_Link[i,]$V1)]], idx_list[[toString(Cannot_Link[i,]$V2)]]] <- -1
  constraints[idx_list[[toString(Cannot_Link[i,]$V2)]], idx_list[[toString(Cannot_Link[i,]$V1)]]] <- -1
  #constraints[Cannot_Link[i,]$V1, Cannot_Link[i,]$V2] = -1
  #constraints[Cannot_Link[i,]$V2, Cannot_Link[i,]$V1] = -1
  #constraints[[paste(toString(Cannot_Link[i,]$V1),toString(Cannot_Link[i,]$V2),sep="_")]] <- -1
  #constraints[[paste(toString(Cannot_Link[i,]$V2),toString(Cannot_Link[i,]$V1),sep="_")]] <- -1
  
}

#----------------------------#
# MULTI CONSENSUS GENERATION #
#----------------------------#
source("constrained_consensus.R")

clear(idx_list)
#-------------------#
# OUTLIER DETECTION #
#-------------------#
source("outlier_detection.R")


#------------------------#
# OUTPUT RESULTS TO JSON #
#------------------------#
library(jsonlite)
res = NULL
res$Stabl_Cons_Vctrs <- Stabl_Cons_Vctrs
res$Bst_Cons <- Bst_Cons
res$Bst_Cons_con <- Bst_Cons_con
res$Stability <- Stability
res$Rmv_Inst <- Rmv_Inst
res$Tme_consensus <- as.numeric(Tme_consensus)
res$Tme_FCI <- as.numeric(Tme_FCI)
res$Tme_selection <- as.numeric(Tme_selection)
write(toJSON(res, pretty=TRUE), paste(OutDir,paste(Name,round(as.numeric(Sys.time())*1000),sep="_"),".json",sep=""))
