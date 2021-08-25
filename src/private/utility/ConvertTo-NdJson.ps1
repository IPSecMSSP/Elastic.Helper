# Convert to Newline Delimited JSON
function ConvertTo-NdJson {
  <#
  .SYNOPSIS
    Convert JSON/PSObject to Newline Delimited JSON (NDJSON) for bulk imports to ES
  .DESCRIPTION
    This function is intended to reformat a normal JSON array as a series of NDJSON lines.  Will also work in a Pipeline
  .PARAMETER Input
    Input Array of PSObject
  #>

  [cmdletbinding()]
  param (
      # Input Data as PSObject to be converted to Newline Delimited JSON Entries
      [parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
      $Input
  )

  Process {
    $Results = @()

    foreach ($item in $Input) {

      $Results += $item | ConvertTo-Json -Compress -Depth 8

    }

    Write-Output $Results
  }
}
