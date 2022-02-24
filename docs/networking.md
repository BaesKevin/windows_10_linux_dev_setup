# Expose HTTP services on Ubuntu to Windows
 
Calling HTTP endpoints in Ubuntu from Windows using localhost will not work because Ubuntu runs in a special utility HyperV VM with its own network adapter,
i.e. you need to use the IP of the Ubuntu VM instead of localhost.
What I want is that 'localhost' can reach both HTTP services running on Windows or Ubuntu, no matter from which environment I try to reach them.
 
The solution would be to make the WSL network adapter bridged, but this is not possible yet (should be in Win 11)
https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723
 
The workaround is to set up port-forwarding from Windows to Ubuntu. Adding the code below to your profile allows you to run the `PortForwards` function from a non-elevated powershell to forward all traffic on localhost:8000 to `<ubuntuip>:8000`.
NOTE 1: the Ubuntu vm does not have a fixed IP, so it may be necessary to run this again after moving around or something.
NOTE 2: this also means the any service running on `localhost:8000` on the Windows side on port 8000 is no longer reachable, use `Delete-PortForwardingRule 8000` to fix

```
$windows_dev_utils_dir='..\powershell_utils'; # change path
. "$windows_dev_utils_dir\other.ps1"
. "$windows_dev_utils_dir\port_forwarding_to_default_wsl2_distro.ps1"

function PortForwards() {
    $ScriptToRunAsAdmin = {
        [int32[]] $ports = 8000,9000
        
        Delete-PortForwardingRules
        Add-PortForwardingRules $ports;
        
        echo 'current rules';
        List-PortForwardingRule;
        read-host 'any key to close admin prompt...';
    }
    sudo $ScriptToRunAsAdmin
}
```