# these functions can come in handy when starting a lot of non-containerized applications concurrently from different powershell tabs, e.g. by scripting with Windows Terminal
function WaitForIt {
    [cmdletbinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('Host')]
            [string]$ComputerName = 'localhost',
        
        [Parameter(
            Position = 1,
            Mandatory=$true
        )]
        [ValidateNotNullOrEmpty()]
            [int]$Port,
            
        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
            [int]$Timeout = 60
    )
    
    begin {
        $to = New-Timespan -Seconds $Timeout
        $sw = [diagnostics.stopwatch]::StartNew()
        $hostandport = "${ComputerName}:${port}"
    }
     
    process {
        Write-Host "Waiting for $hostandport, timeout: ${Timeout} seconds"    

        while( !(Test-NetConnection -ComputerName "$ComputerName" -Port $Port -WarningAction SilentlyContinue | ? { $_.TcpTestSucceeded })) {
            if ($sw.elapsed -gt $to)
            {
                throw "can't connect to port $hostandport"
            }
            Write-Verbose "connecting to $hostandport..., waited $([int]$sw.Elapsed.TotalSeconds) seconds"
        }

        Write-Host "connected to $hostandport" 
    }
}

function WaitForWeb {
    [cmdletbinding()]
    param (
        [Parameter(Position = 0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [string]$URI,
        
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
            [int]$Timeout = 60
        
    )
    
    begin {
        $to = New-Timespan -Seconds $Timeout
        $sw = [diagnostics.stopwatch]::StartNew()
    }
     
    process {
        $connected=$false;

        while(!$connected) {
            try {
                Write-Host "Waiting for $URI, timeout: ${Timeout} seconds"    
                Invoke-WebRequest -URI "$URI";
                $connected = $true;
                sleep -Seconds 1;
            } catch { 
                sleep -Seconds 1;
            }

        }

        Write-Host "connected to $URI" 
    }
}


function WaitForSqs {
    [cmdletbinding()]
    param (
        [Parameter(Position = 0, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [string]$QueueName,
        
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
            [int]$Timeout = 60,

        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('Host')]
            [string]$ComputerName = 'localhost'

    )
    
    begin {
        $to = New-Timespan -Seconds $Timeout
        $sw = [diagnostics.stopwatch]::StartNew()
    }
     
    process {        
        $connected=$false;
        $endpointurl="http://$($ComputerName):4566"
        Write-Host "connecting to $QueueName on host $endpointurl" ;

        while(!$connected) {
            $sqsresponse = aws --endpoint-url $endpointurl sqs list-queues;
            Write-Host $sqsresponse;
            $connected=$sqsresponse -match $QueueName;
            sleep 1;
            Write-Host "connecting to $QueueName" ;
        }

        Write-Host "connected to $QueueName" ;
    }
}
