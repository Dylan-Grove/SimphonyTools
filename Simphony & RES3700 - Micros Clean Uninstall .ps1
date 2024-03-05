#Stops all running micros programs, runs the uninstaller silently, removes the micros registry key, deletes extra folders.

$AnswerFile = @'
[{D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-DlgOrder]
Dlg0={D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-SdWelcomeMaint-0
Count=3
Dlg1={D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-MessageBox-0
Dlg2={D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-SdFinish-0
[{D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-SdWelcomeMaint-0]
Result=303
[{D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-MessageBox-0]
Result=6
[{D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-SdFinish-0]
Result=1
bOpt1=0
bOpt2=0
'@

$ResAnswerFile = @'
[{6E276C72-EEAD-49A0-9657-E9FEB897E618}-DlgOrder]
Dlg0={6E276C72-EEAD-49A0-9657-E9FEB897E618}-SdWelcomeMaint-0
Count=3
Dlg1={6E276C72-EEAD-49A0-9657-E9FEB897E618}-MessageBox-0
Dlg2={6E276C72-EEAD-49A0-9657-E9FEB897E618}-SdFinish-0
[{6E276C72-EEAD-49A0-9657-E9FEB897E618}-SdWelcomeMaint-0]
Result=303
[{6E276C72-EEAD-49A0-9657-E9FEB897E618}-MessageBox-0]
Result=6
[{6E276C72-EEAD-49A0-9657-E9FEB897E618}-SdFinish-0]
Result=1
bOpt1=0
bOpt2=0
'@


mkdir C:\bin
mkdir C:\bin\McrsCAL144

$AnswerFile > C:\bin\McrsCAL144\uninstall.iss
$ResAnswerFile > C:\bin\McrsCAL144\resuninstall.iss


Get-Process -Name Servicehost | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name McrsCal | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -name WIN7CALStart | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name DbUpdateServer | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name MDSHTTPService | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name KDSController | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name ops | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name Periphs | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name CTUtil | Stop-Process -force -ErrorAction SilentlyContinue
Get-Process -Name AppStarter | Stop-Process -force -ErrorAction SilentlyContinue

SC Stop "MICROS Backup Server"
SC Stop "MICROS CAL Client"
SC Stop "MICROS Credit Card Server"
SC Stop "DbUpdateServer"
SC Stop "MICROS ILDS Server"
SC Stop "MICROS Interface Server"
SC Stop "MICROS KDS Controller"
SC Stop "srvMDSHTTPService"
SC Stop "MICROS Print Controller"
#SC Stop "MSSQL$SQLEXPRESS"
#SC Stop "SQLAgent$SQLEXPRESS"

SC Delete "MICROS Backup Server"
SC Delete "MICROS CAL Client"
SC Delete "MICROS Credit Card Server"
SC Delete "DbUpdateServer"
SC Delete "MICROS ILDS Server"
SC Delete "MICROS Interface Server"
SC Delete "MICROS KDS Controller"
SC Delete "srvMDSHTTPService"
SC Delete "MICROS Print Controller"
#SC Delete "MSSQL$SQLEXPRESS"
#SC Delete "SQLAgent$SQLEXPRESS"

C:\Bin\McrsCAL144\setup.exe /s /f1C:\bin\McrsCAL144\uninstall.iss
C:\Temp\setup.exe /s /f1C:\bin\McrsCAL144\resuninstall.iss

Remove-item c:\micros -force -Recurse
Remove-item 'C:\Program Files (x86)\MICROS' -recurse -force
Remove-item c:\Win32Registry.bat -force -ErrorAction SilentlyContinue
Remove-item c:\dotnetfx35.exe -force -ErrorAction SilentlyContinue
Remove-item c:\PrereqCheck.exe -force -ErrorAction SilentlyContinue
Remove-item c:\vcredist_x86.exe -force -ErrorAction SilentlyContinue
Remove-item c:\PrepareForinstallation.bat -force -ErrorAction SilentlyContinue
Remove-item c:\MicrosRegSettings.reg -force -ErrorAction SilentlyContinue
Remove-item c:\Kill.exe -force -ErrorAction SilentlyContinue
Remove-item 'c:\ProgramData\Microsoft\Windows\Start Menu\Programs\MICROS Applications' -recurse -force -ErrorAction SilentlyContinue
Remove-item 'c:\ProgramData\Microsoft\Windows\Start Menu\Programs\MICROS Client Application Loader' -recurse -force -ErrorAction SilentlyContinue
Remove-item c:\CALTemp -force -Recurse -ErrorAction SilentlyContinue
Remove-item c:\Install -force -Recurse -ErrorAction SilentlyContinue
Remove-item 'C:\Program Files\MICROS' -recurse -force -ErrorAction SilentlyContinue
#Remove-item 'C:\Program Files\Microsoft Point Of Service' -recurse -force -ErrorAction SilentlyContinue
#Remove-item 'C:\Program Files\Microsoft SQL Server' -recurse -force -ErrorAction SilentlyContinue
#Remove-item 'C:\Program Files (x86)\Microsoft SQL Server' -recurse -force -ErrorAction SilentlyContinue
#Remove-item 'C:\Program Files\Microsoft SQL Server' -recurse -force -ErrorAction SilentlyContinue
#Remove-item 'C:\Program Files (x86)\Microsoft SQL Server' -recurse -force -ErrorAction SilentlyContinue
#Remove-item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\MICROS Simphony' -recurse -force -ErrorAction SilentlyContinue
#Remove-item 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft SQL Server 201' -recurse -force -ErrorAction SilentlyContinue

Remove-Item 'HKLM:\SOFTWARE\WOW6432Node\Micros' -recurse -force
Remove-Item 'HKLM:\SOFTWARE\Micros' -recurse -force
Remove-Item 'HKLM:\SOFTWARE\WOW6432Node\Micros' -recurse -force
#Remove-item "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server" -recurse -force
#Remove-item "HKLM:\SYSTEM\CurrentControlSet\Services\MSSQL$SQLEXPRESS" -recurse -force
#Remove-item "HKLM:\SYSTEM\CurrentControlSet\Services\SQLAgent$SQLEXPRESS" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{5B2CB8F5-3151-4B85-8EC7-E7BF1CFC8646}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{30CA21F2-901A-44DB-A43F-FC31CD0F2493}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{54F84805-0116-467F-8713-899DFC472235}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{7D29ED63-84F9-4EC7-B49F-994A3A3195B2}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{87D50333-E534-493A-8E98-0A49BC28F64B}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{C22613C2-C7A4-4761-A906-116ECD4E7477}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{D0F44C37-A22B-4733-BBA7-86C9F4988725}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{EECD1187-14B3-405E-8028-DA81045AD813}" -recurse -force
#Remove-item "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft SQL Server 11" -recurse -force