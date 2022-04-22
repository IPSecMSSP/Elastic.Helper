# Import the Elastic Helper Configuration

function Get-EsHelperConfig {
  <#
  .SYNOPSIS
    Import an Elastic Helper configuration.
  .DESCRIPTION
    Import an Elastic Helper configuration JSON file from a stored location.
  .PARAMETER ConfigName
    BaseName of Configuration. To determine the actual filename, the '.json' extension is appended.
  .PARAMETER Path
    (Optional) Path to configuration directory.

    Defaults to .eshelper in the user's home directory.

    On Windows this will be determined by Group Policy, but defaults to C:\Users\<username>

    On Linux this will be determined by OS configuration, but is usually /home/<username>

    On Mac OS/X this is usually /Users/<username>
  .INPUTS
    System.String -> Configuration Name
  .OUTPUTS
    PSCustomObject (Hash) representing the configuration file contents
  .EXAMPLE
    Load Configuration file 'elasticproject.json' from default folder into the $EsConf variable

    PS C:\> $EsConf = Get-EsHelperConfig -ConfigName elasticproject
  .EXAMPLE
    Load Configuration file 'elasticproject.json' from '/opt/scripts/project/etc'

    PS C:\> $EsConf = Get-EsHelperConfig -ConfigName elasticproject -Path '/opt/scripts/project/etc'
  .LINK
    https://github.com/jberkers42/Elastic.Helper
  #>

  [CmdletBinding()]

  param (
    [string] [Parameter(Mandatory=$true)] $ConfigName,
    [string] [Parameter(Mandatory=$false)] $Path = [io.path]::Combine($HOME,".eshelper")
  )

  # Build the full path to the config file
  $ConfigFileName = "{0}.json" -f $ConfigName
  $ConfigFilePath = [io.path]::Combine($Path, $ConfigFileName)

  Get-Content -Path $ConfigFilePath | ConvertFrom-Json -depth 10
}
