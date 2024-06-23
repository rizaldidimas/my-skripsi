totdis=function(rute,D){
  f=0
  k=lenght(rute)
  for (i in 1:(k-1)){
    f=f+D[rute[i],rute[i+1]]
  }
  return (f)
}
