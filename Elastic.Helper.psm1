# Helper Module for implementing FreshService data into Elastic
#
# This module's role is to provide a number of Helper Functions that are used to check/define pipelines, rebuild lookup indices, etc

# Region Definitions

# Endregion Definitions

# Region Functions

# Import the Elastic Helper Configuration

function Get-EsHelperConfig {
    param (
        [string] [Parameter(Mandatory=$true)] $ConfigName,
        [string] [Parameter(Mandatory=$false)] $Path = [io.path]::Combine($HOME,".eshelper")
    )

        # Build the full path to the config file
        $ConfigFileName = "{0}.json" -f $ConfigName
        $ConfigFilePath = [io.path]::Combine($Path, $ConfigFileName)

        Get-Content -Path $ConfigFilePath | ConvertFrom-Json -depth 10
}

# Get the current pipeline definition
function Get-EsPipeline {
    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $Pipeline
    )

    $Method = 'GET'
    $Uri = [io.path]::Combine($ESUrl, "_ingest/pipeline/", $Pipeline)

    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json'
}

# Update the pipeline definition with a new one
function Update-EsPipeline {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $Pipeline,
        [Parameter(Mandatory=$true)] $PipelineDefinition
    )

    $Method = 'PUT'
    $Uri = [io.path]::Combine($ESUrl, "_ingest/pipeline/", $Pipeline)
    $EsBody = [Elastic.ElasticsearchRequestBody] $PipelineDefinition

    if($PSCmdlet.ShouldProcess($Uri)) {
        $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody | ConvertFrom-Json -depth 8
    }

    return $Result.acknowledged
}

# Get the current enrichment policy definition
function Get-EsEnrichmentPolicy {
    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $Policy
    )

    $Method = 'GET'
    $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy)

    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json'

}

# Update the Enrichment Policy
function Update-EsEnrichmentPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $Policy,
        [Parameter(Mandatory=$true)] $PolicyDefinition
    )

    $Method = 'PUT'
    $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy)
    $EsBody = [Elastic.ElasticsearchRequestBody] $PolicyDefinition

    if($PSCmdlet.ShouldProcess($Uri)) {
        $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody | ConvertFrom-Json -depth 8
    }

    return $Result.acknowledged
}

# Rebuild Enrichment Indices
function Update-EsEnrichmentIndices {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $Policy
    )

    $Method = 'POST'
    $Uri = [io.path]::Combine($ESUrl, "_enrich/policy/", $Policy, "_execute")

    if($PSCmdlet.ShouldProcess($Uri)) {
        $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' | ConvertFrom-Json -depth 8
    }

    return $Result
}

# Get index info

function Get-EsIndex {
    param(
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $EsIndex
    )

    $Method = 'GET'
    $Uri = [io.path]::Combine($ESUrl, $EsIndex, "_settings")

    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' | ConvertFrom-Json -Depth 8
}

