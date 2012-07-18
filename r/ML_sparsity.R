face.data =read.csv("facedata.csv",header=FALSE)

###Normalize face data so that each dimension has mean zero and variance 1
face.means = colMeans(face.data)
face.var = diag(cov(face.data))

normalize <- function(x){
M = face.means[x]
V = face.var[x]^(1/2)
a = (face.data[,x]-M)/V
return(a)}

D = 361
N = 2429
e = .0001
indexD = c(1:D)
indexD = as.matrix(indexD)
indexN = c(1:N)
indexN = as.matrix(indexN)

face.data.norm = apply(indexD,1,normalize)
C = cov(face.data.norm)

t <- 1
wt_start <- as.matrix(runif(D,0,1))
wt_start <- as.vector(wt_start/norm(wt_start,type="F"))

wt <- wt_start
y <- face.data.norm %*% wt
h <- norm(as.matrix(y),type="F")^2
f <- colSums(diag(as.vector(y)) %*% face.data.norm)

wtpo <- as.vector(f/h)
wtpo <- as.vector(wtpo/norm(as.matrix(wtpo),type="F"))

while (abs(t(wtpo) %*% wt) <= 1-e){
t <- t+1
wt <- wtpo

y <- face.data.norm %*% wt
h <- norm(as.matrix(y),type="F")^2
f <- colSums(diag(as.vector(y)) %*% face.data.norm)

wtpo <- as.vector(f/h)
wtpo <- as.vector(wtpo/norm(as.matrix(wtpo),type="F"))
}

first_pc <- wtpo

####################################################################################
##################   Sparcity Algorithm     ########################################
####################################################################################
source("sparse_PCA.R")
indexvar = c(1:150)
indexvar = as.matrix(indexvar)
sparse_PCA_var = apply(indexvar,1,sparse_PCA)




