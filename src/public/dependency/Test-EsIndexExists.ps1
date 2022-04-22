# Test Index dependencies
function Test-EsIndexExists {
  <#
  .SYNOPSIS
    Test if the Index exists.
  .DESCRIPTION
    Using the provided configuration definition, determine if the index exists in ElasticSearch.

    Will check all defined indices unless one is specified.

    Checks ElasticSearch to confirm that the index exists.
  .PARAMETER EsConfig
    ElasticHelper configuration loaded using Get-EsHelperConfig.
  .PARAMETER IndexName
    (Optional) Name of Index to check for existence.

    If not specified, checks all defined Indices.
  .PARAMETER EsCreds
    PSCredential object containing username and password to access ElasticSearch
  .INPUTS
    PSCustomObject -> Defined ElasticHelper Configuration
  .OUTPUTS
    $true if it exists, $false if not
  .EXAMPLE
    Test all defined Indices for existence

    PS C:\> $Result = Test-EsIndexExists -EsConfig $EsConfig
  .EXAMPLE
    Test the MyIndex Index for Existence

    PS C:\> $Result = Test-EsIndexExists -EsConfig $EsConfig -IndexName 'MyIndex'
  .LINK
    https://github.com/jberkers42/Elastic.Helper
  #>

  [CmdletBinding()]
  [OutputType([boolean])]

  param (
    [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$false)] $IndexName,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  foreach ($Index in $EsConfig.indices) {
     # Check all indices if no index name is specified, otherwise check just the one index
    if ( -not($PSBoundParameters.ContainsKey('IndexName')) -or $Index.name -eq $IndexName ) {
      if ($EsCreds) {
        $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $Index.name -EsCreds $EsCreds
      } else {
        $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $Index.name
      }

      if($EsIndexStatus.Error) {
        if ($EsIndexStatus.status -eq 404) {
          $msg = "Index {0} not found" -f $Index.name
        } else {
          $msg = "Error: {0}" -f $EsIndexStatus.Error
        }
        Write-Error $msg
        Write-Output $false
      } elseif ($EsIndexStatus.{$Index.name}) {
        Write-Output $true
      }

    }
  }
}
