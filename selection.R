N <- length(Stabl_Cons_Vctrs)
Similr <- rep(0,times=N)
for (i in 1:N)
{
  for (j in 1:Clstrings)
  {
    Sim <- cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(Stabl_Cons_Vctrs[[i]])), y= as.cl_hard_partition(as.cl_class_ids(Results[[j]])), method = "Jaccard")
    Similr[[i]] <- Similr[[i]] + Sim
  }
  Similr[[i]] <- Similr[[i]]/Clstrings
}
Bst_Cons <- which.max(Similr)
mConNum <- 0
if (!is.null(Must_Link))
  mConNum <- nrow(Must_Link)
cConNum <- 0
if (!is.null(Cannot_Link))
  cConNum <- nrow(Cannot_Link)
Similr_con <-  rep(0,times=N)
if ((mConNum == 0) && (cConNum == 0)) {
  Bst_Cons_con <- which.max(Similr)
} else {

  for (i in 1:N)
  {
    if (mConNum != 0) {
      Sim1 <- Stabl_Cons_Vctrs[[i]][Must_Link$row] == Stabl_Cons_Vctrs[[i]][Must_Link$col]
      Sim3 <- Stabl_Cons_Vctrs[[i]][Must_Link$row] != Stabl_Cons_Vctrs[[i]][Must_Link$col]
      
    } else {
      Sim1 <- 0
      Sim3 <- 0
    }
    
    if (cConNum != 0) {
      Sim2 <- Stabl_Cons_Vctrs[[i]][Cannot_Link$row] != Stabl_Cons_Vctrs[[i]][Cannot_Link$col]
      Sim4 <- Stabl_Cons_Vctrs[[i]][Cannot_Link$row] == Stabl_Cons_Vctrs[[i]][Cannot_Link$col]
      
    } else {
      Sim2 <- 0
      Sim4 <- 0
    }
    Similr_con[[i]] <- (sum(Sim1) + sum(Sim2) - sum(Sim3) - sum(Sim4))#/length(unique(Stabl_Cons_Vctrs[[i]]))
  }
  Bst_Cons_con <- which.max(Similr_con)
}

rm(Sim1, Sim2, Sim3, Sim4)


rm(N,Sim,i,j)

