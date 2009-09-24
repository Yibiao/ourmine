BEGIN {
	FS = ","
	chewHeader()
}


function chewHeader() {
	while (getline) {
		if ($1 ~ /^[ 	/t]$/) { continue }
		if ($1 ~ /^%/) {continue}
		if ($1 ~ /^@relation/) { continue }
		if ($1 ~ /^@attribute/) { continue }
		if ($1 ~ /^@data/) { dump() }
	}
}

function dump() {
	while (getline) {
		printf "'("
		gsub("'","\"",$0)
		gsub(" ","",$0)
		for (i=1; i<NF; i++)
			printf $i " "
		print $NF")"
	}
}
