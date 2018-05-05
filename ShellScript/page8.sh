#!/bin/sh
home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/
lilo_grub_variable=0;
flag=1;
TEMP=$(mktemp -t page8.XXXXX)
system_details=`grep  "Linux" Script_vulnerability_violation.txt | head -1`

cat > $TEMP <<EOF
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">
<style>
table,th,td {
    border: 2px solid black;
    border-collapse: collapse;

}

</style>
</head>
<body>

<br>
<br>
<br>
<div>
<center>
<table style="
    width: 80%;
">
<tbody><tr style="
    background-color: #3F51B5;
"><th colspan="4" style="
    font-size: 23px;"
"><b>Vulnerability Violation</b></th></tr>
<tr style="
    background-color: #3F51B5;
"><th colspan="4" style="
    font-size: 23px;"
"><b>$system_details</b></th></tr>

<tr><th style="
    font-size: 23px;"
"><b>Check</b></th><th style="
    font-size: 23px;"
"><b>Sub-Check</b></th><th style="
    font-size: 23px;"
"><b>Suceess</b></th><th style="
    font-size: 23px;"
"><b>Comments</b></th></tr>
EOF




################################Check Setting of LILO/GRUB password#########################################


lilo_grub_variable=0;
awk '/CHECK SETTING OF LILO/{f=1;next} /CHECK SINGLE USER PASSWORD ENFORCEMENT/{f=0} f' Script_vulnerability_violation.txt | grep "Check" | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1'  > sub_check.txt


cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
lilo_flag=`awk '/CHECK SETTING OF LILO/{f=1;next} /CHECK SINGLE USER PASSWORD ENFORCEMENT/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | grep "NO" | wc -l`
lilo_flag_comment=`awk '/CHECK SETTING OF LILO/{f=1;next} /CHECK SINGLE USER PASSWORD ENFORCEMENT/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $lilo_grub_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>Check Setting of LILO/GRUB password</th> " >> $TEMP
    echo " <th>$x</th> " >> $TEMP

        if [ $lilo_flag -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$lilo_flag_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $lilo_flag -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$lilo_flag_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

lilo_grub_variable=`expr $lilo_grub_variable + $flag`
echo "lilo grub variable is : $lilo_grub_variable"
done
##############################################################################################

######Check Single User Password Enforcement ################


single_user_password_variable=0;
awk '/CHECK SINGLE USER PASSWORD ENFORCEMENT/{f=1;next} /CHECK DEFAULT RUN LEVEL/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' > sub_check.txt


cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
singleuser_password=`awk '/CHECK SINGLE USER PASSWORD ENFORCEMENT/{f=1;next} /CHECK DEFAULT RUN LEVEL/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | grep "NO" | wc -l`
singleuser_password_comment=`awk '/CHECK SINGLE USER PASSWORD ENFORCEMENT/{f=1;next} /CHECK DEFAULT RUN LEVEL/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $single_user_password_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK SINGLE USER PASSWORD ENFORCEMENT</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $singleuser_password -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$singleuser_password_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $singleuser_password -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$singleuser_password_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

single_user_password_variable=`expr $single_user_password_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done
########################################################################################################

######Check Default Run level ################


check_default_runlevel_variable=0;
awk '/CHECK DEFAULT RUN LEVEL/{f=1;next} /CHECK inetd and boot SERVICES/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' > sub_check.txt
runlevel_flag=`awk '/CHECK DEFAULT RUN LEVEL/{f=1;next} /CHECK inetd and boot SERVICES/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`


