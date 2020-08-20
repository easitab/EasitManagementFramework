function Get-EMFConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $ConfigurationFileName = 'config.xml',

        [Parameter()]
        [string] $Path = "$Home\EMF\$ConfigurationFileName",

        [Parameter(Mandatory)]
        [string] $ConfigurationName
    )
    
    begin {
        Write-Verbose "$($MyInvocation.MyCommand) initialized"
    }
    
    process {
        Write-Verbose "Retrieving configuration data"
        try {
            [xml]$configurationFileData = Get-Content $Path -ErrorAction Stop
        } catch {
            Write-Verbose "Unable to retrieve configuration data"
            Write-Error "$_"
            return
        }
        Write-Verbose "Configuration data retrieved"
        if ($configurationFileData.systems.$ConfigurationName) {
            Write-Verbose "Found configuration named $ConfigurationName"
        } else {
            Write-Warning "No configuration found named $ConfigurationName"
            return
        }
        $returnObject = New-Object -TypeName psobject
        $configProperties = $configurationFileData.systems.$ConfigurationName
        foreach ($property in $configProperties.ChildNodes) {
            $returnObject | Add-Member -MemberType NoteProperty -Name "$($property.Name)" -Value "$($property.InnerText)"
        }
        return $returnObject
    }
    
    end {
        Write-Verbose "$($MyInvocation.MyCommand) completed"
    }
}