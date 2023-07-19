#!/bin/sh
#The purpose of this script is to interact with the /home/aheumphreus/bin/data_management/DeleteData.sh script
#In particular, it is designed (in order) to check an external file on the SDrive (NextSeq200_VH[SN]_Delete),
#check the response for various runs on this list, and then delete (or store) those runs from the device in question.
#After that, it checks the amount of data stored on the device, then determines how many runs will be necessary to 
#Remove from the nextseq before the amount of available data falls below an acceptable threshold. These runs
#are then stored on NextSeq2000_VH[SN]_Delete for checks by ~/bin/data_management/DeleteData.sh to slate them for 
#Possible deletion.
#This script is expected to run continuously while the device is in operation, checking at least once a day for candidates.

#The check file in question has 4 columns: Run name, Stat (trinary flag), SN, and Storage size.
#The storage size is collected while the machine is checking the amount of data to be freed up from the machine, and verifying
#If the run in question will put the data under that threshoold.
#The binary flag is set to 0 on initialization, 1 on confirmation to delete, and 2 on confirmation to store.
#SN and name serve to simply clarify which system and which run to be checked.
while read -r line;
do
	check_store=`awk '{print $4}'`
	check_sn=`awk '{print $3}'`
	check_stat=`awk '{print $2}'`	
	run_name=`awk '{print $1}'`
	if [ $check_stat=="2" ]; then
		ls /usr/bin/illumina/runs/${run_name}
		if [ ! -d "/usr/bin/illumina/runs/RESERVE/" ]; then
			mkdir /usr/bin/illumina/runs/RESERVE/
		fi
		echo "Run: ${run_name}"
		echo "Status: 2"
		echo "SN: ${check_sn}"
		echo "Size: ${check_store}"
#		mv /usr/bin/illumina/runs/${run_name} /usr/bin/illumina/runs/RESERVE/
#		set "/${run_name}/d" /mnt/Synology/NextSeq/NextSeq2000_Deletion_Candidates
	fi
	if [ $check_stat=="1" ]; then
                ls /usr/bin/illumina/runs/${run_name}
                echo "Run: ${run_name}"
                echo "Status: 1"
                echo "SN: ${check_sn}"
                echo "Size: ${check_store}"
#               rm -r /usr/bin/illumina/runs/${run_name}
#		set "/${run_name}/d" /mnt/Synology/NextSeq/NextSeq2000_Deletion_Candidates
	fi
	if [ $check_stat=="0" ]; then
                ls /usr/bin/illumina/runs/${run_name}
                echo "Run: ${run_name}"
                echo "Status: 0"
                echo "SN: ${check_sn}"
                echo "Size: ${check_store}"
        fi
done < /mnt/Synology/NextSeq/NextSeq2000_Deletion_Candidates

	
