sparse_PCA <- function(x){
K = x
indexK = c(1:K)
indexK = as.matrix(indexK)

###Algorithm 2: EM for sparse PCA
t <- 1
wt <- first_pc

y <- face.data.norm %*% wt

h <- norm(as.matrix(y),type="F")^2
f <- colSums(diag(as.vector(y)) %*% face.data.norm)
wstar <- f/h
awstar <- abs(wstar)

pi <- order(awstar,decreasing=TRUE)
###pii <- order(pi,decreasing=FALSE)
pimat <- mat.or.vec(D,D)
for (i in 1:D){
pimat[i,pi[i]] = 1}
s <- pimat %*% awstar

wtpo <- mat.or.vec(D,1)

saddfun <- function(x){
sadd = s[x]-s[x+1]
add.vec = mat.or.vec(D,1)
add.vec[1:x] = sadd
return(add.vec)}
saddoutput <- apply(indexK,1,saddfun)
wtpo <- rowSums(saddoutput)
wtpo <- t(pimat) %*% wtpo
wtpo <- (wtpo*sign(wstar))/norm(as.matrix(wtpo),type="F")

while (abs(t(wtpo) %*% wt) <= 1-e){
t <- t+1
wt <- wtpo
y <- face.data.norm %*% wt

h <- norm(as.matrix(y),type="F")^2
f <- colSums(diag(as.vector(y)) %*% face.data.norm)
wstar <- f/h
awstar <- abs(wstar)

pi <- order(awstar,decreasing=TRUE)
pimat <- mat.or.vec(D,D)
for (i in 1:D){
pimat[i,pi[i]] = 1}
s <- pimat %*% awstar

wtpo <- mat.or.vec(D,1)
saddoutput <- apply(indexK,1,saddfun)
wtpo <- rowSums(saddoutput)
wtpo <- t(pimat) %*% wtpo
wtpo <- (wtpo*sign(wstar))/norm(as.matrix(wtpo),type="F")
}

var = t(wtpo) %*% C %*% wtpo  
return(var)}
