# SemiMultiCons
This is the implementation of MultiCons algorithm described in the paper Semi-supervised consensus clustering based on patterns.

## R pakcage installation
Please make sure that the following R packages are installed in the envrionment: 
- chron
- infotheo
- cluster 
- fpc
- mclust
- clv 
- flashClust
- e1071
- clue
- arules 
- jsonlite
- hash 

The **clue**, **arules**, **jsonlite**, **hash** are mandatory packages for the implementation, while the others could be ignored if the base clusterings are not generated from our implementation. 

For those who do not know how to install a R package from R command line, use 
```
install.packages("package name should be here")
```

## Base clustering generation
The base clusterings can be generated from our implementation by running **_benchmark_base_clustering.R_** . Our test dataset is provided under the repository **./dataset/** and our input parameters can be find in the comments of R script.
For example line 1 - line 6 of **_benchmark_base_clustering.R_** : 
```
#--------------------#
# Iris dataset input #
#--------------------#
KList <- c(2,3,4,5,6)
AlgoList <- c("kmeans","clara")
Rpt <- c(1)
```

**_You can comment/uncomment lines to test our test datasets._**

### If you want to generate your own base clusterings with our implementation
The following input parameters should be provided in **_benchmark_base_clustering.R_**: 
- **KList** : the range of k to generate base clusterings
- **AlgoList** : the clustering algorithm to generate base clusterings, can be selected from the following: **[kmeans, clara, pam, dbscan, cmeans, diana, flashClust, mclust, bclust]**
- **Rpt** : repeated times for each clustering algorithm and each k, normally should be **c(1)**. Please only increase the repeated times if you know that the clustering alrotihm is very **_unstable_**
- **DataFile** : input path of dataset. The dataset should be a **_csv_** file **_without header and index_**, and **_the true cluster should be the last column_**
- **OutDir** : output repository where base clusterings are stored, by default they will be stored under **./ensemble members/_dataset name_/**

### If you want to directly provide your base clustering results
I highly recommend you to put your results under **./ensemble members/_dataset name_/**. Your base clusterings should be a a **_csv_** file **_without header and index_**, and **_only constrains one column which represents the true cluster_**, index needs to be **_the same_** as input dataset (even the csv file does not have the index)

## Semi-MultiCons generation
The Semi-MultiCons results of our test dataset can be generated from runing **_benchmark_multi_cons.R_**
