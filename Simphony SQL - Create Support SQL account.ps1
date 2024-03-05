#Stops servicehost, drops the database, then reboots
$Query = @"
create login Support with password='ENTERPASSWORDHERE'
exec sp_addsrvrolemember Support,sysadmin;
go
exit
"@

$Query > C:\windows\temp\sqlcmdquery.sql

Get-Process -Name Servicehost | Stop-Process -force

net stop 'MSSQL$SQLEXPRESS'
net start 'MSSQL$SQLEXPRESS' /m
sqlcmd -S localhost\SQLEXPRESS -i C:\windows\temp\sqlcmdquery.sql
net stop 'MSSQL$SQLEXPRESS'
net start 'MSSQL$SQLEXPRESS'