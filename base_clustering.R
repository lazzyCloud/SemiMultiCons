##################################################################################
# GENERATES THE BASE CLUSTERINGS THAT WILL GENERATE THE BINARY MEMBERSHIP MATRIX #
##################################################################################

library(chron)
library(infotheo)
library(cluster) # diana
library(fpc) #DBSCAN
library(mclust) # mclust
library(clv)
library(flashClust) # flashClust
library(e1071) # bclust, cmeans
library(clue)

#-----------------------------------------------------------------------------#
# THE DATASET MUST ONLY CONTAINS NUMERICAL DATA AND LAST COLUMN MUST BE LABEL #
#-----------------------------------------------------------------------------#
Dataset <- read.csv(file = DataFile, header = F)
Test_Data <- Dataset[,c(1:(ncol(Dataset)-1))] 
Data_Class <- Dataset[,ncol(Dataset)]
Data_Size <- nrow(Dataset)
#---------------#
# NORMALIZATION #
#---------------#
Norm_Dataset <- data.frame(Test_Data)  
# The following line can be disabled if normalization is not required
Norm_Dataset <- data.frame(scale(Test_Data))  

#-----------------------------#
# PARAMETER: BASE CLUSTERINGS #
#-----------------------------#
# default metric is euclidean
Metrc <- c("euclidean", "manhattan", "gower") # distance metric
Metrc <- Metrc[1]
Distance <- Other <- "default"

if (Data_Size > 30000) {
  Lrge <- T
  if ((Algo == "flashClust") | (Algo == "diana")) {
    cat("flashClust and diana do not support large dataset, exit.")
    exit()
  } 
} else{
  Lrge <- F
  Dist <- daisy(x = Norm_Dataset,metric = Metrc)
} 

if ("pam" == Algo) {
  if (Lrge) {Pam_Swp <- F} else {Pam_Swp <- T} # PAM parameter, set to F for big datasets
}

if ("dbscan" == Algo) {
  Eps <- 1 # DBSCAN parameter
  MinP <- 10
}

# hierarchical clustering parameters
if (("flashClust" == Algo) || ("bclust" == Algo) || ("agnes" == Algo)) {
  #Hrch_linkg <- c("average" , "single" , "complete" , "centroid" , "mcquitty",  "median" )
  Hrch_linkg <- c("ward")
  #Agns_linkg <- c("average" , "single" , "complete" , "ward" , "weighted" , "average" ,"gaverage")
  Agns_linkg <- c("ward")
}

