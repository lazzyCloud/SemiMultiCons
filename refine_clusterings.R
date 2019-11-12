Indx <- NULL
for (i in 1:Clstrings)
{
  N_Row <- nrow(Results[[i]])
  Sizes <- table(Results[[i]])
  if (any(Sizes / N_Row >= 0.9)) { Indx <- c(Indx,i)}
}
if (length(Indx)>0)
{
  print("The following base clustering(s) is(are) bad and removed:")
  for(i in Indx)
  {
    cat(Methods[i],table(Results[[i]]),'\n')
  }
  Methods <- Methods[-Indx,] 
  Results[Indx] <- NULL
  Clstrings <- length(Results)
}
rm(N_Row,Sizes,Indx)
