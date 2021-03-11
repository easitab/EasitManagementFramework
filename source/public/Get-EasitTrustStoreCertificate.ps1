function Get-EasitTrustStoreCertificate {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName='LiteralPath',Mandatory=$true)]
        [string] $LiteralPath,
        [Parameter(ParameterSetName='Path')]
        [string] $Path,
        [Parameter(ParameterSetName='Path',Mandatory=$true)]
        [string] $TrustStoreName,
        [Parameter()]
        [string] $Keytool,
        [Parameter(Mandatory=$true)]
        [Alias('keystorepass','truststorepass')]
        [string] $StorePass,
        [Parameter()]
        [string] $CertificateAlias,
        [Parameter()]
        [string] $EmfHome = "$Home\EMF",
        [Parameter()]
        [string] $EmfConfigurationFileName = 'emfConfig.xml',
        [Parameter()]
        [Alias('system')]
        [string] $EmfConfigurationName = 'Prod'
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
        $emfConfig = Get-EMFConfig -EMFHome $EmfHome -ConfigurationFileName $EmfConfigurationFileName -ConfigurationName $EmfConfigurationName
    }
    
    process {
        if (!($Keytool)) {
            try {
                $Keytool = Get-EasitJavaKeytool -Path $emfConfig.EasitRoot
                Write-Verbose "Keytool = $Keytool"
            } catch {
                throw $_
            }
        }
        if ($Path -and $TrustStoreName) {
            $trustStorePath = Join-Path -Path $Path -ChildPath $TrustStoreName
            if (Test-Path $trustStorePath) {
                Write-Verbose "Using truststore at $trustStorePath"
            } else {
                throw "Unable to find $TrustStoreName in $Path"
            }
        }
        if ($Path -and !($TrustStoreName)) {
            throw "You need to provide a TrustStoreName when specifying Path. Otherwise use LiteralPath."
        }
        if ($LiteralPath) {
            if (Test-Path $LiteralPath) {
                $trustStorePath = $LiteralPath
                Write-Verbose "Using truststore at $trustStorePath"
            } else {
                throw "Unable to find $LiteralPath"
            }
        }
        if ($StorePass) {
            if ($CertificateAlias) {
                Write-Verbose "Executing1: $Keytool -list -v -alias $CertificateAlias -keystore $trustStorePath -storepass $StorePass"
                $result = & "$Keytool" -list -v -alias "$CertificateAlias" -keystore "$trustStorePath" -storepass "$StorePass"
                $listCerts = 'false'
            } else {
                Write-Verbose "Executing2: $Keytool -list -keystore $trustStorePath -storepass $StorePass"
                $result = & "$Keytool" -list -keystore "$trustStorePath" -storepass "$StorePass"
                $listCerts = 'true'
            }
        } else {
            if ($CertificateAlias) {
                Write-Verbose "Executing3: $Keytool -list -v -alias $CertificateAlias -keystore $trustStorePath"
                $result = & "$Keytool" -list -v -alias "$CertificateAlias" -keystore "$trustStorePath"
                $listCerts = 'false'
            } else {
                Write-Verbose "Executing4: $Keytool -list -keystore $trustStorePath"
                $result = & "$Keytool" -list -keystore "$trustStorePath"
                $listCerts = 'true'
            }
        }
        if (!($result)) {
            break
        }
        Write-Verbose "$result"
        Convert-KeytoolResult -InputString $result -ListCerts "$listCerts"
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}