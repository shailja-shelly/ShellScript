#!/bin/sh
TEMP=$(mktemp -t page2.XXXXX)
home=/home/ramkumar.manivel/workspace/PS_WORKSPACE/PS_PROJECT/PS_Assessment_completion_report/securityScripts/
cat > $TEMP <<EOF

<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 2px solid black;
    border-collapse: collapse;
}
body {
    
    text-align: middle;
}
</style>
</head>
<body>
<center>
<h2>Classification and Distribution List</h2>
<table>
<tr><td><p style="font-size:100%"><b>Security Notice: </b>The information contained within this document is CONFIDENTIAL. Unauthorized &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
disclosure is prohibited. Failure to observe Accenture policy regarding proprietary information can &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
result in disciplinary action, including dismissal, as well as result in a violation of Accenture. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
Proprietary rights and subject you and/or third parties to legal liability.  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p></td>
</tr>
</table>
<br>
<p style="font-size:120%"><b>Classification:</b>&nbsp;CONFIDENTIAL</p>
<br>
<table>
<tr><td><p style="font-size:100%">
<p>&#10004; Do not forward or copy data in part or full with out explicit permission of Project Owner Name &nbsp;&nbsp;&nbsp;<br>&#10004; Data access is limited to the <b>access list provided below</b><br>&#10004; Use Strong authentication / EFS Encryption / Lock in a Drawer <br>&#10004; Log access in a register <br>&#10004; Retention period is for <b>current final version (0) and previous final version (-1) of this document</b></p>
</td>
</tr>
</table>

<h2>Version History</h2>
<table>
<tr bgcolor="C0C0C0"><th width="30%">Version</th><th width="20%">Date</th><th width="20%">Approver for <br>Change</th>
<th width="20%">Author</th><th width="20%">Change <br>Description</th></tr>
<tr bgcolor="FFFF00"><td widtd="30%"><br><br><br></td><td width="20%"></td><td widtd="20%"> </td>
<td widtd="20%"></td><td widtd="20%"></td></tr>
</table>

<h2>Distribution / Access </h2>
<table>
<tr bgcolor="C0C0C0"><th rowspan="2">Name</th><th rowspan="2">Role</th><th width="20%">Access Type</th></tr>
<tr bgcolor="C0C0C0"><th width="20%">Read Only / Editor</th></tr>
<tr bgcolor="FFFF00"><td width="30%"><br><br></td><td width="20%"></td><td width="20%"> </td></tr>
<tr bgcolor="FFFF00"><td width="30%"><br><br></td><td width="20%"></td><td width="20%"> </td></tr>
</table>
<footer>
PS Industry Compliance Assessment_Tracker-V1.0 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    2&nbsp; of&nbsp; 10  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1/16/20176:44 PM
</footer>
</center>
</body>
</html>
EOF
cp $TEMP $home/page2.htm
wkhtmltopdf page2.htm page2.pdf

