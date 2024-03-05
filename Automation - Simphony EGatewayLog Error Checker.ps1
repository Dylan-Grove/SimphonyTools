#Once a day, this log will check for errors in all workstations EGatewayLog for errors. Then it will create alerts depending on what error was present.
Import-Module $env:SyncroModule

$logFilePath = "C:\Micros\Simphony\WebServer\wwwroot\EGateway\EGatewayLog\Log_${Env:COMPUTERNAME}.txt"


# Check if the log file exists
if (Test-Path $logFilePath) {
    # Read the contents of the log file
    $logContents = Get-Content $logFilePath

    # Check if the log contents contain the search string
    if ($logContents -match "ERC_SEC_NOT_AUTHORIZED") {
        Rmm-Alert -Category 'Oracle Authentication Error'  -Body "${Env:COMPUTERNAME} is not authenticated with oracle. Please remotely connect and authenticate it."
    }
}
