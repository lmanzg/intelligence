
while [ 1 ]; do
	#判断进程是否存在，如果不存在就启动它
	PIDS=`ps -ef |grep pileMonitor |grep -v grep | awk '{print $2}'`

	if [ "$PIDS" == "" ]; then
		nohup /program/pile/run_pile.sh >> /program/pile/my.log 2>&1 &
		sleep 10
	fi
	sleep 5

done

