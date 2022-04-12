# Get Index Definition from config
<#
.SYNOPSIS
  Get the definition from the named index from the supplied configuration object
.DESCRIPTION
  Provide the desired definition from the configuration file for the specified index
.PARAMETER EsConfig
  PSObject containing the read in configuration
.PARAMETER IndexName
  Name of ElasticSearch Index to return definition for
#>
function Get-EsIndexDefinition {
  param (
    [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$true)] $IndexName
  )

  foreach ($Index in $EsConfig.Indices) {
    if ($IndexName -match $Index.name) {
      return $Index
    }
  }
}
