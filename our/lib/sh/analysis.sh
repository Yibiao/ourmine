median(){

awk 'BEGIN{p[cnt++]=$0;}
     {p[cnt++]=$0;}
     END{print median(p,cnt)}

     function median(p,max){
       for(i=0;i<max;i++)
       for(j=1;j<max;j++){
          if(p[j] < p[j-1]){
             tmp=p[j-1]; p[j-1]=p[j]; p[j]=tmp;
          }
       }

       middle=max/2;
       max%2 != 0.0 ? med=(p[middle-0.5]+p[middle+0.5])/2 : med=p[middle];
       return med
     }'
}

acc(){
    awk '/Correctly/{print $5}' | head -n 1
}

extractGoals(){
    local goal=$1
    local prefix=$2
    local file=$3

    cat $file | abcd --prefix $prefix --goal $goal --decimals 1 
}