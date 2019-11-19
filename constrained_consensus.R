#################################
# CONSTRAINED CONSENSUS PROCESS #
#################################

library(clue)


T1 <- Sys.time()

# build first consensus
Cons_Vctrs <- list()
source("build_first_cons.R")


# build multiple consensuses:
DT_range <- c((Clstrings-1):1)
for (DT in DT_range)
{
  Bi_Clust <- c(Bi_Clust,FCI[FCI$CS_size == DT,"Object.List"])
  N_Row <- length(Bi_Clust)
  #cat(DT, ' level consensus start.\n')
  repeat
  {
    Rpt_Chk <- F
    for(i in 1:N_Row)
    {
      Xi <- Bi_Clust[[i]]
      XiL <- length(Xi)
      if (XiL==0){next}
      for (j in 1:N_Row)
      {
        if (j==i){next}
        Xj <- Bi_Clust[[j]]
        XjL <- length(Xj)
        Intrs_Size <-length(intersect(Xi,Xj))
        if ( Intrs_Size==0 || XjL==0 ){next}

        scorek <- 0
        scorekj <- 0
        scoreki <- 0
        
        #Xk <- sort(union(Xi,Xj))
        Xkk <- intersect(Xi,Xj)
        Xkj <- setdiff(Xj,Xi)
        Xki <- setdiff(Xi,Xj)
        
        temp_kkk <- intersect(Xkk, cons_n)
        temp_jjj <- intersect(Xkj, cons_n)
        temp_iii <- intersect(Xki, cons_n)
        
        scorek <- 0
        scoreki <- 0
        scorekj <- 0
        
        #for (iii in temp_iii) {
        #  for (jjj in temp_kkk) {
        #    temp <- paste(toString(iii),toString(jjj),sep='_')
        #    if (!is.null(constraints[[temp]]))
        #      scoreki <- scoreki - constraints[[temp]]
        #  }
        #  for (jjj in temp_jjj) {
        #    temp <- paste(toString(iii),toString(jjj),sep='_')
        #  
        #    if (!is.null(constraints[[temp]]))
        #      scorekj <- scorekj - constraints[[temp]]
        #  }
        #}

        #for (iii in temp_kkk)
        #  for (jjj in temp_jjj) {
        #    temp <- paste(toString(iii),toString(jjj),sep='_')
        #    
        #    if (!is.null(constraints[[temp]]))
        #      scorek <- scorek + constraints[[temp]]
        #  }
        #scoreki <- -1 * scoreki
        #scorekj <- -1 * scorekj
        if ((length(temp_iii) > 0) && (length(temp_kkk) > 0) && (length(Xki) > 0) && (length(Xkk) > 0)) {
          scoreki = -sum(constraints[unname(values(idx_list, keys=as.character(Xkk))),
                                     unname(values(idx_list, keys=as.character(Xki)))])
        }
        if ((length(temp_jjj) > 0) && (length(temp_kkk) > 0) && (length(Xkj) > 0) && (length(Xkk) > 0)) {
          scorekj = -sum(constraints[unname(values(idx_list, keys=as.character(Xkk))),
                                     unname(values(idx_list, keys=as.character(Xkj)))])       
        }
        if ((length(temp_iii) > 0) && (length(temp_jjj) > 0) && (length(Xki) > 0) && (length(Xkj) > 0)) {
          scorek = sum(constraints[unname(values(idx_list, keys=as.character(Xki))),
                                    unname(values(idx_list, keys=as.character(Xkj)))])
        }
        #scoreki = -sum(constraints[Xkk,Xki])
        #scorekj = -sum(constraints[Xkk,Xkj])
        #scorek = sum(constraints[Xki,Xkj])
        
        if (scorek == 0 && scoreki == 0 && scorekj == 0) {
          if (Intrs_Size==XiL)
          {
            Bi_Clust[[i]]<-integer(0)   # set Xi to empty to remove it later
            break
          }
          else if (Intrs_Size==XjL)
          {
            Bi_Clust[[j]]<-integer(0)   # set Xj to empty to remove it later
            next
          }
          else if ((Intrs_Size >= XiL*MT)||(Intrs_Size >= XjL*MT))
          { # merge bi_clusters Xi and Xj
            Rpt_Chk <- T
            Bi_Clust[[j]] <- sort(union(Xi,Xj))
            Bi_Clust[[i]] <- integer(0)
            break
          }  else  
          { # split bi_clusters Xi and Xj
            Rpt_Chk <- T
            if (XiL <= XjL)
            { 
              Bi_Clust[[j]] <- setdiff(Xj,Xi)
            }
            else
            {
              Xi <- Bi_Clust[[i]] <- setdiff(Xi,Xj)
              XiL <- length(Xi)
            }
          }
        } else {

          Rpt_Chk <- T
          scorek <- scorek / (length(Xki) + length(Xkj))
          scoreki <- scoreki / length(Xi)# / length(Xkk)
          scorekj <- scorekj / length(Xj) #/ length(Xkk)
          if ((scorek  >= scoreki)&& (scorek >= scorekj))
          { # merge bi_clusters Xi and Xj
            Bi_Clust[[j]] <- sort(union(Xi,Xj))
            Bi_Clust[[i]] <- integer(0)
            break
          }  
          else  
          { # split bi_clusters Xi and Xj
            #print("split")
            if (scoreki <= scorekj)
            { 
              Bi_Clust[[j]] <- setdiff(Xj,Xi)
            }
            else
            {
              Xi <- Bi_Clust[[i]] <- setdiff(Xi,Xj)
              XiL <- length(Xi)
            }
          }
        }
        
      } # end for j
    } # end for i
    if (Rpt_Chk==F) {break}
  } # end repeat
  # Build final clusters
  Bi_Clust <- unique(Bi_Clust)
  Bi_Clust <- Bi_Clust[sapply(Bi_Clust,length)>0]
  N_Row <- length(Bi_Clust)
  ClustV <- NA
  for(i in 1:N_Row)
  {
    Indx <- Bi_Clust[[i]]
    if (all(is.na(ClustV[Indx]))) {ClustV[Indx] <- i} else {cat("error! cluster vector overwritten at DT =",DT,", final Bi-clusters are not unique.",'\n')}
  }
  Cons_Vctrs[[DT]] <- ClustV
}

