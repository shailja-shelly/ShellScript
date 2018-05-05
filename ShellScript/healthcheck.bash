###############################################
#											  #
#  Script for Genarating Healthcheck Report   #
#!/bin/sh 									  #
# Author : Anirban      Version : 1.0		  #
# Date : 19th July , 2017					  #					
#####healthcheck scripts path #################
dd=`date +%d_%m_%Y`
scripts_path="/opt/healthcheck/scripts"
logs_path="/opt/healthcheck/logs"
diskpace_logs="/opt/healthcheck/logs/diskspace.txt"
process_logs="/opt/healthcheck/logs/process.txt"
mail_file="/opt/healthcheck/logs/mail.htm"
if [ -f $mail_file ] ; then
 rm $mail_file
fi


######  Diskspace utilization ########
df -kh | tr -s " " | grep "/" | cut -d " " -f5,6 | grep "%" | sed s'/%//' > $diskpace_logs

#####Creating html file #######
cd $logs_path
echo " <html> " > $mail_file
echo " <head> " >> $mail_file
echo " <style> " >> $mail_file
echo " table, tr, th { " >> $mail_file
echo " border: 1px solid black; " >> $mail_file
echo " border-collapse: collapse; " >> $mail_file
echo " background-color: #f1f1c1; " >> $mail_file
echo " } " >> $mail_file
echo " th{ " >> $mail_file
echo " background-color:grey " >> $mail_file
echo " } " >> $mail_file
echo " td{ " >> $mail_file
echo " border: 1px solid black; " >> $mail_file
echo " } " >> $mail_file
echo " </style> " >> $mail_file
echo " </head> " >> $mail_file

echo " <body> " >> $mail_file

#######Creating Table for diskspace utilization #########
echo " <table style="width:100%"> " >> $mail_file
echo " <tr> <th colspan="2">Disk Space Utilization </th></tr> " >> $mail_file
echo " <tr><th>Mountpoint</th> " >> $mail_file
echo " <th>Used(%)</th> " >> $mail_file
echo " </tr> " >> $mail_file
cat $diskpace_logs | while read x
do
  echo " <tr> " >> $mail_file
  mount_val=`echo $x | cut -d " " -f2`
  util_val=`echo $x | cut -d " " -f1`
  echo " Mounpoint : $mount_val "
  echo " Occupied : $util_val "
  echo " <td> $mount_val </td>" >> $mail_file
  if [ $util_val -ge 80 ] ; then
    echo " <td bgcolor="#ff0040"> $util_val </td>" >> $mail_file
  elif [ $util_val -ge 60 -a $util_val -lt 80 ] ; then
    echo " <td bgcolor="#FFBF00"> $util_val </td>" >> $mail_file
  else
    echo " <td bgcolor="green"> $util_val </td>" >> $mail_file
  fi
    echo " </tr> " >> $mail_file
	
done
####### Table Completed for diskspace utilization #########

echo " </table> " >> $mail_file

echo "<br>" >> $mail_file
echo "<br>" >> $mail_file
echo "<br>" >> $mail_file
echo "<br>" >> $mail_file

###############Table for showing top 10 running processes #################
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -11 | tr -s " " | sed s'/%//' | sed s'/^ //' | sed '/COMMAND/d' > $process_logs

#ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10 | tr -s " " | sed s'/%//' | sed s'/^ //' | cut -d " " -f4-

echo " <table style="width:100%"> " >> $mail_file
echo " <tr> <th colspan="4"> Top 10 running processes </th></tr> " >> $mail_file
echo " <tr><th>CPU(%)</th> " >> $mail_file
echo " <th>PID</th> " >> $mail_file
echo " <th>User</th> " >> $mail_file
echo " <th>Command</th> " >> $mail_file
echo " </tr> " >> $mail_file
##top -b -n1

cat $process_logs | while read x
do
   echo " <tr> " >> $mail_file
   cpu_utilised=`echo $x | cut -d " " -f1`
    pid=`echo $x | cut -d " " -f2`
    user=`echo $x | cut -d " " -f3`
    command=`echo $x | cut -d " " -f4-`
   echo "cpu : $cpu_utilised"
   echo "pid : $pid"
   echo "user : $user"
   echo "command : $command"
   echo " <td> $cpu_utilised </td>" >> $mail_file
   echo " <td> $pid </td>" >> $mail_file
   echo " <td> $user </td>" >> $mail_file
   echo " <td> $command </td>" >> $mail_file
   echo " </tr> " >> $mail_file
done
  echo " </table> " >> $mail_file
  
echo "<br>" >> $mail_file
echo "<br>" >> $mail_file
echo "<br>" >> $mail_file
echo "<br>" >> $mail_file

#####Table Completed for top 10 running processes #######

#######Table for creating Application Status#########################
echo -e '<table style="width:100%">
   <tr> <th colspan="2"> Application Status </th></tr>
   <tr><th>Application</th>
   <th>Status</th></tr> ' >> $mail_file
   

pact_status_flag=`curl -Is http://172.31.24.242:3000/ | grep -ic "200"`
fastrack_status_flag=`curl -Iks https://172.31.24.242:8443/ | grep -ic "200"`
myfamily_status_flag=`curl -Iks https://172.31.24.242:3005/ | grep -ic "200"`
testimony_status_flag=`curl -Iks https://172.31.24.242:3101/ | grep -ic "200"`

echo " <tr> " >> $mail_file
echo " <td> PACT </td>" >> $mail_file
if [ $pact_status_flag -eq 1 ] ; then
  echo " <td bgcolor="green"> Running </td> " >> $mail_file
else
  echo " <td bgcolor="red"> NOT Running </td> " >> $mail_file  
fi
echo " </tr> " >> $mail_file


echo " <tr> " >> $mail_file
echo " <td> FASTRACK </td>" >> $mail_file
if [ $fastrack_status_flag -eq 1 ] ; then
  echo " <td bgcolor="green"> Running </td> " >> $mail_file
else
  echo " <td bgcolor="red"> NOT Running </td> " >> $mail_file  
fi
echo " </tr> " >> $mail_file


echo " <tr> " >> $mail_file
echo " <td> MYFamily </td>" >> $mail_file
if [ $myfamily_status_flag -eq 1 ] ; then
  echo " <td bgcolor="green"> Running </td> " >> $mail_file
else
  echo " <td bgcolor="red"> NOT Running </td> " >> $mail_file  
fi
echo " </tr> " >> $mail_file


echo " <tr> " >> $mail_file
echo " <td> Testimony </td>" >> $mail_file
if [ $testimony_status_flag -eq 1 ] ; then
  echo " <td bgcolor="green"> Running </td> " >> $mail_file
else
  echo " <td bgcolor="red"> NOT Running </td> " >> $mail_file  
fi
echo " </tr> " >> $mail_file

echo " </table> " >> $mail_file

#######Application Status Table creation completed ##################  
echo " </body> " >> $mail_file
echo " </html> " >> $mail_file
wkhtmltopdf $mail_file Daily_Healthcheck_Report_$dd.pdf
cp Daily_Healthcheck_Report_$dd.pdf /home/anirban.khan/
chmod 777 /home/anirban.khan/Daily_Healthcheck_Report_$dd.pdf

#(
  #echo To: anirbankhan77@gmail.com
  #echo From: el@defiant.com
  #echo "Content-Type: text/html; "
  #echo Subject: Daily HealthcheckReport_$dd
  #echo
  #cat $mail_file
#) | sendmail -t



 