# Test for Enrich Policy Dependencies
function Test-EsEnrichPolicyDepends {
    param(
        [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
        [string] [Parameter(Mandatory=$false)] $PolicyName
    )

    # Find the Enrichment Policy in the config

    foreach ($Policy in $EsConfig._enrich.policies) {
        # Check all policies if none specified, otherwise check just the one
        if(-not ($PSBoundParameters.ContainsKey('PolicyName')) -or $Policy.name -eq $PolicyName) {
            $EsIndex = $Policy.definition.match.indices
            $EsIndexStatus = Get-EsIndex -ESUrl $EsConfig.eshome -EsIndex $EsIndex

            if($EsIndexStatus.Error) {
                if ($EsIndexStatus.status -eq 404) {
                    $msg = "Unmet Dependency: Index {0} not found" -f $EsIndex
                } else {
                    $msg = "Error: {0}" -f $esIndexStatus.Error
                }
                Write-Output $msg
            } elseif ($EsIndexStatus.{$EsIndex}) {
                $RunningPolicy = Get-EsEnrichmentPolicy -ESUrl $EsConfig.eshome -Policy $Policy.name
                if ($RunningPolicy.policies.Count -eq 0) {
                    $msg = "Unmet Dependency: Enrichment Policy {0} not loaded" -f $Policy.name
                } else {
                    return 1
                }
            }
        }
    }
}

# Test Pipeline Dependencies
function Test-EsPipelineDepends {
    param(
        [PsCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
        [string] [Parameter(Mandatory=$false)] $PipelineName
    )

    # Find the pipeline in the config
    foreach($Pipeline in $EsConfig._ingest.pipelines) {
        # Check all pipelines if none specified, otherwise check just the one
        if (-not ($PSBoundParameters.ContainsKey('PipelineName')) -or $Pipeline.name -eq $PipelineName) {
            foreach($PipelineProcessor in $Pipeline.definition.processors) {
                if ($PipelineProcessor.enrich) {
                    $EnrichPolicy = $PipelineProcessor.enrich.policy_name
                    $EnrichPolicyDepends = Test-EsEnrichPolicyDepends -EsConfig $EsConfig -PolicyName $EnrichPolicy
                    if ($null -eq $EnrichPolicyDepends){
                        # Dependencies matched
                        $PipelineStatus = Get-EsPipeline -ESUrl $EsConfig.eshome -Pipeline $Pipeline.name | ConvertFrom-Json
                        if($PipelineStatus.($Pipeline.name)) {
                            # Pipeline is there
                        } else {
                            $msg = "Unmet Dependency: Pipeline {0} not loaded" -f $Pipeline.name
                            Write-Output $msg
                        }
                    } else {
                        $msg = "Unmet Dependencies for Pipeline: {0} - " -f $Pipeline.Name
                        $msg += $EnrichPolicyDepends
                        Write-Output $msg
                    }
                }
            }
        }
    }
}

# Test Index dependencies
function Test-EsIndexDepends {
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

# Deploy ElasticSearch Configuration
# But only for resources that do not have dependencies, or where these dependencies are met
function Deploy-EsConfig {
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

# Execute Enrichment Policies tied to a specified index
function Update-EsEnrichmentIndicesFromIndex {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
        [string] [Parameter(Mandatory=$true)] $IndexName
    )

    # Look through the Enrich Policies in our configuraton
    foreach ($Policy in $EsConfig._enrich.policies) {
        # Find those that depend on our index
        if ($IndexName -match $Policy.definition.match.indices) {
            if ($PSCmdlet.ShouldProcess($Policy.name)) {
                # Update the Enrichment Index
                $msg = "Updating Enrichment Policy Index - Index: {0}; Policy: {1};" -f $IndexName, $Policy.name
                Write-Output $msg
                Update-EsEnrichmentIndices -ESUrl $EsConfig.eshome -Policy $Policy.name
            }
        }
    }
}

function Get-EsIndexSettings {
    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $IndexName
    )

    $Method = 'GET'
    $Uri = [io.path]::Combine($ESUrl, $IndexName, "_settings")

    Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json'
}

function Update-EsIndexSettings {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $IndexName,
        [string] [Parameter(Mandatory=$true)] $IndexDefinition
    )

    $Method = 'PUT'
    $Uri = [io.path]::Combine($ESUrl, $IndexName, "_settings")
    $EsBody = [Elastic.ElasticsearchRequestBody] $IndexDefinition

    if($PSCmdlet.ShouldProcess($Uri)) {
        $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody | ConvertFrom-Json -depth 8
    }

    return $Result.acknowledged

}

function Update-EsIndexSettingsFromConfig {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
        [string] [Parameter(Mandatory=$true)] $IndexName
    )

    foreach ($Index in $EsConfig.Indices) {
        if ($IndexName -match $Index.name) {
            If($PSCmdlet.ShouldProcess($IndexName)) {
                Update-EsIndexSettings -ESUrl $EsConfig.eshome -IndexName $IndexName -IndexDefinition ($Index.settings | ConvertTo-Json -Depth 8)
            }
        }
    }

}

# Endregion Functions