#!/bin/sh
export ORACLE_HOME=/home/oracle/dbase/db_1/
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export CCBS_BATCH_PROCS_HOME=/home/cbsrating/Rating/batchProcs/

cd /home/cbsrating/Rating/batchProcs/bin/
ps -ef | grep  gsmrating | grep -v grep

if [ $? == 0 ]
then
        echo "Executing gsmrating"

        ./gsmrating

        echo "Initiated gsmrating"
else
        echo "Process is already running"
fi

