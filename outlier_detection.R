#####################################
# DETECT OUTLIERS IN CONSENSUS TREE #
#####################################


Cls_connctions <- data.frame(Stabl_Cons_Vctrs)
colnames(Cls_connctions) <- c(1:length(Stabl_Cons_Vctrs))
N_Col <- ncol(Cls_connctions)
Rmv_Inst <- NULL # list of conflicting instances that will be removed

for (i in N_Col:2) # it can start from N_Col-1 because at the 1st cons, there is no cluster that separates into 2 at the next level
{
  Sub_connctions <- data.frame(f= Cls_connctions[,i],t= Cls_connctions[,i-1])
  Freq <- data.frame(table(Sub_connctions))
  Freq <- Freq[Freq$Freq > 0,]
  Freq <- Freq[order(Freq$f,-Freq$Freq),]
  Prev <- 0
  for(j in 1:nrow(Freq))
  { 
    if (Freq$f[j] == Prev)
    {
      Rmv_Inst <- c(Rmv_Inst,which(Cls_connctions[,i]==Freq$f[j] & Cls_connctions[,i-1]==Freq$t[j]))
    }
    Prev <- Freq$f[j]  
  }
}
Rmv_Inst <- unique(Rmv_Inst)
rm(Cls_connctions,N_Col,Freq,Prev,i,j,DT_range, Sub_connctions)