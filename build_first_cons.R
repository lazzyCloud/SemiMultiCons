######################################################################
# BUILDS THE FIRST CONSENSUS: AGREEMENTS BETWEEN ALL BASE CLUSTERING #
######################################################################

Bi_Clust <- FCI[FCI$CS_size == max(FCI$CS_size),"Object.List"]
N_Row <- length(Bi_Clust)
ClustV <- rep(NA, times= Data_Size)
for(i in 1:N_Row)
{
  ClustV[Bi_Clust[[i]]] <- i
}
Cons_Vctrs[[Clstrings]] <- ClustV
