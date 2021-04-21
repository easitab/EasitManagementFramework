function Convert-KeytoolResult {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String[]] $InputString,
        [Parameter()]
        [String] $ListCerts
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        if ($InputString) {
            if (Select-String -Pattern 'java.lang.Exception:' -InputObject $InputString) {
                Write-Verbose "Input is an exception"
                $InputString
            } elseif (Select-String -Pattern '-rfc.*-alias.*-keystore.*-cacerts.*-storepass.*' -InputObject $InputString) {
                Write-Verbose "Input is help section"
                $InputString
            } elseif ($ListCerts -match 'true') {
                Write-Verbose "ListCerts = $ListCerts"
                $returnObject = New-Object -TypeName psobject
                $entryId = 1
                foreach ($string in $InputString) {
                    if ($string.Length -gt 1) {
                        $Matches = $null
                        Write-Verbose "String = $string"
                        if ($string -match 'Keystore|Nyckellager') {
                            Write-Verbose "String matches Keystore|Nyckellager"
                            $string -match '^(.+): (.+)' | Out-Null
                            $propName = $Matches[1]
                            $propName = $propName.TrimStart()
                            $propValue = $Matches[2]
                            $propValue = $propValue.TrimEnd()
                            $propValue = $propValue.TrimStart()
                            Write-Verbose "$propName = $propValue"
                            $returnObject | Add-Member -MemberType Noteproperty -Name "$propName" -Value "$propValue"
                        } elseif ($string -cmatch '(\d+) poster|post|entry|entries') {
                            Write-Verbose "String matches poster|post|entry|entries"
                            $string -match '(\d+) poster|post|entry|entries' | Out-Null
                            $propName = 'NumberOfEntriesInStore'
                            $propValue = $Matches[1]
                            Write-Verbose "$propName = $propValue"
                            $returnObject | Add-Member -MemberType Noteproperty -Name "$propName" -Value "$propValue"
                        } elseif ($string -match '.*, .*, .*,') {
                            Write-Verbose "Split details"
                            $string -match '((.*), (.*), (.*)),' | Out-Null
                            $tempPropValues = $Matches[1]
                            $tempPropValuesArray = $tempPropValues -split ','
                            $returnObject | Add-Member -MemberType Noteproperty -Name "CertificateAlias_$entryId" -Value "$($tempPropValuesArray[0])"
                            foreach ($tempPropValue in $tempPropValuesArray) {
                                Write-Verbose "$tempPropValue"
                            }
                        } elseif ($string -match '.*(\(.*\)): (.*)') {
                            $string -match '.*(\(.*\)): (.*)' | Out-Null
                            $propName = "CertificateFingerprint $($Matches[1])_$entryId"
                            $propValue = $Matches[2]
                            $returnObject | Add-Member -MemberType Noteproperty -Name "$propName" -Value "$propValue"
                            $entryId++
                        }
                    }
                }
                $returnObject
            } else {
                Write-Verbose "Input is valid"
                $returnObject = New-Object -TypeName psobject
                foreach ($string in $InputString) {
                    if ($string.Length -gt 1 -and $string -match '^\s*(.+):{1} (.+)') {
                        if ($string -match '^\d{2}(\d|[A-Z])\d' -or $string -match '^\s+\[' -or $string -match '^\#\d+' -or $string -match 'access' -or $string -match 'PathLen') {
                            Write-Verbose "Not a relevant string, $string"
                        } else {
                            Write-Verbose "String = $string"
                            $string -match '^\s*(.+):{1} (.+)' | Out-Null
                            $propName = $Matches[1]
                            $propName = $propName.TrimStart()
                            $propValue = $Matches[2]
                            $propValue = $propValue.TrimEnd()
                            $propValue = $propValue.TrimStart()
                            Write-Verbose "$propName = $propValue"
                            if ($propName -match '.*alias.*') {
                                Write-Verbose "alias"
                                $propName = 'CertificateAlias'
                                $propValue = $propValue
                            } elseif ($propName -match 'Skapat|Creation') {
                                Write-Verbose "skapat"
                                $propName = 'CreationDate'
                                $propValue = $propValue
                            } elseif ($propName -match 'post|entry') {
                                Write-Verbose "post"
                                $propName = 'EntryType'
                                $propValue = $propValue
                            } elseif ($propName -match '.gare|owner') {
                                Write-Verbose "owner"
                                $propName = 'Owner'
                                $propValue = $propValue
                            } elseif ($propName -match 'utf.{1}rdare|issuer') {
                                Write-Verbose "issuer"
                                $propName = 'Issuer'
                                $propValue = $propValue
                            } elseif ($propName -match 'Serienummer|Serial') {
                                Write-Verbose "Serienummer"
                                $propName = 'SerialNumber'
                                $propValue = $propValue
                            } elseif ($propName -match 'Giltigt|Valid') {
                                Write-Verbose "Giltigt"
                                $propName = 'ValidFrom'
                                $propName2 = 'ValidUntil'
                                $string -match '(?>Giltigt |Valid ).*: (.*),? (?>till|until): (.*)' | Out-Null
                                $propValue = $Matches[1]
                                $propValue = $propValue.TrimEnd(',')
                                $propValue2 = $Matches[2]
                                if (!(${returnObject}.${propName2})) {
                                    $returnObject | Add-Member -MemberType Noteproperty -Name "$propName2" -Value "$propValue2"
                                }
                            } elseif ($propName -match '\w{2,3}\d{1,3}') {
                                Write-Verbose "hashes"
                                $propName = "CertificateFingerprint ($propName)"
                            } elseif ($propName -match 'Signaturalgoritmnamn|Signature') {
                                Write-Verbose "SignatureAlgorithmName"
                                $propName = 'SignatureAlgorithmName'
                            } elseif ($propName -match '(?>Algoritm f|Signature)') {
                                Write-Verbose "Signature"
                                $propName = 'AlgorithmForOpenKey'
                            } else {
                                Write-Verbose "$propName matches nothing"
                            }
                            if (!(${returnObject}.${propName})) {
                                $returnObject | Add-Member -MemberType Noteproperty -Name "$propName" -Value "$propValue"
                            }
                        }
                    } else {
                        Write-Verbose "String ($string) is not relevant"
                    }
                    $Matches = $null
                }
                $returnObject
            }
        }
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}