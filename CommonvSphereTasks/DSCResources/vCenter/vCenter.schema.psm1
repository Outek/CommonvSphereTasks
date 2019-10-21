Configuration vCenter 
{
    param (
        [Parameter(Mandatory)]
        [System.String]
        $Name,

        [Parameter(Mandatory)]
        [System.String]
        $Server,

        [System.String]
        $Period,

        [System.Int32]
        $Level,

        [System.String]
        $LoggingLevel,

        [System.Boolean]
        $EventMaxAgeEnabled,

        [System.Int32]
        $EventMaxAge,

        [System.Boolean]
        $TaskMaxAgeEnabled,

        [System.Int32]
        $TaskMaxAge,

        [System.String]
        $Motd
    )

    Import-DscResource -ModuleName VMware.vSphereDSC
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    $Credential = New-Object pscredential('Domain\Domainaccount', ("mysecurepassword" | ConvertTo-SecureString -AsPlainText -Force))
        $params = @{
            Server               = $Server
            Credential           = $Credential
        }

        if ($PSBoundParameters.ContainsKey('Period'))
        {
            $params.Period = $Period
        }

        if ($PSBoundParameters.ContainsKey('Level'))
        {
            $params.Level = $Level
        }

        (Get-DscSplattedResource -ResourceName vCenterStatistics -ExecutionName "vCenterStatistics_$($Name)" -Properties $params -NoInvoke).Invoke($params)

        $params = @{
            Server               = $Server
            Credential           = $Credential
        }

        if ($PSBoundParameters.ContainsKey('LoggingLevel'))
        {
            $params.LoggingLevel = $LoggingLevel
        }

        if ($PSBoundParameters.ContainsKey('EventMaxAgeEnabled'))
        {
            $params.EventMaxAgeEnabled = $EventMaxAgeEnabled
        }

        if ($PSBoundParameters.ContainsKey('EventMaxAge'))
        {
            $params.EventMaxAge = $EventMaxAge
        }

        if ($PSBoundParameters.ContainsKey('TaskMaxAgeEnabled'))
        {
            $params.TaskMaxAgeEnabled = $TaskMaxAgeEnabled
        }

        if ($PSBoundParameters.ContainsKey('TaskMaxAge'))
        {
            $params.TaskMaxAge = $TaskMaxAge
        }

        if ($PSBoundParameters.ContainsKey('Motd'))
        {
            $params.Motd = $Motd
        }

        (Get-DscSplattedResource -ResourceName vCenterSettings -ExecutionName "vCenterSettings_$($Name)" -Properties $params -NoInvoke).Invoke($params)
}
