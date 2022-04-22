# Test Index dependencies
function Test-EsIndexDepends {
    <#
    .SYNOPSIS
        Test if the Index's Dependencies are met.
    .DESCRIPTION
        Using the provided configuration definition, determine if it's dependencies are met in ElasticSearch.

        Will check all defined enrichment indices unless one is specified.

        Checks ElasticSearch to confirm that the pipeline, and associated dependencies, configured for the index exists.
    .PARAMETER EsConfig
        ElasticHelper configuration loaded using Get-EsHelperConfig.
    .PARAMETER IndexName
        (Optional) Name of Index to check for unmet dependencies.

        If not specified, checks all defined Indices.
    .PARAMETER EsCreds
        PSCredential object containing username and password to access ElasticSearch
    .INPUTS
        PSCustomObject -> Defined ElasticHelper Configuration
    .OUTPUTS
        Success (1) or Failure (0)
    .EXAMPLE
        Test all defined Indices for Dependencies

        PS C:\> $Result = Test-EsIndexDepends -EsConfig $EsConfig
    .EXAMPLE
        Test the MyIndex Index for Dependencies

        PS C:\> $Result = Test-EsIndexDepends -EsConfig $EsConfig -IndexName 'MyIndex'
    .LINK
        https://github.com/jberkers42/Elastic.Helper
    #>

  [CmdletBinding()]
  [OutputType([Int32])]

  param (
    [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$false)] $IndexName,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  foreach ($Index in $EsConfig.indices) {
    # Check all indices if no index name is specified, otherwise check just the one index
    if ( -not($PSBoundParameters.ContainsKey('IndexName')) -or $Index.name -eq $IndexName ) {
        if ($Index.pipeline) {
            $PipelineDepends = Test-EsPipelineDepends -EsConfig $EsConfig -PipelineName $Index.pipeline
            if ($null -eq $PipelineDepends) {
                # Dependencies matched
                if ($EsCreds) {
                  $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $Index.name -EsCreds $EsCreds
                } else {
                  $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $Index.name
                }

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
