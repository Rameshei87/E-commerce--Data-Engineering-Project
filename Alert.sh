#!/usr/bin/bash
local_dir1="/app/cbsrating/Rating/batchProcs/med_dir/gsm/data/"
local_dir2="/app/cbsrating/Rating/batchProcs/med_dir/gprs/data/"
local_dir3="/app/cbsrating/Rating/batchProcs/med_dir/mms/data/"
local_dir4="/app/cbsrating/Rating/batchProcs/med_dir/smsc/data/"
roam_dir1="/app/cbsrating/Rating/batchProcs/roam_cdr_dir/gsm/data"
roam_dir2="/app/cbsrating/Rating/batchProcs/roam_cdr_dir/gprs/data"
roam_nrtrde_dir1="/app/cbsrating/Rating/batchProcs/roam_nrtrde_cdr_dir/gsm/data/"
roam_nrtrde_dir2="/app/cbsrating/Rating/batchProcs/roam_nrtrde_cdr_dir/gprs/data/"
ORACLE_CONN=CBS_APPS/CBS_APPS@CBSTEST
MOB_NUMB="23052588901"
SMS_MESSAGE1="CDR Files are not present in GSM Folder"
SMS_MESSAGE2="CDR Files are not present in GPRS Folder"
SMS_MESSAGE3="CDR Files are not present in MMS Folder"
SMS_MESSAGE4="CDR Files are not present in SMS Folder"
ROAMSMS_MESSAGE1="Roaming CDR Files are not present in GSM Folder"
ROAMSMS_MESSAGE2="Roaming CDR Files are not present in GPRS Folder"
ROAM_NRTRDESMS_MESSAGE1="Roaming NRTRDE CDR Files are not present in GSM Folder"
ROAM_NRTRDESMS_MESSAGE2="Roaming NRTRDE CDR Files are not present in GPRS Folder"
MAILID="satish.mantha@tecnotree.com"
SMSrequired="Y"
Mailrequired="N"
SMS_SOURCE="@Billity"


function cdrFileexistOrNot()
{
	path=$1
	message=$2
	cd $path
	for i in *.*
	do
		if [[ -f "$i" ]]
		then
			echo "file exists"
		else
			echo "file not exist"
if [ "$SMSrequired" = "Y" ] || [ "$SMSrequired" = "y" ]  ; then
			
sql_conn=`sqlplus -S $ORACLE_CONN <<EOF
SET SERVEROUTPUT ON SIZE 10000 FEEDBACK OFF LINESIZE 5000
BEGIN
	INSERT INTO sms_message_queue
		(smq_ref_no, smq_mobile_no, smq_date_time, smq_message,smq_source,SMQ_SOURCE_REF_NO)
	VALUES (seq_sms_message_queue.NEXTVAL, '$MOB_NUMB' , CURRENT_TIMESTAMP, '$message','$SMS_SOURCE',1017);

COMMIT;	
END;
/
EXIT
EOF`
	fi
	
 if [ "$Mailrequired" = "Y" ] || [ "$Mailrequired" = "y" ]  ; then		
		echo "$message" > email
		sendmail $MAILID < email
		fi
	fi	
	done
}

cdrFileexistOrNot "$local_dir1" "$SMS_MESSAGE1"
cdrFileexistOrNot "$local_dir2" "$SMS_MESSAGE2"
cdrFileexistOrNot "$local_dir3" "$SMS_MESSAGE3"
cdrFileexistOrNot "$local_dir4" "$SMS_MESSAGE4"
cdrFileexistOrNot "$roam_dir1" "$ROAMSMS_MESSAGE1"
cdrFileexistOrNot "$roam_dir2" "$ROAMSMS_MESSAGE2"
cdrFileexistOrNot "$roam_nrtrde_dir1" "$ROAM_NRTRDESMS_MESSAGE1"
cdrFileexistOrNot "$roam_nrtrde_dir2" "$ROAM_NRTRDESMS_MESSAGE2"

