#!/bin/sh
TEMP=$(mktemp -t page3.XXXXX)
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
"><th colspan="2" style="
    text-align: left;
    font-size: 23px;"
"><b>Instruction</b></th></tr>
<tr><th style="font-size: 20px">SpreadSheet Name</th><th style="font-size: 20px">Description</th></tr>
<tr><td style="
    font-size: 18px;"
">Defects Summary</td><td style="
    font-size: 18px;">This sheet contains the summary of review result.</td></tr>
<tr><td style="
    font-size: 18px;">Defects List</td><td style="
    font-size: 18px;">This sheet give high level overview of defects identified in the application.</td></tr>
<tr><td style="
    font-size: 18px;">Defect Instances</td><td style="
    font-size: 18px;">This sheet contains the details of identified Vulnerability/Accessibility/Code Quality and ecommendations for each defect type This sheet can also be used for status tracking.
</td>
</tr>
<tr><td style="
    font-size: 18px;">Code Coverage</td><td style="
    font-size: 18px;">This sheet is the tracker for files scanned and the status of files</td></tr>
<tr><td style="
    font-size: 18px;">Summary-Graph</td><td style="
    font-size: 18px;">This sheet shows the report summary in graphical format files</td></tr>
</tbody></table>
</center>
</div>


</body></html>
EOF
cp $TEMP $home/page3.htm
wkhtmltopdf page3.htm page3.pdf
