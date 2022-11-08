ps -ef | grep  "test.sh" |grep -v grep
if [ $? -eq 0 ];then
echo "Process Running"
else
	echo "IN ELSE"
	sleep 10
	echo "Sleep Finished"
fi

