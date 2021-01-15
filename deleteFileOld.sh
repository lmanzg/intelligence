if [ $# -lt 1 ]; then
	echo "error:The parameter is less than 1"
	exit 1
fi
######################################################
#			根据日志文件大小 删除日志文件
#
#FileName="/mnt/mmc/log/remainingFileSize.log"
#
#if [ -f "$FileName" ]; then
#	FileSize=`ls -l $FileName | awk '{ print $5 }'`
#	MaxSize=$((10240*10))
#	if [ $FileSize -gt $MaxSize ]; then
#		rm $FileName
#	else
#		echo "$FileSize < $MaxSize "
#	fi
#fi
######################################################

FileDir=$1
deleteNum=$2

if [ ! -d "$FileDir" ]; then
	echo "error:Parameter 1  Path error"
	exit 1
fi

cd $FileDir
if [ $# -eq 3 ]; 
then
    file=` ls -rt  *.log*| head -1 `

    if [ ! -f "$file" ];
    then
    	echo "No log File"
		exit 1
    fi 

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
    
    if [ $deleteNum -le $dat ];
    then
    	dat=$(($dat - $deleteNum)) 			#deleteDay
    	
    	deleteNum=` find $FileDir -name "*.log*" -mtime +$dat | wc -l `
    else	
    	dat=$deleteNum
    	deleteNum=` find $FileDir -name "*.log*" -mtime -$dat | wc -l `
	fi
   
    if [ $deleteNum -le 0 ];
    then
    	echo "There are no deleted files"
        exit 1
    fi
fi

num=0
while :
do	
	if [ $num -eq $deleteNum ]; then
		exit 1	
	fi
	OldFile=$(ls -rt  *.log*| head -1)

	if [ ! -f "$OldFile" ]; then
		echo "no log file"
		exit 1
	fi

	echo  "Delete File:" $OldFile
	rm -rf $OldFile
	let num=num+1
	echo $num
done
