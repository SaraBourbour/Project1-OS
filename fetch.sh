#!/bin/bash


# A POSIX variable

# Initialize our own variables:


hostname=""

filename=""

path=""


#t='.mines.edu'

#make temp directory
tmpdir=$(mktemp -d)
# Fetching Machine Data

flagn=false
flagf=false
flagd=false

function dataFetch () {
	if [ "$flagd" = false ]
		then
		path="temp"
	fi
	if [ -d "$path" ]
		then
		rm -rf "$path"
		mkdir "$path"
	else 
		mkdir "$path"
	fi


	if [ "$flagn" = true -a "$flagf" = false ]
	then
		ssh  -o "StrictHostKeyChecking=no" -n $hostname "echo 'Users: ' ;(users | wc -w);  
					echo 'Sleeping:';(ps hax -o s | grep -c S);
					echo 'Running:';(ps hax -o s | grep -c R);
					echo 'Stopped:';(ps hax -o s | grep -c T);
					echo 'Zombie:';(ps hax -o s | grep -c Z);
					echo 'Idle:';(ps hax -o s | grep -c I);
					echo '1 minute:';(cat /proc/loadavg | awk '{print \$1}');
					echo '5 minute:';(cat /proc/loadavg | awk '{print \$2}');
					echo '15 minute:';(cat /proc/loadavg | awk '{print \$3}')"> $path/$hostname.txt #<< EOF #> $tmpdir/$1
	fi
	if [ "$flagf" = true -a "$flagn" = false ]
	then
		for line in $( cat $filename ); do
			
			ssh  -o "StrictHostKeyChecking=no" -n $line "echo '$line'; echo 'Users: ' ;(users | wc -w);  
					echo 'Sleeping:';(ps hax -o s | grep -c S);
					echo 'Running:';(ps hax -o s | grep -c R);
					echo 'Stopped:';(ps hax -o s | grep -c T);
					echo 'Zombie:';(ps hax -o s | grep -c Z);
					echo 'Idle:';(ps hax -o s | grep -c I);
					echo '1 minute:';(cat /proc/loadavg | awk '{print \$1}');
					echo '5 minute:';(cat /proc/loadavg | awk '{print \$2}');
					echo '15 minute:';(cat /proc/loadavg | awk '{print \$3}')"> $path/$line.txt #temp4.txt
			
		done
	fi
#How many users are currently logged in
if [ "$flagf" = true -a "$flagn" = true ]
	then
		echo "please have -n or -f and not both"
	fi
}





while getopts "d:n:f:" opt; do

case "$opt" in
d)
  flagd=true
   path=$OPTARG
;;
n)
 flagn=true
	#echo $OPTARG
  hostname=$OPTARG
 dataFetch $hostname

  ;;

f)

	#echo here
  flagf=true
  filename=$OPTARG

  dataFetch $filename
  ;;

\?)
	echo "Unkown argument, exiting"
	exit 1
;;

 

esac

done

if [ "$flagf" = false -a "$flagn" = false ]
	then
		echo "please have either-n or -f "
	fi



if [ "$path" = "temp/" ]
	then
	echo "file(s) saved to temp"
else
	echo "file(s) saved to $path"
fi
exit 0
