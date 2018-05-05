#!/bin/sh
TEMP=$(mktemp -t page5.XXXXX)
home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/
cat sonar.txt | sed -e's/  */ /g' > target1.txt
cat > $TEMP <<EOF
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">
<style>
table,th {
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
"><th colspan="2" style="
    font-size: 23px;"
"><b>Most violated rules</b></th></tr>
EOF


#grep -w "Rule" sonar.txt | tr -s " " | awk -F' ' '{print $2,$3}' > bug_list.txt
awk '/Most violated rules/{flag=1;next}/^$/{flag=0}flag' target1.txt > violated_rules.txt

cat violated_rules.txt | while read x
do
   FLD1=`echo $x | awk -F' ' '{print $1,$2}'`
   FLD2=`echo $x | awk -F' ' '{print $3}'`

echo " <tr> " >> $TEMP
echo " <td bgcolor="lightgrey">$FLD1</td> " >> $TEMP
echo " <td bgcolor="lightgrey">$FLD2</td> " >> $TEMP
echo " </tr> " >> $TEMP
done
echo " </tbody></table> " >> $TEMP
echo " </center> " >> $TEMP
echo " </div> " >> $TEMP

echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP


echo " <div> " >> $TEMP
echo " <center> " >> $TEMP
echo ' <table style="width: 80%;"> ' >> $TEMP
echo " <tbody> " >> $TEMP
echo " <tr bgcolor="#3F51B5"> " >> $TEMP
echo ' <th colspan="2" style="font-size: 23px;"> Most violated files </th> ' >> $TEMP
echo " </tr> "  >> $TEMP

awk '/Most violated files/{flag=1;next}/^$/{flag=0}flag' target1.txt > violated_files.txt
cat violated_files.txt | while read x
do
   FLD1=`echo $x | awk -F' ' '{print $1}'`
   FLD2=`echo $x | awk -F' ' '{print $2}'`
echo " <tr> " >> $TEMP
echo " <td bgcolor="lightgrey">$FLD1</td> " >> $TEMP
echo " <td bgcolor="red">$FLD2</td> " >> $TEMP
echo " </tr> " >> $TEMP
done
echo " </tbody></table> " >> $TEMP
echo " </center> " >> $TEMP
echo " </div> " >> $TEMP


echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP


echo " <div> " >> $TEMP
echo " <center> " >> $TEMP
echo ' <table style="width: 80%;"> ' >> $TEMP
echo " <tbody> " >> $TEMP
echo " <tr bgcolor="#3F51B5"> " >> $TEMP
echo ' <th colspan="2" style="font-size: 23px;"> Most complex files </th> ' >> $TEMP
echo " </tr> "  >> $TEMP

awk '/Most complex files/{flag=1;next}/^$/{flag=0}flag' target1.txt > complex_files.txt
cat complex_files.txt | while read x
do
   FLD1=`echo $x | awk -F' ' '{print $1}'`
   FLD2=`echo $x | awk -F' ' '{print $2}'`
echo " <tr> " >> $TEMP
echo " <td bgcolor="lightgrey">$FLD1</td> " >> $TEMP
echo " <td bgcolor="red">$FLD2</td> " >> $TEMP
echo " </tr> " >> $TEMP
done
echo " </tbody></table> " >> $TEMP
echo " </center> " >> $TEMP
echo " </div> " >> $TEMP

echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP


echo " <div> " >> $TEMP
echo " <center> " >> $TEMP
echo ' <table style="width: 80%;"> ' >> $TEMP
echo " <tbody> " >> $TEMP
echo " <tr bgcolor="#3F51B5"> " >> $TEMP
echo ' <th colspan="2" style="font-size: 23px;"> Most duplicated files </th> ' >> $TEMP
echo " </tr> "  >> $TEMP

awk '/Most duplicated files/{flag=1;next}/^$/{flag=0}flag' target1.txt > duplicate_files.txt
cat duplicate_files.txt | while read x
do
   FLD1=`echo $x | awk -F' ' '{print $1}'`
   FLD2=`echo $x | awk -F' ' '{print $2}'`
echo " <tr> " >> $TEMP
echo " <td bgcolor="lightgrey">$FLD1</td> " >> $TEMP
echo " <td bgcolor="red">$FLD2</td> " >> $TEMP
echo " </tr> " >> $TEMP
done
echo " </tbody></table> " >> $TEMP
echo " </center> " >> $TEMP
echo " </div> " >> $TEMP

echo " </body></html> " >> $TEMP

cp $TEMP $home/page5.htm
wkhtmltopdf page5.htm page5.pdf


