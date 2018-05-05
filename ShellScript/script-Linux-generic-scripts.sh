#!/bin/bash
# SCRIPT FOR CONFIG VA  FOR LINUX (RHEL-5) SERVERS 
# Written for UIDI, Bangalore
# DATE : 10 July, 2011

file=LNX-`uname -n`-`date +%d%m%y`
echo $file

if [ -f $file ]
then
    echo "The filename exists. Removing it...."
    rm $file
fi

echo ""  >>$file
echo "DATE OF DADA COLLECTION : `date`" >>$file
echo "==============================================================" >>$file
echo "                     SYSTEM IDENTIFICATION                    " >>$file
echo "==============================================================" >>$file
uname -a  >> $file
uname -s  >> $file
uname -v  >> $file
uname -r  >> $file
uname -m  >> $file
echo "" >>$file
echo "========= REDHAT-RELEASE =======" >>$file
echo "" >>$file
cat /etc/redhat-release >>$file
echo "" >>$file
echo "========= IP ADDRESS ===========" >>$file
echo "" >>$file

ifconfig -a >>$file

echo "" >>$file
echo "============================================================" >>$file
echo "              END OF SYSTEM IDENTIFICATION                  " >>$file
echo "============================================================" >>$file
echo "============================================================" >>$file
echo "              CHECK SETTING OF LILO/GRUB PASSWORD           " >>$file 
echo "============================================================" >>$file
echo ""
echo "====== Check existence of lilo.conf file ======" >>$file
echo "" >>$file
if [ -f /etc/lilo.conf ]; then
   echo "" >>$file
   ls -l /etc/lilo.conf  >>$file
   echo "" >>$file
   if [ "`grep -i password /etc/lilo.conf`" = "" ]; then 
      echo " LILO.CONF IS NOT SECURED WITH PASSWORD " >>$file
   else
      echo " LILO.CONF FILE IS SECURED WITH PASSWORD AS BELOW : " >>$file
      echo "----------------------------------------"  >>$file
      grep -i password /etc/lilo.conf >>$file
      echo "----------------------------------------"  >>$file
      echo "" >>$file
   fi
else
    echo " THE FILE /etc/lilo.conf DOES NOT EXIST " >>$file
fi

echo  "" >>$file
echo "========= Check existence of grub.conf file ========" >>$file
echo  "" >>$file
if [ -f /etc/grub.conf ]; then
   echo "" >>$file
   ls -l /etc/grub.conf  >>$file
   ls -l /boot/grub/grub.conf   >>$file
   echo "" >>$file
   if [ "`grep -i password /boot/grub/grub.conf`" = "" ]; then 
      echo " GRUB.CONF IS NOT SECURED WITH PASSWORD " >>$file
   else
      echo " GRUB.CONF FILE IS SECURED WITH PASSWORD AS BELOW : " >>$file
      echo "----------------------------------------"  >>$file
      grep -i password /boot/grub/grub.conf >>$file
      echo "----------------------------------------"  >>$file
      echo "" >>$file
      echo " GRUB.CONF FILE IS SECURED WITH PASSWORD AS BELOW : " >>$file
   fi

else
    echo " THE FILE /etc/grub.conf DOES NOT EXIST " >>$file
    echo "" >>$file
fi

echo "========================================================" >>$file
echo ""  >>$file
echo "============================================================" >>$file
echo "           CHECK SINGLE USER PASSWORD ENFORCEMENT           " >> $file 
echo "============================================================" >>$file
echo "" >>$file

if [ "`grep -i :S:wait:/sbin/sulogin /etc/inittab`" = "" ]; then 
    echo "" >>$file
    echo " SINGLE USER PASSWORD NOT ENFORCED " >>$file
    echo "" >>$file
else
    echo "----------------------------------------"  >>$file
    grep -i :S:wait:/sbin/sulogin /etc/inittab  >>$file
    echo "----------------------------------------"  >>$file
    echo "" >>$file    
    echo " IT IS SECURED WITH SINGLE USER PASSWORD ENFORCEMENT " >>$file
    echo "" >>$file
