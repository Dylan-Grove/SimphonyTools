# Define device specific variables
$ServiceHostId = "43812"
$DeviceName = "P34TB19"
$WorkstationId = "38951"


# Define registry path and keys
$regPath = "HKLM:\SOFTWARE\WOW6432Node\Micros"
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

# Check if Micros key exists, if not create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -ItemType Directory | Out-Null
}

# Set registry key values
foreach ($entry in $regValues.GetEnumerator()) {
    Set-ItemProperty -Path $regPath -Name $entry.Key -Value $entry.Value -ErrorAction SilentlyContinue
}

# Set subkeys and their values
foreach ($subKey in $subKeys.GetEnumerator()) {
    $subKeyPath = Join-Path $regPath $subKey.Key

    # Check if subkey exists, if not create it
    if (-not (Test-Path $subKeyPath)) {
        New-Item -Path $subKeyPath -ItemType Directory | Out-Null
    }

    foreach ($entry in $subKey.Value.GetEnumerator()) {
        Set-ItemProperty -Path $subKeyPath -Name $entry.Key -Value $entry.Value -ErrorAction SilentlyContinue
    }
}
Set-ItemProperty -Path HKLM:\SOFTWARE\WOW6432Node\Micros\Config -name "WSId" -value 38951