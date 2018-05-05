#!/bin/sh
TEMP=$(mktemp -t page1.XXXXX)
home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/
cat > $TEMP <<EOF
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
</style>
</head>
<body>
<div style="text-align:center">
      <img src="https://business.aib.ie/content/dam/aib/business/images/my-business-is/technology/accelerators-and-incubators/Accenture.png"
        style="float:middle">

     </div>
<div style="text-align:center">
<h2>PS Industry Compliance Assessment-Completion Report</h2>
</div>
<div>
<font size="5">Project-Name<br></font>
<font size="4">IDC</font>
</div>
<br>
<br>
<br>
<div>
<table style="width:100%">
<tr><th>Prepared By</th><th>Reviewed By</th><th>Approved By</th></tr>
<tr><td>Version No: 1.0</td><td>Status: Active</td><td>Date:</td></tr>
</table>
</div>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<footer>
PS Industry Compliance Assessment_Tracker-V1.0 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    1&nbsp; of&nbsp; 10  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  1/16/20176:44 PM
</footer>
</body>

</html>
EOF
cp $TEMP $home/page1.htm
wkhtmltopdf page1.htm page1.pdf