fi

echo ""  >>$file
echo "============================================================" >>$file
echo "                CHECK DEFAULT RUN LEVEL                     " >>$file 
echo "============================================================" >>$file
echo "" >>$file

grep "initdefault" /etc/inittab >>$file
echo "" >>$file

echo ""  >>$file
echo "============================================================" >>$file
echo "                CHECK inetd and boot SERVICES               " >>$file 
echo "============================================================" >>$file
echo "" >>$file
chkconfig --list >>$file
echo "" >>$file
echo "============================================================" >>$file
echo ""  >>$file
echo "============================================================" >>$file
echo "                CHECK CONTROL ON CRON COMMAND               " >>$file 
echo "============================================================" >>$file
echo "" >>$file

echo "========= List of cronjobs ========" >>$file

crontab -l >>$file  2>>$file
echo  "" >>$file

echo "======== CHECK OWNER AND PERMISSION on /etc/crontab and /var/spool/cron file =========" >>$file

ls -lad /etc/cron*   /var/spool/cron* >>$file  2>>$file

echo "" >>$file

echo "========= LIST CONTENT OF cron.d,cron.daily/monthly/hourly/weekly =======" >>$file
ls -l /etc/cron*  >>$file
echo ""  >>$file
echo "=========================================================================" >>$file
echo "" >>$file
echo "========== Check CONTENT OF /etc/cron.allow ==========" >>$file
echo "" >>$file

if [ -f /etc/cron.allow ]
then 
    ls -l /etc/cron.allow  >>$file
    echo "" >>$file
    echo "====================================================" >>$file
    cat /etc/cron.allow >>$file
    echo "====================================================" >>$file
    echo "" >>$file
else
    echo "" >>$file
    echo " /etc/cron.allow FILE DOES NOT EXIST " >>$file
    echo "" >>$file
fi

echo "" >>$file
echo "========== Check CONTENT OF /etc/cron.deny ==========" >> $file

if [ -f /etc/cron.deny ]
then 
    ls -l /etc/cron.deny   >>$file
    echo "" >>$file
    echo "==========================================================" >>$file
    cat /etc/cron.deny  >>$file
    echo "==========================================================" >>$file
else
    echo " /etc/cron.deny FILE DOES NOT EXIST " >>$file
    echo "" >>$file
fi

echo "" >>$file
echo "========================================================================" >>$file
echo "" $file

echo ""  >>$file
echo "============================================================" >>$file
echo "                CHECK DISABLING GUI LOGIN                   " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo "======== Check whether default runlevel is 3 ========" >>$file
grep "initdefault" /etc/inittab >>$file
echo "" >>$file

echo "======== Check whether default X Font Server is disabled ======" >>$file
echo "" >>$file
chkconfig --list xfs >>$file
echo "" >>$file

echo "============================================================" >>$file
echo "                CHECK LOGGING                               " >>$file 
echo "============================================================" >>$file
echo "" >>$file

echo "======= Check whether syslogd is running =======" >>$file
ps -ef|grep syslogd >> $file
echo "=======  Check whether authpriv  is enabled =======* " >>$file
grep "authpriv." /etc/syslog.conf >> $file
echo " ======= Check permission of /var/log/secure file =======" >>$file
ls -l /var/log/secure >>$file
echo "" >>$file

echo "============================================================" >>$file
echo "                CHECK ROOT LOGIN CONTROL                    " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo " ======= PART- 1 : Contents of securetty file ======" >>$file

if [ -f /etc/securetty ]
then
    echo "========= Check permission on the securetty file ========" >>$file
    echo "" >>$file
    ls -l /etc/securetty >>$file
    echo "" >>$file
    echo "=========== check ontent of /etc/securetty file ========" >>$file
    echo "========================================================" >>$file
    cat /etc/securetty >>$file
    echo "=========================================================" >>$file
