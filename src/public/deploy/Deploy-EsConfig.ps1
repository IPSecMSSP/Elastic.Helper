# Deploy ElasticSearch Configuration
# But only for resources that do not have dependencies, or where these dependencies are met
function Deploy-EsConfig {

    [CmdletBinding()]

    param(
        [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
        [string] [Parameter(Mandatory=$false)] $ResourceType,
        [string] [Parameter(Mandatory=$false)] $ResourceName
    )

    if ($PSBoundParameters.ContainsKey('ResourceType')) {
        if($PSBoundParameters.ContainsKey('ResourceName')) {
            # Process just the single Resource
        } else {
            # Can't have resource Type without Resource name
            Write-Error "Both ResourceType and ResourceName need to be specified"
        }
    } else {
        # In order, we need to do:
        # * Pipeline
        # * Index
        # * Enrichment Policy

        # Pipelines
        foreach ($Pipeline in $EsConfig._ingest.pipelines) {
            # Check dependencies
            $PipelineStatus = Test-EsPipelineDepends -EsConfig $EsConfig -PipelineName $Pipeline.name
            if ($null -eq $PipelineStatus) {
                # Dependency check passed
                $msg = "Deploying Pipeline: {0}" -f $PipeLine.name
                Write-Output $msg
                $result = Update-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline.name -PipelineDefinition ($PipeLine.definition | ConvertTo-Json -Depth 8)
                if ($result) {
                    $msg = "Pipeline Deployed: {0}" -f $PipeLine.name
                } else {
                    $msg = "Pipeline Deployment Failed: {0} - {1}" -f $PipeLine.name, $result
                }
                Write-Output $msg
            } else {
                # Dependency check failed
                $msg = "Pipeline Deployment Skipped: {0} - Dependencies not met.`n  {1}" -f $PipeLine.name, $PipelineStatus
                Write-Output $msg
            }
        }

        # Indices
        # We don't actually deploy indices, these are written by the data insert process

        # Enrichment Policies
        foreach ($Policy in $EsConfig._enrich.policies) {
            # Check Dependencies
            $PolicyStatus = Test-EsEnrichPolicyDepends -EsConfig $EsConfig -PolicyName $Policy.name
            if ($null -eq $PolicyStatus) {
                # Dependency Check Passed
                $msg = "Deploying Enrichment Policy: {0}" -f $Policy.name
                Write-Output $msg
                $result = Update-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name -PolicyDefinition ($Policy.definition | ConvertTo-Json -Depth 8)
                if ($result) {
                    $msg = "Enrichment Policy Deployed: {0}" -f $Policy.name
                } else {
                    $msg = "Enrichment Policy Deployment Failed: {0} - {1}" -f $Policy.name, $result
                }
                Write-Output $msg
            } else {
                # Dependency Check failed
                $msg = "Enrichment Policy Deployment Skipped: {0} - Dependencies not met.`n  {1}" -f $Policy.name, $PolicyStatus
                Write-Output $msg
            }
        }
    }
}
