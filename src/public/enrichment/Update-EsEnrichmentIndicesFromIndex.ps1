# Execute Enrichment Policies tied to a specified index
function Update-EsEnrichmentIndicesFromIndex {
    <#
    .SYNOPSIS
        Test if the Index's Dependencies are met.
    .DESCRIPTION
        Each time the base/source index for an Enrichment Policy has documents added or updated, the system indices used to perform enrichment lookups need to be rebuilt.

        This operation triggers this task on the cluster, based on the index that is used in an enrichment policy.

        Optionally supports Authentication.
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
        Rebuld enrichment indices associated to 'MyIndex'

        PS C:\> $result = Update-EsEnrichmentIndicesFromIndex -EsUrl http://192.168.1.10:9200 -IndexName 'MyIndex'
    .LINK
        https://github.com/jberkers42/Elastic.Helper
    #>

  [CmdletBinding(SupportsShouldProcess)]

  param(
    [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$true)] $IndexName,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
)

# Look through the Enrich Policies in our configuration
foreach ($Policy in $EsConfig._enrich.policies) {
    # Find those that depend on our index
    if ($IndexName -match $Policy.definition.match.indices) {
        if ($PSCmdlet.ShouldProcess($Policy.name)) {
            # Update the Enrichment Index
            $msg = "Updating Enrichment Policy Index - Index: {0}; Policy: {1};" -f $IndexName, $Policy.name
            Write-Debug $msg

            # Sleep briefly to allow Index to quiesce
            Start-Sleep -Seconds 1
            if ($EsCreds) {
              $result = Update-EsEnrichmentIndices -ESUrl $EsConfig.eshome -Policy $Policy.name -EsCreds $EsCreds
            } else {
              $result = Update-EsEnrichmentIndices -ESUrl $EsConfig.eshome -Policy $Policy.name
            }
        }
        Write-Debug $result
    }
}
}