else
    echo " NO /etc/securetty FILE EXISTS " >>$file
fi

echo "" >>$file
echo "======= PART- 2 : Check LIMITING DIRECT ROOT LOG in ========" >>$file
echo "======= Check whether WHEEL group is defined =======" >>$file
if [ -f /etc/group  ]; then
   echo "" >>$file
   if [ "`grep wheel  /etc/group`" = "" ]; then 
      echo " wheel group NOT defined " >>$file
   else
      echo " wheel group has been defined as below : " >>$file
      echo ""  >>$file
      grep -i wheel /etc/group >>$file
      echo "" >>$file
      echo "==== Check necessary entry in /etc/pam.d/su file for restriction on su *********" >>$file
      echo "===============================" >>$file      
      grep -i use_uid /etc/pam.d/su >> $file
      echo "===============================" >>$file
      echo "" >>$file
   fi
else
   echo " NO EXISTENCE OF /etc/group FILE " >>$file
   echo "" >>$file
fi

echo "" >>$file

echo "============================================================" >>$file
echo " CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING  " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo "========================================================" >>$file
chkconfig --list telnet   >>$file 2>>$file
chkconfig --list rlogin   >>$file 2>>$file 
chkconfig --list sshd     >>$file 2>>$file
echo "========================================================" >>$file
echo "" >>$file
echo "============================================================" >>$file
echo " CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN   " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo "======= Check Protocol in CLIENT CONFIGURATION =======" >>$file

SSH_CONFIG='/etc/ssh/ssh_config'

if [ -e $SSH_CONFIG ]; then
   echo " === LIST OF PROTOCOL DEFINED =====" >>$file
   echo "===========================" >>$file
   grep -i protocol $SSH_CONFIG >>$file
   echo "==========================" >>$file
else
   echo "" >>$file
   echo " /etc/ssh/ssh_config file does not exist  " >>$file
   echo "" >>$file
fi

echo "======= Check Protocol in SERVER CONFIGURATION =======" >>$file

SSHD_CONFIG='/etc/ssh/sshd_config'

if [ -e $SSHD_CONFIG ]; then
   echo "=== PROTOCOL AND PermitRootLogin AS DEFINED =====" >>$file
   echo "===========================" >>$file
   grep -i protocol $SSHD_CONFIG >>$file
   echo ""  >>$file
   grep PermitRootLogin $SSHD_CONFIG >>$file
   echo "" >>$file
   echo "==========================" >>$file
else
   echo "" >>$file
   echo " /etc/ssh/sshd_config file does not exist  " >>$file
   echo "" >>$file
fi

echo "" >>$file
echo "============================================================" >>$file
echo "               CHECK USER ACCOUNTS                          " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo "======== LIST OF USERS ======"  >>$file
cat /etc/passwd >>$file
echo "" >>$file
echo "======= CONTENT OF SHADOW FILE =========" >>$file
cat /etc/shadow >> $file
echo "" >>$file
echo "======== CHECK FOR USER ACCOUNTS EMPTY PASSWORD ======="  >>$file
awk -F: '( $2 == "" ) { print $1 }' /etc/shadow  >>$file
echo ""  >>$file

#dup username

echo "======= Check existence of DUPLICATE USERNAME ======" >>$file

x=`cut -f1 -d: /etc/passwd | sort | uniq -d | tr "\n" " "`

if [ "x$x" != "x" ]
then
     echo "The following duplicate usernames found: $x"     >>$file
fi

#dup uid

echo "======= Check existence of DUPLICATE USER ID ======" >>$file

x=`cut -f3 -d: /etc/passwd | sort | uniq -d | tr "\n" " "`

if [ "x$x" != "x" ]
then
    echo "The following duplicate uids found: $x"      >>$file
fi

#dup groupname

echo "======= Check existence of DUPLICATE GROUPNAME ======" >>$file

