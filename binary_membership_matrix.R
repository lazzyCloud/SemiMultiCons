##############################################################################################
# GENERATES THE BINARY MEMBERSHIP MATRIX THAT WILL BE PROCESSED BY CLOSED PATTERN EXTRACTION #
##############################################################################################

rnum <- Data_Size
rnames <- c(1:rnum)
Clstrings <- length(Results)
All_Matrix <- as.data.frame(matrix(nrow = rnum,ncol = 0,dimnames = list(rnames)))
for(j in 1:Clstrings)
{
  Cluster <- Results[[j]]
  CL <- unique(Cluster)
  Clust_Labls <- sort(CL)
  N_Clustrs <- length(CL)
  cnames <- paste(Methods[j],"C",Clust_Labls,sep="")
  BMatrx <- as.data.frame(matrix(data = F, nrow = rnum, ncol = N_Clustrs, dimnames = list(rnames,cnames)))
  for(i in 1:N_Clustrs)
      {BMatrx[Cluster==Clust_Labls[i],i]<-T}
  All_Matrix <- cbind(All_Matrix,BMatrx)
}
rm(i,j,rnum,rnames,Cluster,cnames,BMatrx,CL,N_Clustrs,Clust_Labls)