# manage port forwarding rules between Windows and the the default wsl 2 distro (in my case Ubuntu) 
# adding rules requires admin priviles (see sudo function in other.ps1)
# inspired by this https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723

function Add-PortForwardingRules([int32[]]$Ports) {
    Write-Verbose "forwarding ports $Ports"
    for( $i = 0; $i -lt $Ports.length; $i++ ){
        $port = $ports[$i];
        Add-PortForwardingRule($port)
    }  
}

function Add-PortForwardingRule([int32]$Port) {
    $wsl2ip = Get-Wsl2Ip
    Write-Verbose "forwarding: 0.0.0.0:$Port to $($wsl2ip):$Port"
    iex "netsh interface portproxy add v4tov4 listenport=$Port listenaddress='0.0.0.0' connectport=$Port connectaddress=$wsl2ip";
}

function Delete-PortForwardingRules() {
    # parse current port-forwarded ports from the output of List-PortFrwardingRule
    [int32[]]$ports = List-PortForwardingRule | select-string -Pattern '\d{4}' -AllMatches | % {$_.Matches } | % { $_.Value } | Get-Unique
    
    Write-Verbose "clearing ports $ports"
    for( $i = 0; $i -lt $ports.length; $i++ ){
        Delete-PortForwardingRule($ports[$i])
    }
    Write-Verbose 'done clearing old rules'

}

function Delete-PortForwardingRule([int32]$Port) {
    $wsl2ip = Get-Wsl2Ip
    iex "netsh interface portproxy delete v4tov4 listenport=$Port listenaddress=0.0.0.0";
}

function List-PortForwardingRule() {
    return iex "netsh interface portproxy show all";
}

function Get-Wsl2Ip() {
    $remoteport = bash.exe -c "ifconfig eth0 | grep 'inet '"
    $found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

    if( $found ){
        $remoteport = $matches[0];
    } else{
        Write-Host "The Script Exited, the ip address of WSL 2 cannot be found";
        exit;
    }

    return $remoteport;
}
