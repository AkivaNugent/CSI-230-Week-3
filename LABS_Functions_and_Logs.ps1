<#

#Q1
#Get-Eventlog system -source Microsoft-Windows-winlogon

#Q2

$loginouts = Get-Eventlog system -source Microsoft-Windows-winlogon -After (Get-Date).AddDays(-14)
$loginoutsTable = @()

for($i=0; $i -lt $loginouts.Count; $i++){
    $event = ""
    if($loginouts[$i].InstanceId -eq 7001){$event="Logon"}
    if($loginouts[$i].InstanceId -eq 7002){$event="Logoff"}

    $user = $loginouts[$i].ReplacementStrings[1]

    $loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
                                           "ID" = $loginouts[$i].InstanceId;
                                        "Event" = $event;
                                         "User" = $user;
                                         }
    }

$loginoutsTable 


#Q3
$loginouts = Get-Eventlog system -source Microsoft-Windows-winlogon -After (Get-Date).AddDays(-14)
$loginoutsTable = @()

for($i=0; $i -lt $loginouts.Count; $i++){
    $event = ""
    if($loginouts[$i].InstanceId -eq 7001){$event="Logon"}
    if($loginouts[$i].InstanceId -eq 7002){$event="Logoff"}

    $user = $loginouts[$i].ReplacementStrings[1]
    $identity = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $user
    $user = $identity.Translate([System.Security.Principal.NTAccount])

    $loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
                                           "ID" = $loginouts[$i].InstanceId;
                                        "Event" = $event;
                                         "User" = $user;
                                         }
    }

$loginoutsTable
#>

#Q4
function logonlogoffRecords($daysback){
    $loginouts = Get-Eventlog system -source Microsoft-Windows-winlogon -After (Get-Date).AddDays("-" + $daysback)
    $loginoutsTable = @()

    for($i=0; $i -lt $loginouts.Count; $i++){
        $event = ""
        if($loginouts[$i].InstanceId -eq 7001){$event="Logon"}
        if($loginouts[$i].InstanceId -eq 7002){$event="Logoff"}

        $user = $loginouts[$i].ReplacementStrings[1]
        $identity = New-Object -TypeName System.Security.Principal.SecurityIdentifier -ArgumentList $user
        $user = $identity.Translate([System.Security.Principal.NTAccount])

        $loginoutsTable += [pscustomobject]@{"Time" = $loginouts[$i].TimeGenerated;
                                               "ID" = $loginouts[$i].InstanceId;
                                            "Event" = $event;
                                             "User" = $user;
                                             }
        }

    $loginoutsTable
}


#Q5
function poweronRecords($daysback){
    $startTime = (Get-Date).AddDays(-$daysback)

    $poweron = Get-WinEvent -FilterHashtable @{
        LogName = 'System'; 
        Id = 6005; 
        StartTime = $startTime
    }
    $poweroff = Get-WinEvent -FilterHashtable @{
        LogName = 'System'; 
        Id = 6006; 
        StartTime = $startTime
    }
    $poweronoffTable = @()

    for($i = 0; $i -lt $poweron.Count; $i++) {
        $poweronoffTable += [pscustomobject]@{
            "Time"  = $poweron[$i].TimeCreated
            "ID"    = $poweron[$i].Id
            "Event" = "computer turned on"
            "User"  = "System"
        }
    }

    for($i = 0; $i -lt $poweroff.Count; $i++) {
        $poweronoffTable += [pscustomobject]@{
            "Time"  = $poweroff[$i].TimeCreated
            "ID"    = $poweroff[$i].Id
            "Event" = "computer turned off"
            "User"  = "System"
        }
    }
    $poweronoffTable

}



