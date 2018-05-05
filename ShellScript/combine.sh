#!/bin/sh
home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/
sh script-Linux-generic-scripts.sh
######## Creating combined script for pdf report
###########Go to Script home path
cd $home
#####removing page1.htm , if it was generated previously
if [ -f page1.htm ] ; then
  rm page1.htm
fi

#####removing page1.pdf , if it was generated previously
if [ -f page1.pdf ] ; then
  rm page1.pdf
fi

#####removing page2.htm , if it was generated previously
if [ -f page2.htm ] ; then
  rm page2.htm
fi

#####removing page2.pdf , if it was generated previously
if [ -f page2.pdf ] ; then
  rm page2.pdf
fi

#####removing page3.htm , if it was generated previously
if [ -f page3.htm ] ; then
  rm page3.htm
fi

#####removing page3.pdf , if it was generated previously
if [ -f page3.pdf ] ; then
  rm page3.pdf
fi


#####removing page4.htm , if it was generated previously
if [ -f page4.htm ] ; then
  rm page4.htm
fi

#####removing page4.pdf , if it was generated previously
if [ -f page4.pdf ] ; then
  rm page4.pdf
fi

#####removing page5.htm , if it was generated previously
if [ -f page5.htm ] ; then
  rm page5.htm
fi

#####removing page5.pdf , if it was generated previously
if [ -f page5.pdf ] ; then
  rm page5.pdf
fi


#####removing page6.htm , if it was generated previously
if [ -f page6.htm ] ; then
  rm page6.htm
fi

#####removing page6.pdf , if it was generated previously
if [ -f page6.pdf ] ; then
  rm page6.pdf
fi

#####removing page7.htm , if it was generated previously
if [ -f page7.htm ] ; then
  rm page7.htm
fi

#####removing page7.pdf , if it was generated previously
if [ -f page7.pdf ] ; then
  rm page7.pdf
fi

#####removing page8.htm , if it was generated previously
if [ -f page8.htm ] ; then
  rm page8.htm
fi

#####removing page8.pdf , if it was generated previously
if [ -f page8.pdf ] ; then
  rm page8.pdf
fi

####Checking existence of sonar.pdf file , if not then stop script execution

if [ ! -f sonar.pdf ] ; then
echo "sonar.pdf is not exist , please push it on $home location , hence stopping script execution"
exit
fi

if [ ! -d accessiblity_violation ] ; then
echo "accessiblity_violation directory is not present in current location , hence stopping script execution , please push accessiblity_violation folder on target location "
exit
fi

if [ ! -f Script_vulnerability_violation.txt ] ; then
echo "Script_vulnerability_violation.txt not present , please execute vulnerability violation script and save the output on Script_vulnerability_violation file"
exit
fi

####Run Script for First page
sh page1.sh
####Run Script for Second page
sh page2.sh
#####Run Script for Third page
sh page3.sh
#####Converting sonar.pdf file to sonar.txt for reading purpose
pdftotext -layout sonar.pdf sonar.txt
#####Run Script for Fourth page
sh page4.sh
######Run Script for fifth page
sh page5.sh
######Run Script for sixth page
sh page6.sh
######Run Script for seventh page
sh page7.sh
######Run Script for eighth page
sh page8.sh
##################Combine all pdf to one single pdf #############################
pdfunite page1.pdf page2.pdf page3.pdf page4.pdf page5.pdf page6.pdf page7.pdf page8.pdf assesment_completion_report.pdf

