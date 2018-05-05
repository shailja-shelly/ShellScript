#!/bin/sh
TEMP=$(mktemp -t page6.XXXXX)

home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/

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
"><b>Accessibility Violation</b></th></tr>
<tr><th style="
    font-size: 23px;"
"><b>filename</b></th><th style="
    font-size: 23px;"
"><b>Error</b></th><th style="
    font-size: 23px;"
"><b>Warning</b></th><th style="
    font-size: 23px;"
"><b>Notice</b></th></tr>
EOF


cd accessiblity_violation
ls -lrt | awk -F" " '{print $NF}' | grep csv > accessiblity_files.txt

cat accessiblity_files.txt | while read x
do
###################  Counting of Errors  #############################
error_count=`cut -d "," -f1 $x | grep -wc "error"`
###################  Counting of Warning  #############################
warning_count=`cut -d "," -f1 $x | grep -wc "warning"`
###################  ounting of Notice   #############################
notice_count=`cut -d "," -f1 $x | grep -wc "notice"`

echo " <tr> " >> $TEMP
echo " <td bgcolor="lightgrey">$x</td> " >> $TEMP
echo " <td bgcolor="lightgrey">$error_count</td> " >> $TEMP
echo " <td bgcolor="lightgrey">$warning_count</td> " >> $TEMP
echo " <td bgcolor="lightgrey">$notice_count</td> " >> $TEMP

echo " </tr> " >> $TEMP

done
echo " </tbody></table> " >> $TEMP
echo " </center> " >> $TEMP
echo " </div> " >> $TEMP

##################Starting Script for preparing Vulnerability Violation Table #############

echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP



echo " </body></html> " >> $TEMP
cp $TEMP $home/page6.htm
cd $home
wkhtmltopdf page6.htm page6.pdf

