#!/bin/sh
flag4=1
TEMP=$(mktemp -t page7.XXXXX)
home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/
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
<!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">

      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Title');
        data.addColumn('number', 'Value');
EOF

pdftotext -layout sonar.pdf sonar.txt
grep -w "Rule" sonar.txt | tr -s " " | awk -F' ' '{print $2,$3}' > bug_list.txt
echo " data.addRows([ " >> $TEMP

cat bug_list.txt | while read x
do
   bug_name=`echo $x`
#####flag1 counts total no of commas ##########
   flag1=`eval "awk '/Rule "${bug_name}"/{flag=1;next}/^$/{flag=0}flag'" target.txt | grep -o "," | wc -l`
 echo " flag1 is $flag1"
#####flag2 counts total no of commas ##########
   flag2=`eval "awk '/Rule "${bug_name}"/{flag=1;next}/^$/{flag=0}flag'" target.txt  | wc -l`
 echo " flag2 is $flag2 "
#####flag3 counts total no of line ends with comma ##########
   flag3=`eval "awk '/Rule "${bug_name}"/{flag=1;next}/^$/{flag=0}flag'" target.txt | sed -e's/  */ /g' | awk -F" " '{print $NF}' | grep -oc ","`
 echo " flag3 is $flag3 "
######counter count total no of commas after operation #########
   counter=`expr $flag1 + $flag2`
echo "counter is $counter"
   counter2=`expr $flag3 + $flag4`
echo "counter2 is $counter2"
####counter3 is total no of comma for a specified bug
   counter3=`expr $counter - $counter2`
echo "counter3 is $counter3"
        echo " ['$bug_name', $counter3], " >> $TEMP
done



        echo " ]); " >> $TEMP

        echo " var options = {'title':'Vulnerability Summary', " >> $TEMP
                      echo " 'width':1000, " >> $TEMP
                       echo " 'height':900}; " >> $TEMP

        echo " var chart = new google.visualization.PieChart(document.getElementById('chart_div')); " >> $TEMP
        echo " chart.draw(data, options); " >> $TEMP
      echo " } " >> $TEMP
    echo " </script> " >> $TEMP
echo " </head> " >> $TEMP
echo " <body> " >> $TEMP
echo ' <div style="background-color:#3F51B5;height:100px;width: 80%;margin-left: 10%;"> ' >> $TEMP
echo ' <div style="float:left;height:100%;width:25%;"><img style="height:63px;width:93%;margin-top:8px;margin-left:10px;" src="http://www.underconsideration.com/brandnew/archives/accenture_logo.png"> ' >> $TEMP
echo " </div> " >> $TEMP
echo ' <div style="float:left; height:100%; width:75%"> ' >> $TEMP
echo ' <h1 style="margin-top: 3%;color:white;text-align:right;">PS Industry Compliance Assessment-Completion Report</h1> ' >> $TEMP
echo " </div> " >> $TEMP
echo " </div> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <br> " >> $TEMP
echo " <center> " >> $TEMP
echo " <div id="chart_div"></div> " >> $TEMP
echo " </center> " >> $TEMP
echo " </body> " >> $TEMP
echo " </html> " >> $TEMP

cp $TEMP $home/page7.htm
wkhtmltopdf page7.htm page7.pdf

