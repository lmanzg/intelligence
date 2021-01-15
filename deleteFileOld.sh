deleteNum=$2

FileName="/mnt/mmc/log/remainingFileSize.log"

if [ -f "$FileName" ]; then
	FileSize=`ls -l $FileName | awk '{ print $5 }'`
	MaxSize=$((10240*10))
	if [ $FileSize -gt $MaxSize ]; then
		rm $FileName
	else
		echo "$FileSize < $MaxSize "
	fi
fi

FileDir=$1
if [ ! -d "$FileDir" ]; then
	exit 0
fi

cd $FileDir

if [ $3 -eq 0 ]; 
then
    file=` ls -rt  *.log*| head -1 `

    Ltime=`stat $file | grep Modify | awk '{print $2}' `
    echo $Ltime
    time=`date  '+%Y-%m-%d'`
  
    time1=`date +%s -d $time`
    time2=`date +%s -d $Ltime`
    dat=` expr $time1 - $time2 `    #second
    dat=` expr $dat / 60 `          #branch
    dat=` expr $dat / 60 `          #Time
    dat=` expr $dat / 24 `          #day
    dat=` expr $dat - 1 `           #day
    echo $dat
    echo $deleteNum
    if [ $deleteNum -le $dat ];
    then
    	dat=$(($dat - $deleteNum)) 			#deleteDay
    	echo $deleteNum	
    	echo $dat
    	deleteNum=` find $FileDir -name "*.log*" -mtime +$dat | wc -l `
    	echo "-----$deleteNum"
    else	
    	dat=` expr $dat + 1 `
    	deleteNum=` find $FileDir -name "*.log*" -mtime -$dat | wc -l `
    	echo "--2---$deleteNum"
    fi
   
    if [ $deleteNum -le 0 ];
    then
        exit 1
    fi
fi
echo 11111
num=0
while :
do	
	if [ $num -eq $deleteNum ]; then
		exit 1	
	fi
	OldFile=$(ls -rt  *.log*| head -1)

	if [ ! -f "$OldFile" ]; then
		exit 1
	fi

	echo  "Delete File:" $OldFile
	rm -rf $OldFile
	let num=num+1
	echo $num
done
