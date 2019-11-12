library(fpc)

Stp <- 0.1
Cnt <- 0

MaxItr <- 100

repeat
{
  Cnt <- Cnt + 1
  if (Cnt==MaxItr) break
  Clustering <- dbscan(data = X, eps = Eps,MinPts = MinP,scale = F,method = DBSCN_mthd, seeds = F)
  print(Clustering)
  Cluster <- Clustering$cluster
  N_Clstr <- max(Cluster)
  if (N_Clstr==0)
  {
    Eps <- Eps + Stp
    Cluster <- Cluster + 1
    N_Clstr <- N_Clstr + 1
  }
  else
  {
    if (min(Cluster)==0)
    {
      Cluster <- Cluster + 1
      N_Clstr <- N_Clstr + 1
    }
    if (N_Clstr == K) break
    else if (N_Clstr < K) { Eps <- Eps - Stp }
    else if (N_Clstr > K) { Eps <- Eps + Stp }
  }
  Stp <- runif(1,0,3)
  if (Eps < 0) {Eps <- 0}
}
rm(Stp,N_Clstr,Cnt,MaxItr)
