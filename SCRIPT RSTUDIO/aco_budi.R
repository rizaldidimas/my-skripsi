totdis=function(rute,D){
  f=0
  k=lenght(rute)
  for (i in 1:(k-1)){
    f=f+D[rute[i],rute[i+1]]
  }
  return (f)
}


acs_budi=function(xy,iter,n_ants) {
#xt: koordinat of cities
#iter : number of max iteration
m=n_ants #number of ants.
n=dim(xy)[1]#%jumlah kota.
e=.5#;%evaporation coefficient.
alpha=2#;%order of effect of ants' sight.
beta=1#;%pangkat order of trace's effect.
f=0
mjarak=matrix(0,n,n)
for (i in 1:n){
   for (j in 1:n) {
   mjarak[i,j]=sqrt((xy[i,1]-xy[j,1])^2+(xy[i,2]-xy[j,2])^2+(xy[i,3]-xy[j,3])^2+(xy[i,4]-xy[j,4])^2+(xy[i,5]-xy[j,5])^2+(xy[i,6]-xy[j,6])^2+(xy[i,7]-xy[j,7])^2+(xy[i,8]-xy[j,8])^2+(xy[i,9]-xy[j,9])^2)
#%menghitung jarak antar kota
}
}
h=matrix(0,n,n)
for (i in 1:n){ #generating sight matrix.
for (j in 1:n){
if (i==j) {
  h[i,j]=0}
else {
  h[i,j]=1/mjarak[i,j]#;%inverse distance
}
}
}
rute=matrix(0,m,n) # m:number of ants
thoinit=0.1*matrix(1,n,n)#%initial tho.
#el=.96;%coefficient of common cost elimination. 
for (i in 1:iter){
   for (i in 1:m){
  #%ants initial placing.
   rute[i,1]=1 #ants start from city 1
   }
  #%ant tour 
  for (i in 1:m){ #%for all ants
  #h #invers distance matrix
   for (j in 1:(n-1)){ #next node
    c=rute[i,j] #%choose next city to visit
    h[,c]=0 #%for column c,inv distance=0
    tho=(thoinit[c,]^beta)*(h[c,]^alpha) #%update pheromone
    s=sum(tho) #jumlah tho 
    p=(1/s)*tho #probability 
    rd=runif(1)
    s=0
    for (k in 1:n){ #number of city
    s=s+p[k] #use roulette wheel
      if(is.na(rd > s)){
      rute[i,j+1]=k
      break
      #penempatan semut i di simpul berikutnya
    }
    }
   }
  }
#resulting tour/route
rute_c=cbind(rute,rute[,1]) #add first city to the tour/route
#print(rute_c)
#compute total distance of path traverse by each ant
  for (i in 1:m) { #number of ant
  f[i]=totdis(rute_c[i,],mjarak)
  }
  jaraktot=f
  idk=which.min(f)
  ter=rute_c[idk,]
  #f=f-el*min(f);%elimination of common cost.
  #update edge belonging to Lbest
  thoinit=(1-e)*thoinit
 for (i in 1:m){ # for all ant
#for ( i in 1:idk) {
   for (j in 1:(n-1)){ #% for all cities
   dt=1/f[i] #inverse total distance, delta pheromone
   #update pheromone
   thoinit[rute_c[i,j],rute_c[i,j+1]]=thoinit[rute_c[i,j],rute_c[i,j+1]]+dt
   #updating traces.
   }
  }
}
besttour=ter #rute terbaik
mincost=totdis(ter,mjarak) #jarak total rute terbaik
return(list(besttour,mincost))
}
