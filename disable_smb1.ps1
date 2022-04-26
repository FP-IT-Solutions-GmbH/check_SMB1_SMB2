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
        $Serverinfo = Get-SMBServerConfiguration -CimSession $Server.Name 
        If($Serverinfo.EnableSMB1Protocol)
            {
                $SMB1.Add($Serverinfo.PSComputerName)
                Set-SMBServerConfiguration -CimSession $Server.Name -Force -EnableSMB1Protocol $false
            }
        
    }
}

