$source = "C:\Windows\Temp\punchhinterface.dll"
$destination = "C:\Micros\Simphony\WebServer\wwwroot\EGateway\Handlers\ExtensionApplications\PunchhInterface\punchhinterface.dll"
$xmlFilePath = "C:\Micros\Simphony\WebServer\wwwroot\EGateway\Handlers\ExtensionApplications\PunchhInterface\PunchhConfig.xml"
$txtFilePath = "C:\Micros\Simphony\WebServer\wwwroot\EGateway\Handlers\ExtensionApplications\PunchhInterface\PunchhSettings.txt"

$xmlContent = @"
<?xml version="1.0" encoding="utf-8"?>
<PunchhConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <LogLevel>6</LogLevel>
  <PrintBarcodes>1</PrintBarcodes>
  <ShortKey>$shortKey</ShortKey>
  <Diagnostics>0</Diagnostics>
  <Header />
  <Trailer1 />
  <Trailer2 />
  <Trailer3 />
  <Trailer4 />
  <Trailer5 />
  <UpdateInterval>60</UpdateInterval>
</PunchhConfiguration>
"@

$txtContent = @"
PunchhDiscountObjectNumber=9001
PunchhIntendedDiscountObjectNumber=9002
PropertyLocationKey[$propertyCode]=$locationKey
"@

# Stop servicehost.exe
taskkill /f /t /im servicehost.exe
Start-Sleep -Seconds 5

# Remove existing destination file
Remove-Item $destination -Force

# Move source file to destination
if (Test-Path $source) {
    Move-Item $source $destination -Force
} else {
    Write-Host "Source file not found."
}

# Write XML content to file
$xmlContent | Out-File -FilePath $xmlFilePath -Force

# Write TXT content to file
$txtContent | Out-File -FilePath $txtFilePath -Force


$folderPath = "C:\micros\simphony\webserver\wwwroot\egateway\handlers\ExtensionApplications\punchhinterface"

# Check if folder exists
if (Test-Path -Path $folderPath) {
    try {
        # Get ACL of the folder
        $acl = Get-Acl -Path $folderPath

        # Define a new access rule granting full control to all users
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

        # Add the rule to the ACL
        $acl.AddAccessRule($rule)

        # Apply the modified ACL to the folder
        Set-Acl -Path $folderPath -AclObject $acl

        Write-Output "Permissions granted successfully."
    } catch {
        Write-Error "Error occurred while granting permissions: $_"
    }
} else {
    Write-Error "Folder not found: $folderPath"
}



if ($reboot -eq "True") {
    # Reboot the system
    Restart-Computer -Force
} else {
    # Run ServiceHost.exe
    Start-Process "C:\Micros\Simphony\WebServer\ServiceHost.exe"
}
