# Define device specific variables
$ServiceHostId = ""
$DeviceName = ""
$WorkstationId = ""
$KeepPreReqFolder = "Keep large installer files (faster)"

# If CAL is installed, do some cleanup
If(Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*CAL Client*"}){

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
    
    SC.exe Stop "MICROS Backup Server"
    SC.exe Stop "MICROS CAL Client"
    SC.exe Stop "MICROS Credit Card Server"
    SC.exe Stop "DbUpdateServer"
    SC.exe Stop "MICROS ILDS Server"
    SC.exe Stop "MICROS Interface Server"
    SC.exe Stop "MICROS KDS Controller"
    SC.exe Stop "srvMDSHTTPService"
    SC.exe Stop "MICROS Print Controller"

    SC.exe Delete "MICROS Backup Server"
    SC.exe Delete "MICROS Credit Card Server"
    SC.exe Delete "DbUpdateServer"
    SC.exe Delete "MICROS ILDS Server"
    SC.exe Delete "MICROS Interface Server"
    SC.exe Delete "MICROS KDS Controller"
    SC.exe Delete "srvMDSHTTPService"
    SC.exe Delete "MICROS Print Controller"
    
    Remove-item c:\Win32Registry.bat -force -ErrorAction SilentlyContinue
    Remove-item c:\dotnetfx35.exe -force -ErrorAction SilentlyContinue
    Remove-item c:\PrereqCheck.exe -force -ErrorAction SilentlyContinue
    Remove-item c:\vcredist_x86.exe -force -ErrorAction SilentlyContinue
    Remove-item c:\PrepareForinstallation.bat -force -ErrorAction SilentlyContinue
    Remove-item c:\MicrosRegSettings.reg -force -ErrorAction SilentlyContinue
    Remove-item c:\Kill.exe -force -ErrorAction SilentlyContinue
    Remove-item c:\CALTemp -force -Recurse -ErrorAction SilentlyContinue
    Remove-item c:\Install -force -Recurse -ErrorAction SilentlyContinue
}

# Keep large SQL installer and other stuff that takes a long time to download
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

# Set Autologin
if(get-localuser masteraccount){
    Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name AutoAdminLogon -Value "1"
    New-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultUserName -Value "masteraccount"
    New-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultPassword -Value 'CBHSimphony!99'
    Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultUserName -Value "masteraccount"
    Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultPassword -Value 'CBHSimphony!99'
}
else{
    Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name AutoAdminLogon -Value "1"
    New-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultUserName -Value "user"
    New-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultPassword -Value 'user'
    Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultUserName -Value "user"
    Set-ItemProperty –Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' –Name DefaultPassword -Value 'user'

}

# Set network profile to private, enable firewall network discovery rules, turn off the firewall, disable UAC, disable ipv6
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private -Verbose
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0
Get-NetAdapterBinding | Where-Object ComponentID -EQ 'ms_tcpip6' | Disable-NetAdapterBinding -ComponentID 'ms_tcpip6'

Start-Sleep 5

# Define registry path and keys
$regPaths = @(
    "HKLM:\SOFTWARE\WOW6432Node\Micros\CAL"#,
    #"HKLM:\SOFTWARE\Micros\CAL"
)

$regValues = @{
    "HwConfigured" = 1
    "SHIDSilent" = $ServiceHostId
    "TimeSet" = 1
}
$subKeys = @{
    "Config" = @{
        "DeviceId" = $DeviceName
        "PersistentStore" = "C:\Windows\SysWOW64"
        "ActiveHost" = "mtu01-ohsim-prod.hospitality."
        "ActiveHostIpAddress" = "https://mtu01-ohsim-prod.hospitality.oracleindustry.com:443/EGateway/EGateway.asmx"
        "AutoStartApp" = ""
        "ProductType" = $WorkstationId
        "ServiceHostId" = $ServiceHostId
        "POSType" = 102
        "HostPort" = 7300
        "PingTime" = 528000
        "PingOn" = 0
        "HostDiscoveryPort" = 7301
        "HostDiscoveryPort2" = 7302
        "SocketPersistence" = 20
        "CALEnabled" = 1
        "POSFlags" = 2
        "AutoStartAppOld" = ""
        "WSId" = $WorkstationId
    }
}

foreach ($regPath in $regPaths) {
    # Check if Micros key exists, if not create it
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -ItemType Directory
    }

    # Set registry key values
    foreach ($entry in $regValues.GetEnumerator()) {
        if ($entry.Key -in ("HwConfigured", "TimeSet")) {
            Set-ItemProperty -Path $regPath -Name $entry.Name -Value $entry.Value -Type DWORD
        } else {
            Set-ItemProperty -Path $regPath -Name $entry.Name -Value $entry.Value
        }
    }

    # Set subkeys and their values
    foreach ($subKey in $subKeys.GetEnumerator()) {
        $subKeyPath = Join-Path $regPath $subKey.Name

        # Check if subkey exists, if not create it
        if (-not (Test-Path $subKeyPath)) {
            New-Item -Path $subKeyPath -ItemType Directory
        }

        foreach ($entry in $subKey.Value.GetEnumerator()) {
            if ($entry.Key -in ("POSType", "HostPort", "PingTime", "PingOn", "HostDiscoveryPort", "HostDiscoveryPort2", "SocketPersistence", "CALEnabled", "POSFlags", "WSId")) {
                Set-ItemProperty -Path $subKeyPath -Name $entry.Name -Value $entry.Value -Type DWORD
            } else {
                Set-ItemProperty -Path $subKeyPath -Name $entry.Name -Value $entry.Value
            }
        }
    }
}


SC.exe Stop "MICROS CAL Client"
SC.exe Start "MICROS CAL Client"