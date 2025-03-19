# Convert to ElasticSearch Bulk Index request
function ConvertTo-EsBulkIndex {
  <#
  .SYNOPSIS
    Convert Array of JDJSON lines to interspersed Index requests followed by data to be indexed
  .DESCRIPTION
    This function is intended to turn a series of NDJSON lines into an ES Bulk Index request.  Will also work in a Pipeline
  .PARAMETER Input
    Input Array of PSObject
  .PARAMETER Index
    Name of index, may be overridden by Pipeline configuration
  .PARAMETER Pipeline
    Name of Ingest Pipeline
  .PARAMETER Operation
    Name of Operation to perform, defaults to index
  #>
  [OutputType([string])]
  [cmdletbinding()]
  param (
    # Input Data as Array of entries to be converted to Newline Delimited JSON Entries with specific base index
    [parameter(Mandatory = $true,
      ValueFromPipeline = $true)]
    [psobject[]]$Input,

    [parameter(Mandatory = $true)]
    [string]$Index,

    [parameter(Mandatory = $true)]
    [string]$Pipeline,

    [parameter(Mandatory = $false)]
    [ValidateSet ('index','create','update','delete')]
    [string]$Operation = 'index'
  )

  Begin {
    $Me = $MyInvocation.MyCommand.Name

    Write-Verbose ('{0}: Entering function' -f $Me)
  }

  Process {
    $Results = @()

    $op = @{
      $operation = @{
        '_index' = $Index
        'pipeline' = $Pipeline
      }
    }

    Write-Verbose ('{0}: Adding operation details' -f $Me)
    $Results += $op | ConvertTo-Json -Compress
    Write-Verbose ('{0}: Adding record' -f $Me)
    $Results += ($Input | ConvertTo-Json -Compress -depth 8) -replace [char] 0x00a0, '-'

    Write-Output $Results

  }
  End {
    # Ensure newline at the end of the request
    Write-Output ''
  }

}
