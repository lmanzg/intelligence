
FileDir=$1
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


if [ ! -d "$FileDir" ]; then
	exit 0
fi

cd $FileDir
echo $FileDir
num=0
while :
do
	if [ $num -eq $deleteNum ]; then
		exit 0	
	fi
	OldFile=$(ls -rt  *.log*| head -1)

	if [ ! -f "$OldFile" ]; then
		exit 0
	fi

	echo  "Delete File:" $OldFile
	rm -rf $OldFile
	let num=num+1
	echo $num
done

