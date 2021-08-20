function Add-CertificateToEasitTrustStore {
    [CmdletBinding(HelpURI="https://github.com/easitab/EasitManagementFramework/blob/main/docs/v1/Add-CertificateToEasitTrustStore.md")]
    [Alias("ACTET", "AddCert")]
    param (
        [Parameter(ParameterSetName='LiteralPath',Mandatory=$true)]
        [string] $LiteralPath,
        [Parameter(ParameterSetName='Path')]
        [string] $Path,
        [Parameter(ParameterSetName='Path',Mandatory=$true)]
        [string] $TrustStoreName,
        [Parameter(Mandatory=$true)]
        [string] $Certificate,
        [Parameter()]
        [string] $Keytool,
        [Parameter(Mandatory=$true)]
        [Alias('keystorepass','truststorepass')]
        [string] $StorePass,
        [Parameter(Mandatory=$true)]
        [string] $CertificateAlias,
        [Parameter()]
        [switch] $TrustCaCerts,
        [Parameter()]
        [switch] $NoPrompt,
        [Parameter()]
        [string] $EmfHome = "${env:ALLUSERSPROFILE}\EMF",
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
        if (Test-Path -Path $Certificate) {
            Write-Verbose "Will try to import file: $Certificate"
        } else {
            throw "Unable to find certificate $Certificate"
        }
        if ($NoPrompt) {
            if ($TrustCaCerts) {
                Write-Verbose "Executing: $Keytool -importcert -trustcacerts -noprompt -alias $CertificateAlias -file $Certificate -keystore $trustStorePath -storepass $StorePass"
                $result = & "$Keytool" -importcert -trustcacerts -noprompt -alias "$CertificateAlias" -file "$Certificate" -keystore "$trustStorePath" -storepass "$StorePass"
            } else {
                Write-Verbose "Executing: $Keytool -importcert -noprompt -alias $CertificateAlias -file $Certificate -keystore $trustStorePath -storepass $StorePass"
                $result = & "$Keytool" -importcert -noprompt -alias "$CertificateAlias" -file "$Certificate" -keystore "$trustStorePath" -storepass "$StorePass"
            }
        } else {
            if ($TrustCaCerts) {
                Write-Verbose "Executing: $Keytool -importcert -trustcacerts -alias $CertificateAlias -file $Certificate -keystore $trustStorePath -storepass $StorePass"
                $result = & "$Keytool" -importcert -trustcacerts -noprompt -alias "$CertificateAlias" -file "$Certificate" -keystore "$trustStorePath" -storepass "$StorePass"
            } else {
                Write-Verbose "Executing: $Keytool -importcert -alias $CertificateAlias -file $Certificate -keystore $trustStorePath -storepass $StorePass"
                $result = & "$Keytool" -importcert -noprompt -alias "$CertificateAlias" -file "$Certificate" -keystore "$trustStorePath" -storepass "$StorePass"
            }
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