#Sets C:\UKlog.dat to a small size and then sets it to be read-only.
Import-Module $env:SyncroModule


echo "" > c:\Uklog.dat
attrib +r c:\Uklog.dat

$Hostname = hostname

Rmm-Alert -Category 'Diskspace' -Body "UKlog.dat has been cleared and set to read-only."