if [ $runlevel_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK DEFAULT RUNLEVEL</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>No</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP
 else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
default_runlevel=`awk '/CHECK DEFAULT RUN LEVEL/{f=1;next} /CHECK inetd and boot SERVICES/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | grep "NO" | wc -l`
default_runlevel_comment=`awk '/CHECK DEFAULT RUN LEVEL/{f=1;next} /CHECK inetd and boot SERVICES/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_default_runlevel_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK DEFAULT RUNLEVEL</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $default_runlevel -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$default_runlevel_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $default_runlevel -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$default_runlevel_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_default_runlevel_variable=`expr $check_default_runlevel_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi
########################## Check Default Run level Completed ###################################################


######CHECK inetd and boot SERVICES ################


check_initd_boot_variable=0;
awk '/CHECK inetd and boot SERVICES/{f=1;next} /CHECK CONTROL ON CRON COMMAND/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
initd_boot_flag=`awk '/CHECK inetd and boot SERVICES/{f=1;next} /CHECK CONTROL ON CRON COMMAND/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
initd_boot_check_flag=`awk '/CHECK inetd and boot SERVICES/{f=1;next} /CHECK CONTROL ON CRON COMMAND/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $initd_boot_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>Check initd boot service</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $initd_boot_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>Check initd boot service</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else
cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
initd_boot=`awk '/CHECK inetd and boot SERVICES/{f=1;next} /CHECK CONTROL ON CRON COMMAND/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | grep "NO" | wc -l`
initd_boot_comment=`awk '/CHECK inetd and boot SERVICES/{f=1;next} /CHECK CONTROL ON CRON COMMAND/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_initd_boot_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK DEFAULT RUNLEVEL</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $initd_boot -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$initd_boot_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $initd_boot -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$initd_boot_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_initd_boot_variable=`expr $check_initd_boot_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi
########################## CHECK inetd and boot SERVICES Completed ###################################################

###############################CHECK CONTROL ON CRON COMMAND################


check_cron_variable=0;
awk '/CHECK CONTROL ON CRON COMMAND/{f=1;next} /CHECK DISABLING GUI LOGIN/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
cron_flag=`awk '/CHECK CONTROL ON CRON COMMAND/{f=1;next} /CHECK DISABLING GUI LOGIN/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
cron_check_flag=`awk '/CHECK CONTROL ON CRON COMMAND/{f=1;next} /CHECK DISABLING GUI LOGIN/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $cron_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK CONTROL ON CRON COMMAND</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $cron_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK CONTROL ON CRON COMMAND</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
cron=`awk '/CHECK CONTROL ON CRON COMMAND/{f=1;next} /CHECK DISABLING GUI LOGIN/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
cron_comment=`awk '/CHECK CONTROL ON CRON COMMAND/{f=1;next} /CHECK DISABLING GUI LOGIN/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_cron_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK CONTROL ON CRON COMMAND</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $cron -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$cron_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $cron -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$cron_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_cron_variable=`expr $check_cron_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK CONTROL ON CRON COMMAND Completed ###################################################


############################### CHECK DISABLING GUI login ################


check_gui_login_variable=0;
awk '/CHECK DISABLING GUI LOGIN/{f=1;next} /CHECK LOGGING/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
gui_login_flag=`awk '/CHECK DISABLING GUI LOGIN/{f=1;next} /CHECK LOGGING/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
gui_login_check_flag=`awk '/CHECK DISABLING GUI LOGIN/{f=1;next} /CHECK LOGGING/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $gui_login_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK DISABLE GUI LOGIN</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $gui_login_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK DISABLE GUI LOGIN</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
gui_login=`awk '/CHECK DISABLING GUI LOGIN/{f=1;next} /CHECK LOGGING/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
gui_login_comment=`awk '/CHECK DISABLING GUI LOGIN/{f=1;next} /CHECK LOGGING/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_gui_login_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK DISABLE GUI LOGIN</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $gui_login -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$gui_login_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $gui_login -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$cron_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_gui_login_variable=`expr $check_gui_login_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK DISABLING GUI login Completed ###################################################


############################### CHECK LOGGING ################


check_logging_variable=0;
awk '/CHECK LOGGING/{f=1;next} /CHECK ROOT LOGIN CONTROL/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
logging_flag=`awk '/CHECK LOGGING/{f=1;next} /CHECK ROOT LOGIN CONTROL/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
logging_check_flag=`awk '/CHECK LOGGING/{f=1;next} /CHECK ROOT LOGIN CONTROL/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $logging_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK DISABLE GUI LOGIN</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $logging_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK DISABLE GUI LOGIN</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
logging=`awk '/CHECK LOGGING/{f=1;next} /CHECK ROOT LOGIN CONTROL/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
logging_comment=`awk '/CHECK LOGGING/{f=1;next} /CHECK ROOT LOGIN CONTROL/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_logging_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK LOGGING</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $logging -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$logging_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $logging -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$logging_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_logging_variable=`expr $check_logging_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK LOGGING Completed ###################################################

############################### CHECK ROOT LOGIN CONTROL ################


check_root_login_control_variable=0;
awk '/CHECK ROOT LOGIN CONTROL/{f=1;next} /CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
root_login_control_flag=`awk '/CHECK ROOT LOGIN CONTROL/{f=1;next} /CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
root_login_control_check_flag=`awk '/CHECK ROOT LOGIN CONTROL/{f=1;next} /CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $root_login_control_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK ROOT LOGIN CONTROL</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $root_login_control_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK ROOT LOGIN CONTROL</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
root_login_control=`awk '/CHECK LOGGING/{f=1;next} /CHECK ROOT LOGIN CONTROL/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
root_login_control_comment=`awk '/CHECK LOGGING/{f=1;next} /CHECK ROOT LOGIN CONTROL/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_root_login_control_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK ROOT LOGIN CONTROL</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $root_login_control -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$root_login_control_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $root_login_control -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$root_login_control_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_root_login_control_variable=`expr $check_root_login_control_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK ROOT LOGIN CONTROL Completed ###################################################


############################### CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING ################


check_telnet_rlogin_ssh_variable=0;
awk '/CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=1;next} /CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
telnet_rlogin_ssh_flag=`awk '/CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=1;next} /CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
telnet_rlogin_ssh_check_flag=`awk '/CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=1;next} /CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`
telnet_rlogin_ssh_check_flag_error=`awk '/CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=1;next} /CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=0} f' Script_vulnerability_violation.txt | grep "error" | wc -l`
telnet_rlogin_ssh_check_flag_error_data=`awk '/CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=1;next} /CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=0} f' Script_vulnerability_violation.txt | grep "error"`
if [ $telnet_rlogin_ssh_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th> CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING </th> " >> $TEMP
   if [ $telnet_rlogin_ssh_check_flag_error -eq 0 ] ;then
       echo " <th>NA</th> " >> $TEMP
       echo " <td>YES</td> " >> $TEMP
       echo " <td>NA</td> " >> $TEMP
   else
       echo " <th>NA</th> " >> $TEMP
       echo " <td>No</td> " >> $TEMP
       echo " <td>$telnet_rlogin_ssh_check_flag_error_data</td> " >> $TEMP
   fi
elif [ $telnet_rlogin_ssh_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th> CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING </th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
telnet_rlogin_ssh=`awk '/CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=1;next} /CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT|error" | wc -l`
telnet_rlogin_ssh_comment=`awk '/CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING/{f=1;next} /CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT|error"`
    if [ $check_telnet_rlogin_ssh_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan> CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING </th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $telnet_rlogin_ssh -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$telnet_rlogin_ssh_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $telnet_rlogin_ssh -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$telnet_rlogin_ssh_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_telnet_rlogin_ssh_variable=`expr $check_telnet_rlogin_ssh_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK whether telnet, rlogin and ssh SERVICES ARE RUNNING Completed ###################################################

############################### CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN ################


check_ssh_configuration_control_variable=0;
awk '/CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=1;next} /CHECK USER ACCOUNTS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
ssh_configuration_control_flag=`awk '/CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=1;next} /CHECK USER ACCOUNTS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
ssh_configuration_control_check_flag=`awk '/CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=1;next} /CHECK USER ACCOUNTS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $ssh_configuration_control_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $ssh_configuration_control_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
ssh_configuration_control=`awk '/CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=1;next} /CHECK USER ACCOUNTS/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
ssh_configuration_control_comment=`awk '/CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN/{f=1;next} /CHECK USER ACCOUNTS/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_ssh_configuration_control_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $ssh_configuration_control -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$ssh_configuration_control_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $ssh_configuration_control -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$ssh_configuration_control_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_ssh_configuration_control_variable=`expr $check_ssh_configuration_control_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK ssh CONFIGURATION FOR CONTROL ON DIRECT ROOT LOGIN Completed ###################################################


############################### CHECK USER ACCOUNTS ################


check_user_accounts_variable=0;
awk '/CHECK USER ACCOUNTS/{f=1;next} /CHECK FILE SYSTEM SECURITY/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
user_accounts_flag=`awk '/CHECK USER ACCOUNTS/{f=1;next} /CHECK FILE SYSTEM SECURITY/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
user_accounts_check_flag=`awk '/CHECK USER ACCOUNTS/{f=1;next} /CHECK FILE SYSTEM SECURITY/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $user_accounts_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK USER ACCOUNTS</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $user_accounts_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK USER ACCOUNTS</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
user_accounts=`awk '/CHECK USER ACCOUNTS/{f=1;next} /CHECK FILE SYSTEM SECURITY/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
user_accounts_comment=`awk '/CHECK USER ACCOUNTS/{f=1;next} /CHECK FILE SYSTEM SECURITY/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_user_accounts_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK USER ACCOUNTS</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $user_accounts -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$user_accounts_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $user_accounts -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$user_accounts_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_user_accounts_variable=`expr $check_user_accounts_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK USER ACCOUNTS Completed ###################################################

############################### CHECK FILE SYSTEM SECURITY ################


check_file_system_security_variable=0;
awk '/CHECK FILE SYSTEM SECURITY/{f=1;next} /CHECK FTP SERVICE AND ITS USERS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
file_system_security_flag=`awk '/CHECK FILE SYSTEM SECURITY/{f=1;next} /CHECK FTP SERVICE AND ITS USERS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
file_system_security_check_flag=`awk '/CHECK FILE SYSTEM SECURITY/{f=1;next} /CHECK FTP SERVICE AND ITS USERS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $file_system_security_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK FILE SYSTEM SECURITY</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $file_system_security_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK FILE SYSTEM SECURITY</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
file_system_security=`awk '/CHECK FILE SYSTEM SECURITY/{f=1;next} /CHECK FTP SERVICE AND ITS USERS/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
file_system_security_comment=`awk '/CHECK FILE SYSTEM SECURITY/{f=1;next} /CHECK FTP SERVICE AND ITS USERS/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_file_system_security_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK FILE SYSTEM SECURITY</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $file_system_security -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$file_system_security_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $file_system_security -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$file_system_security_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_file_system_security_variable=`expr $check_file_system_security_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK FILE SYSTEM SECURITY Completed ###################################################

############################### CHECK FTP SERVICE AND ITS USERS ################


check_ftp_services_users_variable=0;
awk '/CHECK FTP SERVICE AND ITS USERS/{f=1;next} /CHECK BANNERS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
ftp_service_users_flag=`awk '/CHECK FTP SERVICE AND ITS USERS/{f=1;next} /CHECK BANNERS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
ftp_service_users_check_flag=`awk '/CHECK FTP SERVICE AND ITS USERS/{f=1;next} /CHECK BANNERS/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $ftp_service_users_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK FTP SERVICE AND ITS USERS</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $ftp_service_users_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK FTP SERVICE AND ITS USERS</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
ftp_service_users=`awk '/CHECK FTP SERVICE AND ITS USERS/{f=1;next} /CHECK BANNERS/{f=0} f' Script_vulnerability_violation.txt  | egrep -i "ftp|vsftp|error"  | egrep "NO|NOT|error" | wc -l`
awk '/CHECK FTP SERVICE AND ITS USERS/{f=1;next} /CHECK BANNERS/{f=0} f' Script_vulnerability_violation.txt  | egrep -i "ftp|vsftp|error" | egrep "NO|NOT|error" > ftp_service_users_comment.txt
 ftp_service_users_comment=`cat ftp_service_users_comment.txt`
        if [ $check_ftp_services_users_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK FTP SERVICE AND ITS USERS</th> " >> $TEMP

        if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
    echo " <th>$x</th> " >> $TEMP
        fi

        if [ $ftp_service_users -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$ftp_service_users_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $ftp_service_users -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$ftp_service_users_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_ftp_services_users_variable=`expr $check_ftp_services_users_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK FTP SERVICE AND ITS USERS COMPLETED ###################################################

############################### CHECK BANNERS ################


check_banners_variable=0;
awk '/CHECK BANNERS/{f=1;next} /CHECK MISC/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | grep -i "check" |sed  '/^$/d' > sub_check.txt
banners_flag=`awk '/CHECK BANNERS/{f=1;next} /CHECK MISC/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | wc -l`
banners_check_flag=`awk '/CHECK BANNERS/{f=1;next} /CHECK MISC/{f=0} f' Script_vulnerability_violation.txt | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $banners_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK BANNERS</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $banners_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK BANNERS</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f4`
check_banners=`awk '/CHECK BANNERS/{f=1;next} /CHECK MISC/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
check_banners_comment=`awk '/CHECK BANNERS/{f=1;next} /CHECK MISC/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_banners_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK BANNERS</th> " >> $TEMP

     if [ $rowspan -eq 1 ] ; then
           echo " <th>NA</th> " >> $TEMP

        else
     echo  " <th>$x</th> " >> $TEMP
       fi

        if [ $check_banners -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$check_banners_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $check_banners -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$check_banners_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_banners_variable=`expr $check_banners_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK BANNERS COMPLETED ###################################################

############################### CHECK MISC ################


check_misc_variable=0;
awk '/CHECK MISC/{f=1;next} /END OF FILE/{f=0} f' Script_vulnerability_violation.txt | grep "Check" | awk '{for (i=2;i<NF;i++) printf $i " "; print $NF}' | awk 'NF{NF-=1};1' > sub_check.txt
misc_flag=`awk '/CHECK MISC/{f=1;next} /END OF FILE/{f=0} f' Script_vulnerability_violation.txt | sed  '/^$/d' | wc -l`
misc_check_flag=`awk '/CHECK MISC/{f=1;next} /END OF FILE/{f=0} f' Script_vulnerability_violation.txt  | sed  '/^$/d' | grep -i "check" | wc -l`

if [ $misc_check_flag -eq 0 ] ; then
   echo " <tr> " >> $TEMP
   echo " <th>CHECK MISC</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>YES</td> " >> $TEMP
   echo " <td>NA</td> " >> $TEMP

elif [ $misc_flag -eq 0 ] ; then
  echo " <tr> " >> $TEMP
   echo " <th>CHECK MISC</th> " >> $TEMP
   echo " <th>NA</th> " >> $TEMP
   echo " <td>NO</td> " >> $TEMP
   echo " <td>Not Defined</td> " >> $TEMP

else

cat sub_check.txt | while read x
do
 target_check=`echo $x | cut -d " " -f2`
check_misc=`awk '/CHECK MISC/{f=1;next} /END OF FILE/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT" | wc -l`
check_misc_comment=`awk '/CHECK MISC/{f=1;next} /END OF FILE/{f=0} f' Script_vulnerability_violation.txt  | grep -i "$target_check" | tail -1 | egrep "NO|NOT"`
    if [ $check_misc_variable -eq 0 ] ; then
    echo " <tr> " >> $TEMP
    rowspan=`cat sub_check.txt | wc -l`
    echo " <th ROWSPAN=$rowspan>CHECK MISC</th> " >> $TEMP


    echo " <th>$x</th> " >> $TEMP


        if [ $check_misc -ne 0 ] ; then

             echo " <td>NO</td> " >> $TEMP
             echo " <td>$check_misc_comment</td> " >> $TEMP
        else
             echo " <td>Yes</td> " >> $TEMP
             echo " <td>No Issue</td> " >> $TEMP

        fi
             echo " </tr> " >> $TEMP
             #echo "lilo grub variable is : $lilo_grub_variable"
        #lilo_grub_variable=`expr $lilo_grub_variable + 1`

    else

         echo " <tr> " >> $TEMP
         echo " <th>$x</th> " >> $TEMP

         if [ $check_misc -ne 0 ] ; then
         echo " <td>NO</td> " >> $TEMP
         echo " <td>$check_misc_comment</td> " >> $TEMP
        else
          echo " <td>Yes</td> " >> $TEMP
          echo " <td>No Issue</td> " >> $TEMP
        fi

         echo " </tr> " >> $TEMP

     fi

check_misc_variable=`expr $check_misc_variable + $flag`
#echo "lilo grub variable is : $lilo_grub_variable"
done

fi

########################## CHECK MISC COMPLETED ###################################################

echo " </body> " >> $TEMP
echo " </html> " >> $TEMP
 cp $TEMP $home/page8.htm
 wkhtmltopdf page8.htm page8.pdf

