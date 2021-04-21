function Remove-CertificateFromEasitTrustStore {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Remove-CertificateFromEasitTrustStore.md")]
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
        [Parameter(Mandatory=$true)]
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
                Write-Verbose "Executing: $Keytool -delete -alias $CertificateAlias -keystore $trustStorePath -storepass $StorePass"
                $result = & "$Keytool" -delete -alias "$CertificateAlias" -keystore "$trustStorePath" -storepass "$StorePass"
            } else {
                throw "No certificate alias provided"
            }
        } else {
            throw "No storepass provided"
        }
        if (!($result)) {
            break
        } else {
            return $result
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}