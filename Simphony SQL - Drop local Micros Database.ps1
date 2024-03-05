$Query = @"
drop database datastore
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

shutdown /r /t 0