DT_range <- c(1:Clstrings)



rm(Bi_Clust,ClustV,DT,Intrs_Size,Xi,Xj,XiL,XjL,N_Row,Rpt_Chk,Indx)
rm(scorek,scoreki,scorekj, Xk, Xki, Xkj, Xkk, temp_iii, temp_jjj, temp_kkk)

Stability <- 1
# calculate the stability of consensus results
for(i in Clstrings:2)
{
  if (is.na(Cons_Vctrs[i])){next}
  SimC <- 1
  for (j in (i-1):1)
  {
    if (is.na(Cons_Vctrs[j])){next}
    Simlr <- cl_agreement(x= as.cl_hard_partition(as.cl_class_ids(Cons_Vctrs[[i]])), y= as.cl_hard_partition(as.cl_class_ids(Cons_Vctrs[[j]])), method = "Jaccard")
    if (Simlr==1)
    {
      SimC <- SimC + 1
      Cons_Vctrs[[j]] <- NA
      Stability[[j]] <- NA
      DT_range[j] <- NA
    }    
  }
  Stability[i] <- SimC
}

Stabl_Cons_Vctrs <- Cons_Vctrs[!is.na(Cons_Vctrs)]
Stability <- Stability[!is.na(Stability)]
DT_range <- na.omit(DT_range) 

rm(Cons_Vctrs,SimC,Simlr)
#rm(i, iii, j, jjj, scorek, scoreki, scorekj, Xi, XiL, Xj, XjL, Xk, Xki, Xkj, Xkk)

#for(i in length(DT_range):1)
#{
#  cat("DT=",DT_range[i],"     ST=",Stability[i],"     N of clusters =",max(Stabl_Cons_Vctrs[[i]]),"\n")
#  cat("Clusters sizes:")
#  print(table(Stabl_Cons_Vctrs[[i]]))
#  cat("___________________________________________\n\n")  
#}
T2 <- Sys.time()
Tme_consensus <- difftime(T2,T1,units = "sec")
cat("method 2 execution time",Tme_consensus,"sec.",'\n')

T3 <- Sys.time()
#Must_Link <- as.data.frame(which(constraints == 1, arr.ind = T))
#Cannot_Link <- as.data.frame(which(constraints == -1, arr.ind = T))
source("selection.R")
T4 <- Sys.time()
Tme_selection <- difftime(T4,T3,units = "sec")
cat("selection execution time",Tme_consensus,"sec.",'\n')


rm(T1,T2,T3,T4)
