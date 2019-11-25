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
The Semi-MultiCons results of our test dataset can be generated from runing **_benchmark_multi_cons.R_**. Similar as base clustering generation, our input parameters can be find in the comments of R script.
For example line 1 - line 9 and line 58 - line 67 of **_benchmark_multi_cons.R_** : 
```
#--------------------#
# Iris dataset input #
#--------------------#
LinkFolder <- "constraints/iris1/"
#LinkFolder <- "constraints/iris2/"
#LinkFolder <- "constraints/iris3/"
#LinkFolder <- "constraints/iris4/"
#LinkFolder <- "constraints/iris5/"
conNumList <- seq(0.0004,0.02,0.0004)

# ignored codes here 

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
```
### If you want to generate your own Semi-MultiCons result with our implementation
The following input parameters should be provided in **_benchmark_multi_cons.R_**: 
- **LinkFolder** : the repository where all must link constraints and cannot link constraints are provided. The constraints for our test dataset can be find under **./constraints/dataset name + repeated time**. When providing your constraints, the file should be named as **m_dataset name_percentage of constraints_timestamp.csv** or **c_dataset name_percentage of constraints_timestamp.csv**. **m** indicates must-link file while **c** indicates cannot-link file. **percentage of constraints** represents how much supervised information the constraints give, for example, **0.004** for iris dataset means **_29_** cannot-link constraints and **_14_** must-link constraints because in total, iris dataset has **150*(150-1)/2=11175** constraints, thus **0.004** supervised information means **11175*0.004=44.7** constraints. In iris dataset, the total ratio of must-link and cannot-link is 1:2, results in **29** cannot-link constraints and **14** must-link constraints (we always use a floor function instead of round function). The content of a constraint file should be two columns, each line represents a pair of instances, **_without index or header_**.
- **conNumList** : the list of constraints to test Semi-MultiCons. The constraints is always represented by percentage of supervised information. The three float numbers respectively represent **start**, **end** and **step**
- **InDir** : where to read the base clusterings, by default it should be **./ensemble members/dataset name/**
- **Name** : name of the dataset, will not change any Semi-MultiCons results, just give a name to your execution
- **OutDir** : where to store the generated Semi-MultiCons results

