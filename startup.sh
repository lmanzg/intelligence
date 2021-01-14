#!/bin/sh

#/bin/hostname arm201
# Set can
ifconfig can0 down
ifconfig can1 down
ifconfig can2 down
ifconfig can3 down
ip2 link set can0 type can bitrate 250000 restart-ms 20
ip2 link set can1 type can bitrate 250000 restart-ms 20
ip2 link set can2 type can bitrate 125000 restart-ms 20
ip2 link set can3 type can bitrate 250000 restart-ms 20
ifconfig can0 up
ifconfig can1 up
ifconfig can2 up
ifconfig can3 up

PRO_PATH="/program/pile/"

#check cron dir
myPath="/mnt/mmcblk0p1/"
if [ ! -d "$myPath" ];then
	echo "no file"
	return 0
else
	if [ ! -h "/mnt/mmc" ];then
		ln -s /mnt/mmcblk0p1/ /mnt/mmc
	fi
fi

myPath="/etc/cron/crontabs/"
if [ ! -d "$myPath" ]; then 
	mkdir -p "$myPath" 
fi

if [ ! -x "/program/pile/targz.sh" ]; then
	chmod 777 /program/pile/targz.sh
fi

if [ ! -x "/program/pile/deleteFileOld.sh" ]; then
	chmod 777 /program/pile/deleteFileOld.sh
fi


if [ -e "$PRO_PATH"root ]; then 
	cp "$PRO_PATH"root  "$myPath"
	myPath=`ps -ef|grep '\bcrond\b'|grep -v grep`
	if [ "$myPath" = "" ]; then
		crond
	fi
	myPath="/mnt/mmc/"
	if [ -d "$myPath" ]; then  
		#check bms dir
		myPath1="/mnt/mmc/bmsA/"
		if [ ! -d "$myPath1" ]; then 
			mkdir -p "$myPath1" 
		fi 
		myPath1B="/mnt/mmc/bmsB/"
		if [ ! -d "$myPath1B" ]; then 
			mkdir -p "$myPath1B" 
		fi

		#check tcu dir
		myPath2="/mnt/mmc/tcuA/"
		if [ ! -d "$myPath2" ]; then 
			mkdir -p "$myPath2" 
		fi 
		myPath2B="/mnt/mmc/tcuB/"
		if [ ! -d "$myPath2B" ]; then 
			mkdir -p "$myPath2B" 
		fi

		#check ini dir
		myPath3="/mnt/mmc/ini/"
		if [   -d "$myPath3" ]; then 
			cp /mnt/mmc/ini/* /program/pile/
		fi
		
		#check ftpsend dir
		myPath4="/mnt/mmc/ftpsendA/"
		if [ ! -d "$myPath4" ]; then 
			mkdir -p "$myPath4"
		fi 
		
		myPath5="/mnt/mmc/ftpsendB/"
		if [ ! -d "$myPath5" ]; then 
			mkdir -p "$myPath5"
		fi 

		hwclock -s --localtime
		# Set search library path
		export LD_LIBRARY_PATH=/lib:/usr/lib:/lib/qt485/lib:.
		nohup "$PRO_PATH"run_pile.sh >> /program/pile/my.log 2>&1 &
		if [ ! -x "/program/pile/guardPile.sh" ]; then      
        		chmod 777 "$PRO_PATH"guardPile.sh  
		fi		

		nohup "$PRO_PATH"guardPile.sh > /dev/null 2>&1 &
		
	fi
	exit 0
	echo "error start, do not found mmc/log file!"
fi
echo "error start, do not found root file"
