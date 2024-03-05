#Automatically reinstalls CAL. Please ensure the computer name is set correctly first. This also works on physical workstations but you need to go back once its done and change the resolution back. You can use this command to do it quickly: 
#c:\windows\temp\QRes.exe /x:1920 /y:1024

#You will need to adjust a lot of variables to make this script fit your environment. I'd reccomend going through the entire script. It's very usecase specific.

#Required variables in syncro:

#KeepPreReqFolder - Drop down options:
#Keep large installer files (faster)
#Delete all files (safer)

#RemoveSQL - Drop down options:
#Remove SQL [Caution]
#Keep SQL

#CALorRECAL - Drop down options:
#CAL a brand new workstation
#RECAL an existing workstation

#Required files:
#C:\bin\McrsCAL144\setup.exe
#C:\windows\temp\Qres.exe

#Credentials:
$WorkstationUsername = ''
$WorkstationPassword = ''
$SimphonyUsername = ''
$SimphonyPassword = ''

$SiteList = @(
    'Leave this line alone, 0 index line',
    'site1',
    'site2'
)

c:\windows\temp\QRes.exe /x:1280 /y:1024
$Gateway = [String](Get-NetIPConfiguration).IPv4DefaultGateway.NextHop


# Pull the site number from the computername the script is run on. This will be specific to your naming scheme. ours was P##WS. 
# The script uses this number to determine what site in the $sitelist in simphony you are caling to. 
If($env:COMPUTERNAME -like "*tb*"){$Sitenumber = [int]$ENV:Computername.ToUpper().split('P').split('T')[1]}
Elseif($env:COMPUTERNAME -like "*CAPS*"){$Sitenumber = [int]$ENV:Computername.ToUpper().split('P').split('C')[1]}
Elseif($env:COMPUTERNAME -like "*WSKDSDP*"){$Sitenumber = [INT]($ENV:Computername.ToUpper() -replace '[/\D+/g]','')}
Elseif($env:COMPUTERNAME -like "*KDS"){$Sitenumber = [int]$ENV:Computername.ToUpper().split('P').split('K')[1]}
Elseif($env:COMPUTERNAME -like "*STS"){$Sitenumber = [int]$ENV:Computername.ToUpper().split('P').split('S')[1]}
Elseif($env:COMPUTERNAME -like "*WS*"){$Sitenumber = [int]$ENV:Computername.ToUpper().split('P').split('W')[1]}

$SiteNamePosition = 380
$Site = $SiteList[$Sitenumber]

# Adjust for if a site includes the entire name of another site in it. example Site1 = Mcdonalds, Site2 = Big Mcdonalds.
# You would put Site1 below here so it selects the second site on the list instead of the first.
If ($Site -eq ''){$SiteNamePosition+=15}

# cSource for allowing keyboard and mouse inputs from powershell
$cSource = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class Clicker
{
//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646270(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct INPUT
{ 
    public int        type; // 0 = INPUT_MOUSE,
                            // 1 = INPUT_KEYBOARD
                            // 2 = INPUT_HARDWARE
    public MOUSEINPUT mi;
}

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646273(v=vs.85).aspx
[StructLayout(LayoutKind.Sequential)]
struct MOUSEINPUT
{
    public int    dx ;
    public int    dy ;
    public int    mouseData ;
    public int    dwFlags;
    public int    time;
    public IntPtr dwExtraInfo;
}

//This covers most use cases although complex mice may have additional buttons
//There are additional constants you can use for those cases, see the msdn page
const int MOUSEEVENTF_MOVED      = 0x0001 ;
const int MOUSEEVENTF_LEFTDOWN   = 0x0002 ;
const int MOUSEEVENTF_LEFTUP     = 0x0004 ;
const int MOUSEEVENTF_RIGHTDOWN  = 0x0008 ;
const int MOUSEEVENTF_RIGHTUP    = 0x0010 ;
const int MOUSEEVENTF_MIDDLEDOWN = 0x0020 ;
const int MOUSEEVENTF_MIDDLEUP   = 0x0040 ;
const int MOUSEEVENTF_WHEEL      = 0x0080 ;
const int MOUSEEVENTF_XDOWN      = 0x0100 ;
const int MOUSEEVENTF_XUP        = 0x0200 ;
const int MOUSEEVENTF_ABSOLUTE   = 0x8000 ;

const int screen_length = 0x10000 ;

//https://msdn.microsoft.com/en-us/library/windows/desktop/ms646310(v=vs.85).aspx
[System.Runtime.InteropServices.DllImport("user32.dll")]
extern static uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

public static void LeftClickAtPoint(int x, int y)
{
    //Move the mouse
    INPUT[] input = new INPUT[3];
    input[0].mi.dx = x*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Width);
    input[0].mi.dy = y*(65535/System.Windows.Forms.Screen.PrimaryScreen.Bounds.Height);
    input[0].mi.dwFlags = MOUSEEVENTF_MOVED | MOUSEEVENTF_ABSOLUTE;
    //Left mouse button down
    input[1].mi.dwFlags = MOUSEEVENTF_LEFTDOWN;
    //Left mouse button up
    input[2].mi.dwFlags = MOUSEEVENTF_LEFTUP;
    SendInput(3, input, Marshal.SizeOf(input[0]));
}
}
'@
Add-Type -TypeDefinition $cSource -ReferencedAssemblies System.Windows.Forms,System.Drawing
$wshell = New-Object -ComObject wscript.shell;




