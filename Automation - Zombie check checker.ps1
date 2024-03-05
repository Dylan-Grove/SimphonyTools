#Searches the micros egateway log files for references to zombie checks.
Import-Module $env:SyncroModule


$path = "C:\Micros\Simphony\WebServer\wwwroot\EGateway\EGatewayLog\Log_$env:COMPUTERNAME.txt"
$Search = "is a Local zombie"

$Results = @()
Get-ChildItem $path -File | %{     
     
     if(get-content $_.FullName | where {$_ -like "*$Search*"}){
        $Results += $_.FullName 

     }
     
}


$Body = "
Zombie checks were referenced in the latest EGatway log, which usually indicates a stuck check on the local database of the POS:

$Path

Deploying automated remediation...
"

#If($Results){Rmm-Alert -Category 'Zombie check' -Body $Body}