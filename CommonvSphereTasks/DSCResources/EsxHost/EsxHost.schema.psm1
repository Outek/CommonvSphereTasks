Configuration EsxHost 
{
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
        $SyslogServer,

        [Hashtable]
        $DNSServerConfigs
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

        VMHostService "VMHostService_$($Name)" {
            Name       = $Name
            Server     = $Server
            Credential = $Credential
            Key        = 'ntpd'
            Policy     = 'On'
            Running    = $true
        }
    }

    if ($SyslogServer) {
        VMHostSyslog "VMHostSyslog_$($Name)" {
            Name           = $Name
            Server         = $Server
            Credential     = $Credential
            Loghost        = $SyslogServer
            CheckSslCerts  = $true
            DefaultRotate  = 10
            DefaultSize    = 100
            DefaultTimeout = 180
            Logdir         = '/scratch/log'
            LogdirUnique   = $false
            DropLogRotate  = 8
            DropLogSize    = 50
            QueueDropMark  = 90
        }
    }

    if ($DNSServerConfigs) {
        VMHostDnsSettings "VMHostDnsSettings_$($Name)" {
            Name         = $Name
            Server       = $Server
            Credential   = $Credential
            Dhcp         = $false
            DomainName   = $DNSServerConfigs.DomainName
            HostName     = $Name
            Address      = $DNSServerConfigs.Address
            SearchDomain = $DNSServerConfigs.SearchDomain
        }
    }
}
