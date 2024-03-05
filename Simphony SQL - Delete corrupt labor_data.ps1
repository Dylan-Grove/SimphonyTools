#Stops servicehost, drops the database, then reboots
$Query = @"
use checkpostingdb
delete from labor_data where type in (13,14);
go
exit
"@

$Query > C:\windows\temp\sqlcmdquery.sql

Get-Process -Name Servicehost | Stop-Process -force

net stop 'MSSQL$SQLEXPRESS'
net start 'MSSQL$SQLEXPRESS' /m
sqlcmd -S .\SQLExpress -U Support -P Support@123 -i C:\windows\temp\sqlcmdquery.sql
net stop 'MSSQL$SQLEXPRESS'
net start 'MSSQL$SQLEXPRESS'
