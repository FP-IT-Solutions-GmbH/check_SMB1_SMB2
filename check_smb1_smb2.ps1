Import-Module ActiveDirectory

$Servers = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' ` -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address | Sort-Object -Property Operatingsystem | Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address
$SMB1 = New-Object System.Collections.ArrayList
$SMB2 = New-Object System.Collections.ArrayList

foreach ($Server in $Servers)
{

    if (!(Test-Connection -ComputerName $Server.Name -BufferSize 16 -Count 1 -ea 0 -quiet))
    {
        write-host "cannot reach " $Server.Name -f red
    }
    else
    {
        $Serverinfo = Get-SMBServerConfiguration -CimSession $Server.Name -WarningAction SilentlyContinue 
        If($Serverinfo.EnableSMB1Protocol)
            {
                $SMB1.Add($Serverinfo.PSComputerName)
            }

        $Serverinfo = Get-SMBServerConfiguration -CimSession $Server.Name -WarningAction SilentlyContinue 
        If($Serverinfo.EnableSMB2Protocol)
            {
                $SMB2.Add($Serverinfo.PSComputerName)
            }
        
    }
}

Write-Host "Servers with SMB1 enabled"
Write-Host "-------------------------"

Write-Host ($SMB1 -join ',')
Write-Host "-------------------------"

Write-Host "Servers with SMB2 enabled"
Write-Host "-------------------------"
Write-Host ($SMB2 -join ',')
Write-Host "-------------------------"