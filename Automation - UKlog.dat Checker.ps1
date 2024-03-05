#Checks to see if UKlog.dat is larger than 1KB. If it is, an alert is triggered. This alert will trigger an automated remediation and replace UKlog.dat with a 1KB read-only file.

Import-Module $env:SyncroModule


if( (get-item C:\Uklog.dat).Length -gt 100 ){
    $Hostname = hostname
    Rmm-Alert -Category 'Diskspace' -Body 'C:\UKlog.dat is consuming a large amount of diskspace. Deploying Automated Remediation...'
}