#Checks the KDS Controller for errors. Deploys automated remediation to restart the service.

Import-Module $env:SyncroModule

[String] $KDSLog = (Get-content C:\Micros\KDS\etc\KdsController.log -raw)

Get-content C:\Micros\KDS\etc\KdsController.log | select -Last 50 > C:\windows\temp\KDSController.log
$Logsforalert = (Get-Content C:\windows\temp\KDSController.log -raw)

$Body = "
KDS Controller log contained errors. This is the last 50 lines from the KDSController log:

$Logsforalert
Deploying Automated Remediation...
"


if($KDSLog -like "*KDSC 1 POS server has no clients*"){
    $Hostname = hostname
    #Rmm-Alert -Category 'KDS Service' -Body $Body
}