x=`cut -f1 -d: /etc/group | sort | uniq -d | tr "\n" " "`

if [ "x$x" != "x" ]
then
echo "The following duplicate group names found: $x"   >>$file
fi

#dup gid

echo "======= Check existence of DUPLICATE GROUP IDS ======" >>$file


x=`cut -f3 -d: /etc/group | sort | uniq -d | tr "\n" " "`

if [ "x$x" != "x" ]
then
echo "The following duplicate gids found: $x"         >>$file
fi

echo ""
echo "======== CHECK DUPLICATE OR UNAUTHORIZED UID 0 Accounts =====" >>$file
echo "==== DUPLICATE UID 0 in password file =====" >>$file
echo "-------------------------------------------------------------" >>$file
awk -F: '$3 == "0" { print $1 }' /etc/passwd    >>$file
echo "-------------------------------------------------------------" >>$file
echo "==== DUPLICATE UID 0 in pgroup file =====" >>$file
echo "-------------------------------------------------------------" >>$file
awk -F: '$3 == "0" { print $1 }' /etc/group  >>$file
echo "-------------------------------------------------------------" >>$file

echo "====== CHECK PASSWORD PARAMETERS =======" >>$file
echo ""  >>$file
grep PASS_MAX_DAYS /etc/login.defs >> $file
grep PASS_MIN_DAYS /etc/login.defs >> $file
grep MINLEN /etc/login.defs >> $file
echo "" >>$file
echo "==========================================" >>$file
echo "=====  CHECK HOME DIRECTORIES PERMISSION  (750)=====" >>$file

for DIR in `awk -F: '( $3 >= 500 ) { print $6 }' /etc/passwd`; do
if [ $DIR != /var/lib/nfs ]; then
ls -ld $DIR  >>$file
fi
done

echo "===============================================" >>$file

echo "" >>$file
echo "============================================================" >>$file
echo "               CHECK FILE SYSTEM SECURITY                   " >>$file 
echo "============================================================" >>$file
echo "" >>$file

echo "==== Check ownership (root/root) and permission (0644) of /etc/fstab =======" >>$file
ls -l /etc/fstab  >>$file
echo ""  >>$file
#cat /etc/fstab >> $file
echo "==== Check DISK USAGE (df -h)=====" >>$file
df -h >> $file
echo "==========================" >>$file

#echo " ** Check SUID and SGID bits ******* " >> $file
#echo "**** SUID ***" >> $file
#find / -perm +4000 -uid 0 -exec ls -l {} \; >> $file
#echo "** Commands for SUID, SGID and nouser files commented out **" >> $file
#echo "**** SGID ***" >> $file
#find / -perm +2000 -gid 0 -exec ls -ld {} \; >> $file
#echo "**** NOUSER ***" >> $file
#find / -nouser -print >> $file

echo "======= passwd, group (root,0644)  and shadow (root,0400) file permission =======" >> $file
echo "=====================================" >>$file
ls -l /etc/passwd  >>$file  2>>$file
ls -l /etc/group   >>$file  2>>$file
ls -l /etc/shadow  >>$file  2>>$file
ls -l /etc/gshadow >>$file  2>>$file
echo "=====================================" >>$file
echo ""  >>$file

echo "======= permission of /bin, /sbin and  /etc  file (0744) =======" >> $file
echo "=====================================" >>$file

ls -ald /bin  /sbin  /etc  >> $file  2>>$file

echo "=====================================" >>$file
echo ""  >>$file
echo "============================================================" >>$file
echo "               CHECK FTP SERVICE AND ITS USERS              " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo "======== CHECK WHETHER THE PROCESS RUNNING (ftp or vsftp) =======" >>$file
echo "=================================" >>$file
chkconfig --list  ftp      >>$file  2>>$file
chkconfig --list  vsftpd   >>$file  2>>$file
echo "==================================" >>$file

