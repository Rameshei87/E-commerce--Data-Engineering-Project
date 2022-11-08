#!/usr/bin/bash


datetag=`date +'%Y%m%d'`

logMsg() {
        mType=$1
        mText=$2
        mTime=`date '+%Y:%m:%d %H:%M:%S'`
        mProg=`basename $0`
        echo "$mTime|$mType|[$$]|$mProg|$mText" >> ${_logFile}
}

GSM_CSV="GSM.csv"
GPRS_CSV="GPRS.csv"
MMS_CSV="MMS.csv"
OUTPUT_PATH=/home/cbsrating/Rating/batchProcs/CSV/
LOG_FILE_DIR=/home/cbsrating/Rating/batchProcs/logs/
DB_CONNECTION=CBS_APPS/CBS_APPS@CBS

today=`date "+%Y%m%d"`
_logFile="RatedCdrsToDWH_$today.log"


cd $OUTPUT_PATH 


function csvgeneration()
{
calltype=$1
csv=$2
echo $calltype
echo $csv

logMsg  "INFO" "CALL TYPE IS $calltype"	

columns=`sqlplus -silent $DB_CONNECTION <<SQL_QUERY
set pagesize 0 feedback off verify off heading off echo off

select COLUMN_NAMES_V from CB_CSV_FILE_GENERATION a where CALL_TYPE_V='$calltype';

SQL_QUERY`

logMsg  "INFO" "Fetched columns for $calltype IS $columns"	

clause=`sqlplus -silent $DB_CONNECTION <<SQL_QUERY
set pagesize 0 feedback off verify off heading off echo off

select WHERE_CLAUSE_V from CB_CSV_FILE_GENERATION a where CALL_TYPE_V='$calltype';

SQL_QUERY`

logMsg  "INFO" "Fetched clause for $calltype IS $clause"	

csvnames=`sqlplus -silent $DB_CONNECTION <<SQL_QUERY
set pagesize 0 feedback off verify off heading off echo off

select CSV_NAMES_V from CB_CSV_FILE_GENERATION a where CALL_TYPE_V='$calltype';

SQL_QUERY`

logMsg  "INFO" "Header name of columns for $calltype IS $csvnames"	


count=`sqlplus -silent $DB_CONNECTION <<SQL_QUERY
set pagesize 0 feedback off verify off heading off echo off


select count(1) from ${calltype}_HOME_CDRS where ${clause};

SQL_QUERY`

logMsg  "INFO" "No of rows fetched for $calltype IS $count"

$ORACLE_HOME/bin/sqlplus -s $DB_CONNECTION<<EOF
SET PAGESIZE 50000 COLSEP "," LINESIZE 30000 FEEDBACK OFF heading off
SET NUMWIDTH 30

SPOOL ${csv}
 
select '$csvnames' from dual;

select ${columns} from ${calltype}_HOME_CDRS where ${clause};

SPOOL OFF
EXIT
EOF

}

_logFile=$LOG_FILE_DIR$_logFile

logMsg  "INFO" "Process Started"	

csvgeneration GSM "$GSM_CSV" 
csvgeneration GPRS "$GPRS_CSV" 
csvgeneration MMS "$MMS_CSV" 

logMsg  "INFO" "Process completed successfully"	

awk 'NF > 0' $GSM_CSV  > out.txt
mv out.txt $GSM_CSV
mv GSM.csv 'GSM_'$datetag.csv

awk 'NF > 0' $GPRS_CSV  > out.txt
mv out.txt $GPRS_CSV
mv GPRS.csv 'GPRS_'$datetag.csv

awk 'NF > 0' $MMS_CSV  > out.txt
mv out.txt $MMS_CSV
mv MMS.csv 'MMS_'$datetag.csv
