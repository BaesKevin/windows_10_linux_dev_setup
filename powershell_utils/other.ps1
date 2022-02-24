# runs commands in an elevated shell, shell closes upon completion: example: sudo { Write-Host 'echo from admin shell'; read-host 'enter to close...'; }
function sudo([ScriptBlock]$ScriptToRunAsAdmin) {
    Start-Process -FilePath powershell.exe -ArgumentList $ScriptToRunAsAdmin -verb RunAs
}

# handy to kill rogue Java webapps
function Kill-Process( [int] $Port ) {
    Write-Host "Killing process on port $port";
    Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess | Stop-Process;
}

