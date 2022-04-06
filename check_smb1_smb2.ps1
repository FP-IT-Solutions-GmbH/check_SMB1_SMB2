$SearchBase = "INSERTOUHERE"
$SMB1 = New-Object System.Collections.ArrayList
$SMB2 = New-Object System.Collections.ArrayList
Get-ADComputer -Filter '*' -SearchBase $SearchBase | ForEach ($_.Name) {if(!(Test-Connection -Cn $_.Name -BufferSize 16 -Count 1 -ea 0 -quiet)){write-host "cannot reach $_.Name" -f red}else{$Serverinfo = Get-SMBServerConfiguration -CimSession $_.Name;If($Serverinfo.EnableSMB1Protocol){$SMB1.Add($Serverinfo.PSComputerName)}}}
Get-ADComputer -Filter '*' -SearchBase $SearchBase | ForEach ($_.Name) {if(!(Test-Connection -Cn $_.Name -BufferSize 16 -Count 1 -ea 0 -quiet)){write-host "cannot reach $_.Name" -f red}else{$Serverinfo = Get-SMBServerConfiguration -CimSession $_.Name;If($Serverinfo.EnableSMB2Protocol){$SMB2.Add($Serverinfo.PSComputerName)}}}
            
Write-Host "Servers with SMB1 enabled"
Write-Host "-------------------------"

Write-Host ($SMB1 -join ',')
Write-Host "-------------------------"

Write-Host "Servers with SMB2 enabled"
Write-Host "-------------------------"
Write-Host ($SMB2 -join ',')
Write-Host "--------------------------"