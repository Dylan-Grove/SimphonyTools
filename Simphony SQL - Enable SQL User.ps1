$Query = @"
Alter login $Username enable
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