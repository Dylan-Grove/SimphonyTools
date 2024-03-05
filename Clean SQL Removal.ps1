#Removes a few SQL folders and regkeys

Get-Process -Name sqlwriter | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name sqlservr | Stop-Process -force -ErrorAction SilentlyContinue

SC.exe Stop 'MSSQL$SQLEXPRESS'
SC.exe Stop 'SQLAgent$SQLEXPRESS'
SC.exe Stop MSSQL$SQLEXPRESS
SC.exe Stop SQLAgent$SQLEXPRESS
SC.exe Stop SQLBrowser
SC.exe Stop SQLWriter
SC.exe Stop SQLAgent$SQLEXPRESS
SC.exe Delete SQLAgent$SQLEXPRESS
SC.exe Delete 'MSSQL$SQLEXPRESS'
SC.exe Delete 'SQLAgent$SQLEXPRESS'
SC.exe delete MSSQL$SQLEXPRESS
SC.exe Delete SQLAgent$SQLEXPRESS
SC.exe Delete SQLBrowser
SC.exe Delete SQLWriter

Remove-item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft SQL Server 2012' -recurse -force -ErrorAction SilentlyContinue
Remove-item 'C:\Program Files\Microsoft SQL Server' -recurse -force -ErrorAction SilentlyContinue
Remove-item 'C:\Program Files (x86)\Common Files\Microsoft Shared\SQL Debugging' -recurse -force -ErrorAction SilentlyContinue
Remove-item 'C:\Program Files (x86)\Microsoft SQL Server' -recurse -force -ErrorAction SilentlyContinue

Remove-item 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 12' -recurse -force
Remove-item 'HKLM:\SOFTWARE\Microsoft\MSSQLServer' -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server" -recurse -force
Remove-item "HKLM:\SYSTEM\CurrentControlSet\Services\MSSQL$SQLEXPRESS" -recurse -force
Remove-item "HKLM:\SYSTEM\CurrentControlSet\Services\SQLAgent$SQLEXPRESS" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server Native Client 11.0" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Microsoft SQL Server Redist" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\MSSQLServer" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\SQLNCLI11" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{5B2CB8F5-3151-4B85-8EC7-E7BF1CFC8646}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{30CA21F2-901A-44DB-A43F-FC31CD0F2493}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{54F84805-0116-467F-8713-899DFC472235}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{7D29ED63-84F9-4EC7-B49F-994A3A3195B2}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{87D50333-E534-493A-8E98-0A49BC28F64B}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{C22613C2-C7A4-4761-A906-116ECD4E7477}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{D0F44C37-A22B-4733-BBA7-86C9F4988725}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{EECD1187-14B3-405E-8028-DA81045AD813}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{124D51A1-F3C2-45AE-B812-D3CA71247093}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{4B9E6EB0-0EED-4E74-9479-F982C3254F71}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6603C2CE-3C54-4F1D-92F9-8390CD4CCCA8}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{54FF8FAB-DE27-4187-82F1-EBAE6AEE869A}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{26773F6F-E7B5-4F58-9347-0347C998BA7D}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{202AAF1F-69AA-442A-B59F-6B54B1AD07C6}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1D411379-9CE0-4B13-A19B-72D3222DD620}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{076FF390-D283-4174-B602-B0B7B72BD024}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{0259C5EE-D53B-40A0-80A7-30C88D217749}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{6603C2CE-3C54-4F1D-92F9-8390CD4CCCA8}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9AE22681-C27C-402A-A136-15854DFF693D}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B40EE88B-400A-4266-A17B-E3DE64E94431}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{C22864D5-FB3F-4609-BF0C-ADBCC70742C4}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{3E0DD83F-BE4C-4478-86A0-AD0D79D1353E}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{B40EE88B-400A-4266-A17B-E3DE64E94431}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{BDF7F870-15E2-49A7-9123-65E8FF52ECAA}" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{BED1EA3D-592D-4305-9D1F-20F03726EFC1}" -recurse -force
Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 11" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 11" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server SQLServer2012" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server 2005 Redist" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server 2012 Redist" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server Native Client 11.0" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server Redist" -recurse -force
Remove-item "HKLM:\SOFTWARE\Microsoft\SQLNCLI11" -recurse -force