if [ -f /etc/ftpusers ]
then
      ls -l /etc/ftpusers    >>$file
      echo "===== CONTENT OF /etc/ftpusers file =======" >>$file
      cat /etc/ftpusers  >>$file
      echo "==================================="  >>$file
else
      echo  ""   >>$file
      echo " NO EXISTENCE OF /etc/ftpusers "  >>$file
      echo ""  >>$file
fi

echo "======= CHECK CONFIG OF vsftpd and CONTENT of /etc/vsftpd.ftpusers file =====" >>$file

if [ -f /etc/vsftpd/vsftpd.conf ]
then
      echo ""  >>$file
      ls -l /etc/vsftpd/vsftpd.conf    >>$file
      echo ""  >>$file
      echo "====== SETTING of user_list_deny PARAMETER ======" >>$file
      grep userlist_deny /etc/vsftpd/vsftpd.conf  >>$file
      echo  ""  >>$file
      echo "===================================="  >>$file

else
      echo  ""   >>$file
      echo " NO EXISTENCE OF /etc/vsftpd/vsftpd.conf FILE  "  >>$file
      echo ""  >>$file
fi

if [ -f /etc/vsftpd.ftpusers ]
then 
      echo ""  >>$file
      ls -l /etc/vsftpd.ftpusers   >>$file
      echo ""  >>$file
      echo "===== CONTENT OF /etc/vsftpd.ftpusers file =======" >>$file
      cat /etc/vsftpd.ftpusers  >>$file
      echo "==================================="  >>$file
      echo  ""  >>$file
else
       echo " NO EXISTENCE OF /etc/vsftpd.ftpusers FILE  "  >>$file
       echo ""  >>$file
fi
      
echo ""  >>$file
echo "============================================================" >>$file
echo "               CHECK BANNERS                                " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo "====== CHECK /etc/motd file ======"  >>$file

if [ -f /etc/motd ]
then 
     echo "" >>$file
     ls -l /etc/motd  >>$file
     echo ""  >>$file
     echo "======= CONTENT OF motd FILE ======="  >>$file

     cat /etc/motd >> $file
     echo "===================================" >>$file
else
     echo " NO EXISTENCE OF /etc/motd  FILE  "  >>$file
     echo ""  >$file
fi

echo ""  >>$file
echo "====== CHECK /etc/issue file ======"  >>$file

if [ -f /etc/issue ]
then 
     ls -l /etc/issue  >>$file
     echo "======= CONTENT OF issue FILE ======="  >>$file

     cat /etc/issue >> $file
     echo "===================================" >>$file
else
     echo " NO EXISTENCE OF /etc/issue  FILE  "  >>$file
     echo ""  >$file
fi
 
echo ""  >>$file
echo "============================================================" >>$file
echo "               CHECK MISC.                                  " >>$file 
echo "============================================================" >>$file
echo "" >>$file
echo "====== Check coredump is disabled =======" >> $file
echo "" >>$file
grep -i core /etc/security/limits.conf >> $file
echo ""  >>$file

echo "=========================================" >>$file
echo "======== LIST OF PROCESSESS RUNNING ==========" >>$file
ps -ef >>$file  2>>$file
echo "==============================================" >>$file
echo "" >>$file
echo "============ LIST NETWORK CONNECTIONS ========" >>$file
netstat -a >>$file  2>>$file
echo ""  >>$file
echo "============ END OF FILE ====================" >> $file

#echo "#################  SYSTEM INFORMATION ###################" >>$file
#echo "***** OUTPUT OF dmidecode *********" >>$file
#dmidecode >>$file
#echo "*****  Content of /proc/cpuinfo  *****" >>$file
#cat /proc/cpuinfo >>$file
#echo "*****  Content of /proc/meminfo  ******" >>$file
#cat /proc/meminfo >>$file
#echo "################# END OF SYSTEM INFORMATION ############" >>$file
cp $file Script_vulnerability_violation.txt
# ====================  END OF SCRIPT ====================================
