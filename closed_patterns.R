###################################################################
# GENERATES THE CLOSED PATTERNS FROM THE BINARY MEMBERSHIP MATRIX #
###################################################################

library(arules)

options(stringsAsFactors = FALSE)

if (exists("FCI")) {
  cat("Using existing FCI closed patterns.\n")
  return
  } else {
  T1 <- Sys.time()
  Transactional <- as(All_Matrix, "transactions")
  A_Rules <- apriori(data = Transactional, parameter = list(support= 1/Data_Size , target="closed frequent itemsets", confidence=1, maxlen=Clstrings))
  Combined <- supportingTransactions(x = A_Rules, transactions = Transactional)
  FCI <- data.frame(inspect(Combined),size(Combined))
  colnames(FCI)<-c("ClosedSet","Object.List","Support")
  row.names(FCI) <- NULL
  FCI$ClosedSet <- substr(FCI$ClosedSet,2,nchar(FCI$ClosedSet)-1)   # remove { } from the string
  FCI$Object.List <- substr(FCI$Object.List,2,nchar(FCI$Object.List)-1)   # remove { } from the string
  FCI$ClosedSet <- strsplit(FCI$ClosedSet,split = ",")   # split the string into items
  FCI$Object.List <- strsplit(FCI$Object.List,split = ",")   # split the string into objects
  FCI$Object.List <- sapply(FCI$Object.List,as.integer)   # convert the objects into integers
  FCI$CS_size <- sapply(FCI$ClosedSet,length)
  Clstrings <- max(FCI$CS_size)
  FCI <- FCI[order(FCI$Support),]
  T2 <- Sys.time()
  rm(A_Rules,Combined,Transactional)
  cat("# of patterns=",nrow(FCI),'\n')
  Tme_FCI <- difftime(T2,T1,units = "sec")
  cat("FCP generation time",Tme_FCI,"sec.",'\n')
  rm(T1,T2)
}