# Clean uninstall previous CAL. Also drops the local DB.

Taskkill /F /IM osk.exe

If($CALorRECAL -eq 'RECAL an existing workstation'){
    #Uninstall CAL
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
    mkdir C:\bin\
    mkdir C:\bin\McrsCAL144\
    $AnswerFile > C:\bin\McrsCAL144\uninstall.iss
    
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

    SC Delete "MICROS Backup Server"
    SC Delete "MICROS CAL Client"
    SC Delete "MICROS Credit Card Server"
    SC Delete "DbUpdateServer"
    SC Delete "MICROS ILDS Server"
    SC Delete "MICROS Interface Server"
    SC Delete "MICROS KDS Controller"
    SC Delete "srvMDSHTTPService"
    SC Delete "MICROS Print Controller"
    
    C:\Bin\McrsCAL144\setup.exe /s /f1C:\bin\McrsCAL144\uninstall.iss
    C:\Temp\setup.exe /s /f1C:\bin\McrsCAL144\resuninstall.iss
    
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

    Remove-Item 'HKLM:\SOFTWARE\WOW6432Node\Micros' -recurse -force
    Remove-Item 'HKLM:\SOFTWARE\Micros' -recurse -force
    
    if($KeepPreReqFolder -eq "Keep large installer files (faster)"){
        Remove-item C:\Micros\Simphony\CALTemp -force -Recurse
        Remove-item C:\Micros\Simphony\Download -force -Recurse
        Remove-item C:\Micros\Simphony\WebServer -force -Recurse
        Remove-item C:\Micros\Simphony\secdata.bin -force
        Remove-item C:\Micros\Simphony\ssd.bin -force
        Remove-item C:\Micros\Simphony\ssd.bin.bak -force
        Remove-item C:\Micros\res -force -Recurse

    }
    elseif($KeepPreReqFolder -eq 'Delete all files (safer)'){
        Remove-item c:\micros -force -Recurse
    }
    
    if($RemoveSQL -eq 'Remove SQL [Caution]'){
        SC.exe Stop "MSSQL$SQLEXPRESS"
        SC.exe Stop "SQLAgent$SQLEXPRESS"
        SC.exe Stop MSSQL$SQLEXPRESS
        SC.exe Stop SQLAgent$SQLEXPRESS
        SC.exe Stop SQLBrowser
        SC.exe Stop SQLWriter
        SC.exe Delete "MSSQL$SQLEXPRESS"
        SC.exe Delete "SQLAgent$SQLEXPRESS"
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
    }
    elseif($RemoveSQL -eq "Keep SQL"){
        net stop 'MSSQL$SQLEXPRESS'
        net start 'MSSQL$SQLEXPRESS' /m
        sqlcmd -S localhost\SQLEXPRESS -i C:\windows\temp\sqlcmdquery.sql
        net stop 'MSSQL$SQLEXPRESS'
        net start 'MSSQL$SQLEXPRESS'
        $Query = @"
drop database datastore
go
exit
"@
        $Query > C:\windows\temp\sqlcmdquery.sql
    }
       
}
    
    
    

