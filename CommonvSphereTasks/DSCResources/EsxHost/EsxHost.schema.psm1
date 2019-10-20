Configuration EsxHost {
    param (
        [Parameter(Mandatory)]
        [System.String]
        $Name,

        [Parameter(Mandatory)]
        [System.String]
        $Server,

        [System.String]
        $NtpServers,

        [System.String]
        $Syslog_Server
    )

    Import-DscResource -ModuleName VMware.vSphereDSC
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    $Credential = New-Object pscredential('Domain\Domainaccount', ("mysecurepassword" | ConvertTo-SecureString -AsPlainText -Force))

    if ($NtpServers) {
        VMHostNtpSettings "VMHostNtpSettings_$($Name)" {
            Name             = $Name
            Server           = $Server
            Credential       = $Credentials
            NtpServer        = $NtpServers
            NtpServicePolicy = 'automatic'
        }
    }

    VMHostService "VMHostService_$($Name)" {
        Name       = $Name
        Server     = $Server
        Credential = $Credential
        Key        = 'ntpd'
        Policy     = 'On'
        Running    = $true
    }

    if ($Syslog_Server) {
        VMHostSyslog "VMHostSyslog_$($Name)" {
            Name = $Name
            Server = $Server
            Credential = $Credential
            Loghost = $Syslog_Server
            CheckSslCerts = $true
            DefaultRotate = 10
            DefaultRotateSize = 100
            DefaultTimeout = 180
            Logdir = '/scratch/log'
            LogdirUnique = $false
            DropLogRotate = 8
            DropLogSize = 50
            QueueDropMark = 90
        }
    }
}
