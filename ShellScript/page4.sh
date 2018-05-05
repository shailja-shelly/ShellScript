#!/bin/sh
flag4=1
value=1
total=0
#final_total=""
home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/
declare -i final_total
TEMP=$(mktemp -t page4.XXXXX)
if [ -f sorting.txt ] ; then
rm sorting.txt
fi

if [ -f sorted.txt ] ; then
rm sorted.txt
fi

touch sorting.txt
cat sonar.txt | sed -e's/  */ /g' > target.txt
cat > $TEMP <<EOF
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=us-ascii">
<style>
table, th, td {
    border: 2px solid black;
    border-collapse: collapse;
}
</style>
</head>
<body>
<div style="background-color:#3F51B5;height:100px;width: 80%;margin-left: 10%;">
<div style="float:left;height:100%;width:25%;"><img style="height:63px;width:93%;margin-top:8px;margin-left:10px;" src="http://www.underconsideration.com/brandnew/archives/accenture_logo.png">
</div>
<div style="float:left; height:100%; width:75%">
<h1 style="margin-top: 3%;color:white;text-align:right;">PS Industry Compliance Assessment-Completion Report</h1>
</div>
</div>
<br>
<br>
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
"><th colspan="3" style="
    font-size: 23px;"
"><b>Defects Summary</b></th></tr>
<tr><th style="font-size: 20px">S No.</th><th style="font-size: 20px">Bug Type</th><th style="font-size: 20px">Count</th></tr>
EOF


grep -w "Rule" sonar.txt | tr -s " " | awk -F' ' '{print $2,$3}' > bug_list.txt
cat bug_list.txt |( while read x
do
   bug_name=`echo $x`
#####flag1 counts total no of commas ##########
   flag1=`eval "awk '/Rule "${bug_name}"/{flag=1;next}/^$/{flag=0}flag'" target.txt | grep -o "," | wc -l`

#####flag2 counts total no of commas ##########
   flag2=`eval "awk '/Rule "${bug_name}"/{flag=1;next}/^$/{flag=0}flag'" target.txt  | wc -l`
#####flag3 counts total no of line ends with comma ##########
   flag3=`eval "awk '/Rule "${bug_name}"/{flag=1;next}/^$/{flag=0}flag'" target.txt | sed -e's/  */ /g' | awk -F" " '{print $NF}' | grep -oc ","`
######counter count total no of commas after operation #########
   counter=`expr $flag1 + $flag2`
   counter2=`expr $flag3 + $flag4`
####counter3 is total no of comma for a specified bug
   counter3=`expr $counter  - $counter2`
######echo "counter is : $counter3"
echo "$counter3,$bug_name" >> sorting.txt

echo " <tr> " >> $TEMP
echo " <td bgcolor="lightgrey">$value</td> " >> $TEMP
echo " <td bgcolor="lightgrey">$bug_name</td> " >> $TEMP
if [ $counter3 -gt 10 ] ; then
echo " <td bgcolor="red">$counter3</td>" >> $TEMP
elif [ $counter3 -gt 5 -a $counter3 -le 10 ] ; then
echo " <td bgcolor="#ffbf00">$counter3</td>" >> $TEMP
else
echo " <td bgcolor="green">$counter3</td>" >> $TEMP
fi
echo " </tr> " >> $TEMP
total=`expr $total + $counter3`
#final_total=`echo $total`
value=`expr $value + 1`
done
final_total=`echo $total`
echo " <tr bgcolor="#3F51B5"> " >> $TEMP
echo " <th colspan="2">Total.</th> " >> $TEMP
echo " <th>$final_total</th> " >> $TEMP )

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
echo ' <th colspan="2" style="font-size: 23px;"> Top 5 Issues </th> ' >> $TEMP
echo " </tr> "  >> $TEMP
sort -nr sorting.txt | head -5 > sorted.txt
cat sorted.txt | while read x
do
 FLD1=`echo $x | cut -d "," -f2`
 FLD2=`echo $x | cut -d "," -f1`
echo " <tr> " >> $TEMP
echo " <td bgcolor="lightgrey">$FLD1</td> " >> $TEMP
if [ $FLD2 -gt 10 ] ; then
echo " <td bgcolor="red">$FLD2</td> " >> $TEMP
fi
if [ $FLD2 -le 10 -a $FLD2 -gt 5 ] ; then
echo " <td bgcolor="#ffbf00">$FLD2</td> " >> $TEMP
fi
if [ $FLD2 -le 5 ] ; then
echo " <td bgcolor="green">$FLD2</td> " >> $TEMP
fi
echo " </tr> " >> $TEMP
done
echo " </tbody></table> " >> $TEMP
echo " </center> " >> $TEMP
echo " </div> " >> $TEMP

echo " </body></html> " >> $TEMP

cp $TEMP $home/page4.htm
wkhtmltopdf page4.htm page4.pdf


