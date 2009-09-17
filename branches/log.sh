cd $1
svn update
rm -f *.log
svn log | 
fgrep "|" | 
fgrep -v menzies |
fgrep -v RabiTuckman |
tac| 
gawk -F"|" '{$2=nospace($2) 
		     ++commits[$2]
			 now=mydate($3)
			 if( now != last) 
				for(i in commits) {
			 		file=i".log"
					report =last  "\t" commits[i]
					print report>>file
				}
			 last = now
}
END{				for(i in commits) {
			 		file=i".log"
					report =last  "\t" commits[i]
					print report>>file
				}
}
function nospace(str) {
  gsub(" ","",str)
  gsub(/@.*/,"",str)
  return str
}
function symbol(s) {
   if (s in Sym) return Sym[s]
   return Sym[s]=++Sum[0]
}
function mydate(str) {
  split(str,tmp1," ")
  split(tmp1[1],tmp2,"-")
  gsub(/^0/,"",tmp2[2])
  gsub(/^0/,"",tmp2[3])
  return tmp2[2]*31 + tmp2[3]
}
END { for(i in Sym) print i " = " Sym[i]}
' 

all=`ls *.log`
for i in $all; do
	Title="$Plot $Sep $i"
	Plot="$Plot $Sep \"$i\""
	Sep=","
done
(echo
echo "=== Cumulative Commits ============================================="
echo 
date
echo $Title
gnuplot<<EOF
set key bottom right
set xrange [250:360]
set terminal dumb
plot $Plot
EOF
) > commits.txt
svn add commits.txt
svn commit -m "commit log"
cat commits.txt
