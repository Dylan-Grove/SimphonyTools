# Define variables for registry values
$SHIDSilent = "43812"
$DeviceId = "P34TB19"
$ProductType = "38951"
$ServiceHostId = "43812"
$WSIdDecimal = 38919

# Convert WSId to DWORD hexadecimal
$WSId = "0x" + $WSIdDecimal.ToString("X8")

# Define registry path
$regPath = "HKLM:\SOFTWARE\WOW6432Node\Micros"

# Check if Micros key exists, if not create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -ItemType Directory | Out-Null
}

# Define registry key values
$regValues = @{
    "CALVersion" = "3.1.4.144"
    "HwConfigured" = 1
    "SHIDSilent" = $SHIDSilent
    "TimeSet" = 1
}

# Set registry key values
foreach ($entry in $regValues.GetEnumerator()) {
    Set-ItemProperty -Path $regPath -Name $entry.Key -Value $entry.Value -ErrorAction SilentlyContinue
}

# Define subkeys and their values
$subKeys = @{
    "Config" = @{
        "DeviceId" = $DeviceId
        "PersistentStore" = "C:\Windows\SysWOW64"
        "ActiveHost" = "mtu01-ohsim-prod.hospitality."
        "ActiveHostIpAddress" = "https://mtu01-ohsim-prod.hospitality.oracleindustry.com:443/EGateway/EGateway.asmx"
        "AutoStartApp" = ""
        "ProductType" = $ProductType
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
        "WSId" = $WSId
    }
    "Scripts\McrsCAL" = @{
        "Version" = 03010490
    }
    "Scripts\McrsHAL" = @{
        "Version" = 03010490
    }
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

Write-Host "Registry keys and values have been created or updated."
