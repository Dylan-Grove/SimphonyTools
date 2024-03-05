#Checks to see if there are any errors in the givex log file. Restarts the service if any are detected.

# Import the required module
Import-Module $env:SyncroModule

# Define the path to the text file
$filePath = "C:\Program Files (x86)\MicrosGivex\GIVEX.LOG"

# Define a list of strings to search for
$searchStrings = @(
    'gethostbyname("dc-ca1.givex.com") failed'
)

# Check if the file exists
if (Test-Path -Path $filePath -PathType Leaf) {
    # Read the file content
    $fileContent = Get-Content -Path $filePath -Raw

    # Initialize a variable to track if any of the search strings are found
    $found = $false

    # Iterate through the list of search strings
    foreach ($searchString in $searchStrings) {
        if ($fileContent -like "*$searchString*") {
            Write-Host "String '$searchString' was found in the file."
            $found = $true
        }
    }

    if ($found) {
        Write-Host "Errors detected in the givex log file, resetting service..."
        Restart-Service givexSVC -Force
    }
} 
else {
    Write-Host "The file '$filePath' does not exist."
}