#-------------------------------#
# GENERATE BASE CLUSTERING HERE #
#-------------------------------#
if(Algo=="kmeans") {
  Clustering <- kmeans(x = Norm_Dataset , centers = K ,iter.max = 100,nstart = 50)
  Cluster <- Clustering$cluster
  Name <- paste(Algo,length(unique(Cluster)),sep="_")
  
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 
  
} else if(Algo=="pam"){
  if (Lrge) {X <- Norm_Dataset} else { X <- Dist}
  Cluster <- pam(x = X , k = K ,diss = Pam_Swp,cluster.only = T,do.swap = Pam_Swp)
  Name <- paste(Algo, length(unique(Cluster)), Metrc, sep="_")
  
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 

} else if(Algo=="clara"){
  # number of samples may need be configured
  N_Samp <- 5 # CLARA parameter
  Samp_Size <- trunc(Data_Size/N_Samp) # CLARA parameter
  Clustering <- clara(x = Norm_Dataset,k = K,samples = N_Samp,sampsize = Samp_Size)
  Cluster <- Clustering$cluster
  Name <- paste(Algo,length(unique(Cluster)),sep="_")
  Other <- paste("nsample",N_Samp,"size",Samp_Size,sep="")
      
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 

} else if(Algo=="dbscan"){
  # eps and minpt may need manual configuration
  if (Lrge) {
    X <- Norm_Dataset
    DBSCN_mthd <- "hybrid"
  } else { 
    X <- Dist
    DBSCN_mthd <- "dist"
  }
  source("repeat_dbscan.R")
  Cluster <- Clustering$cluster
  if (min(Cluster)==0) { Cluster <- Cluster + 1}
  Name <- paste(Algo, length(unique(Cluster)) ,sep="_")
  Distance <- Metrc
  Other <- paste("eps",round(Eps,digits = 2),"minpts",MinP,sep="")
      
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 

} else if(Algo=="cmeans"){
  Clustering <- cmeans(x = Norm_Dataset , centers = K)
  Cluster <- Clustering$cluster
  Name <- paste(Algo,length(unique(Cluster)),sep="_")
        
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n')

} else if(Algo=="diana"){
  if (Lrge) {X <- Norm_Dataset} else { X <- Dist}
  Clustering <- diana(x = X , diss = !Lrge, metric = Metrc , keep.diss = F, keep.data = F)
  Cluster <- cutree(tree = as.hclust(Clustering),k = K)
  Name <- paste(Algo,length(unique(Cluster)),sep="_")
  Distance <- Metrc
  
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 

} else if(Algo=="flashClust"){
  for (linkMethod in Hrch_linkg) {
    cat(linkMethod, "\n")
    Clustering <- flashClust(d = Dist , method = linkMethod)
    Cluster <- cutree(tree = Clustering,k = K)
    Other <- linkMethod
    Name <- paste(Algo,length(unique(Cluster)),Other,sep="_")
    Distance <- Metrc
      
    cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 
  }

} else if(Algo=="bclust"){
  for (linkMethod in Hrch_linkg) {
    Clustering <- bclust(x = Norm_Dataset , centers = K , iter.base = 20 , dist.method = Metrc , hclust.method = linkMethod , base.method = "kmeans" , base.centers = max(20,K) , verbose = F)
    Cluster <- Clustering$cluster
    Other <- linkMethod
    Name <- paste(Algo,length(unique(Cluster)),Other,sep="_")
    Distance <- Metrc
        
    cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 
  }

} else if(Algo=="agnes"){
  if (Lrge) {X <- Norm_Dataset} else { X <- Dist}
  for (linkMethod in Agns_linkg) {
    Clustering <- agnes(x = X ,diss = !Lrge, metric = Metrc , method = linkMethod, keep.diss = F, keep.data = F)
    Cluster <- cutree(tree = Clustering,k = K)
    Name <- paste(Algo,length(unique(Cluster)),sep="_")
    Distance <- Metrc
    Other <- linkMethod
    
    Distance <- Other <- "default"
    cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 
  }

} else if(Algo=="fanny"){
  if (Lrge) {X <- Norm_Dataset} else { X <- Dist}
  Clustering <- fanny(x = X , k = K, diss = !Lrge, metric = Metrc, stand = F, keep.diss = F, keep.data = F)
  Cluster <- Clustering$clustering
  Name <- paste(Algo,length(unique(Cluster)),sep="_")
  Distance <- Metrc
    
  Distance <- Other <- "default"
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 

} else if(Algo=="mclust"){
  Clustering <- Mclust(data = Norm_Dataset , G = K)
  Cluster <- Clustering$classification
  Name <- paste(Algo,length(unique(Cluster)),sep="_")
  Other <- Clustering$modelName
  
  cat("Algorithm:",paste(Name,Distance,Other,sep="")," done.",'\n') 

} else{
  print(paste("Incorrect algorithm name:",Algo))
}

# remove all variables used
if ("clara" == Algo) {
  rm(N_Samp,Samp_Size, Clustering)
}
if ("dbscan" == Algo) {
  rm(Eps,MinP,DBSCN_mthd, Clustering)
}
if (("flashClust" == Algo) | ("bclust" == Algo)) {
  rm(Hrch_linkg, linkMethod, Clustering)
}
if ("agnes" == Algo) {
  rm(Agns_linkg, Hrch_linkg, linkMethod, Clustering)
}
if (("kmeans" == Algo) | ("cmeans" == Algo) | ("diana" == Algo) | ("fanny" == Algo) | ("mclust" == Algo)) {
  rm(Clustering)
}
if ("pam" == Algo) {
  rm(Pam_Swp)
}

# remove input
rm(Algo, DataFile, K)
# remove dataset related parameters
rm(Dataset, Norm_Dataset, Test_Data, Data_Class, Data_Size)
# remove flag, distance metric, etc.
rm(Distance,Other,Lrge, Dist, Metrc)

Name = paste(Name, round(as.numeric(Sys.time())*1000), sep="_")
write.table(Cluster, file = paste(OutDir,Name,".csv",sep=""),row.names=FALSE,sep = ",", col.names = FALSE)
rm(Cluster,Name, OutDir)

if(exists("X")){
  rm(X)
}

if(exists("MinP")){
  rm(MinP)
}
