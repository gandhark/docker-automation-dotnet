Param
(
	[parameter(Mandatory = $false)] [string]$Uptime
)
$ErrorActionPreference = "stop"
#$Uptime = "hour"


    $runningContainers = docker ps
    $lineCount = ($runningContainers | Measure-Object -Line).Lines

        if($lineCount -gt 1) {
            ForEach ($line in $($runningContainers -split "`r`n"))
            {
                Write-output $line
                Write-Output ".."
                if($line.IndexOf("CONTAINER ID") -eq 0) {
                    continue
                } else {
                    if($line.IndexOf("$($Uptime)") -ne -1) {
                        $containerID = $line.Split(" ")[0]

                        Write-Output "stopping container: $($containerID)"
                        echo "$(Get-Date), stopping container: $($containerID)" >> C:\AgentTools\run.log

                        $terminateContainer = docker stop $containerID
                    } else {
                        continue
                    }
                }
            }
        }

#echo "running" > C:\AgentTools\run.log