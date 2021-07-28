# Import the Elastic Helper Configuration

function Get-EsHelperConfig {
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
