library(clue)
Indx <- NULL
for(i in 1:(Clstrings-1))
{
  for (j in (i+1):Clstrings)
  {
    Simlr <- cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(Results[[i]])), y= as.cl_hard_partition(as.cl_class_ids(Results[[j]])), method = "Jaccard")
    if (is.na(Simlr)) {Simlr <- 0}
    if (Simlr == 1)
    {
      cat("i=",i,"j=",j,"jaccard=",Simlr,",thus",j,"is removed.",'\n') 
      Indx <- c(Indx,j)
    }
    else if (Simlr >= 0.90)
    {
      cat("i=",i,"j=",j,"jaccard=",Simlr,'\n') 
    }
  }
}
if (!is.null(Indx)) {
  Indx <- unique(Indx)
  Methods <- Methods[-Indx] 
  Results[Indx] <- NULL
  Clstrings <- length(Results)
}

rm(j,Simlr,Indx)