#Prepare workstation by turning off firewall,ipv6,setting ipv6,etc.


Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name AutoAdminLogon -Value "1"
New-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultUserName -Value "$WorkstationUsername"
New-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultPassword -Value '$WorkstationPassword'
Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultUserName -Value "$WorkstationUsername"
Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultPassword -Value '$WorkstationPassword'


Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private -Verbose
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
Get-NetAdapterBinding | Where-Object ComponentID -EQ 'ms_tcpip6' | Disable-NetAdapterBinding -ComponentID 'ms_tcpip6'

Sleep 5


#Install CAL
$AnswerFile = @'
[{D2C63C6D-1FAC-4A7F-A994-F02F056CB853}-DlgOrder]
Count=0
'@

$AnswerFile > C:\bin\McrsCAL144\install.iss
C:\Bin\McrsCAL144\setup.exe /s /f1C:\bin\McrsCAL144\install.iss

#Click on dropdown
[Clicker]::LeftClickAtPoint(700,460)
sleep .6
#Click on dropdown
[Clicker]::LeftClickAtPoint(700,460)
sleep .6
#Click on dropdown
[Clicker]::LeftClickAtPoint(700,460)
sleep .6
#Click on dropdown
[Clicker]::LeftClickAtPoint(700,460)
sleep .6
#Click on dropdown
[Clicker]::LeftClickAtPoint(700,460)
sleep .6
#Click on dropdown
[Clicker]::LeftClickAtPoint(700,460)
sleep .6
#Wait for CAL
Sleep 50
#Click on dropdown
[Clicker]::LeftClickAtPoint(700,440)
sleep .6
#Select Multi Tenant Simphony
[Clicker]::LeftClickAtPoint(700,535)
sleep .6
#Click on OrgPA
[Clicker]::LeftClickAtPoint(600,535)
sleep .6
$wshell.SendKeys('') #ENTER YOUR INFO HERE FOR ORGPA
sleep .6
#Click on Server Name
[Clicker]::LeftClickAtPoint(600,500)
sleep .6
$wshell.SendKeys('') #ENTER YOUR INFO HERE FOR THE SERVER NAME
sleep .6
#Click on Update
[Clicker]::LeftClickAtPoint(700,500)
sleep .6
#Click on next
[Clicker]::LeftClickAtPoint(700,580)
sleep 3


#Click on Usernamebox
[Clicker]::LeftClickAtPoint(700,460)
$wshell.SendKeys($SimphonyUsername)
sleep .6
#Click on Password
[Clicker]::LeftClickAtPoint(700,520)
$wshell.SendKeys($SimphonyPassword)
sleep .6
#Click on Server
[Clicker]::LeftClickAtPoint(700,580)
$wshell.SendKeys('') #ENTER YOUR INFO HERE FOR THE SERVER
sleep .6
#Click on Next
[Clicker]::LeftClickAtPoint(700,630)
sleep 3

#Click on site search box
$wshell.SendKeys($Site)
sleep .6
[Clicker]::LeftClickAtPoint(790,350)
sleep .6
#Click on site name
[Clicker]::LeftClickAtPoint(700,$SiteNamePosition)
sleep .6
#Click on next
[Clicker]::LeftClickAtPoint(730,780)
sleep 3

#Click on Show Service Hosts
[Clicker]::LeftClickAtPoint(860,450)
sleep .6
#Click on Show KDS
[Clicker]::LeftClickAtPoint(860,465)
sleep .6
#Click on computer name search
[Clicker]::LeftClickAtPoint(600,725)
sleep .6
$wshell.SendKeys($env:COMPUTERNAME)
sleep .6
#click on Find button
[Clicker]::LeftClickAtPoint(770,725)
sleep .6
#Click on computer name
[Clicker]::LeftClickAtPoint(470,510)
sleep .6
#Click on Netmask
[Clicker]::LeftClickAtPoint(600,375)
sleep .6
$wshell.SendKeys('^a')
sleep .6
$wshell.SendKeys('255.255.255.0')
#Click on Gateway
[Clicker]::LeftClickAtPoint(600,395)
sleep .6
$wshell.SendKeys('^a')
sleep .6
$wshell.SendKeys($Gateway)
#Click on Save
[Clicker]::LeftClickAtPoint(770,690)


if($PhysicalWorkstation){c:\windows\temp\QRes.exe /x:1920 /y:1080}