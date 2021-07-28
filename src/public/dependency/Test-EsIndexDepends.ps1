# Test Index dependencies
function Test-EsIndexDepends {

  [CmdletBinding()]

  param (
      [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
      [string] [Parameter(Mandatory=$false)] $IndexName
  )

  foreach ($Index in $EsConfig.indices) {
      # Check all indices if no index name is specified, otherwise check just the one index
      if ( -not($PSBoundParameters.ContainsKey('IndexName')) -or $Index.name -eq $IndexName ) {
          if ($Index.pipeline) {
              $PipelineDepends = Test-EsPipelineDepends -EsConfig $EsConfig -PipelineName $Index.pipeline
              if ($null -eq $PipelineDepends) {
                  # Dependencies matched
                  $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $Index.name

                  if($EsIndexStatus.Error) {
                      if ($EsIndexStatus.status -eq 404) {
                          $msg = "Unmet Dependency: Index {0} not found" -f $Index.name
                      } else {
                          $msg = "Error: {0}" -f $EsIndexStatus.Error
                      }
                      Write-Output $msg
                  } elseif ($EsIndexStatus.{$Index.name}) {
                      return 1
                  }

              }
          }
      }
  }
}
