# Bulk Index logs
# Index some records
function Invoke-EsBulkIndexRequest {
  <#
  .SYNOPSIS
    Bulk Index an array of PSObjects to the specified ElasticSearch instance and index
  .DESCRIPTION
    Takes an array of PSObjects and submits it to the ElasticSearch instance as a bulk index request denoted by the EsConfig object and index name
  .PARAMETER EsConfig
    PSObject containing the read in configuration
  .PARAMETER IndexName
    Name of ElasticSearch Index to return definition for
  .PARAMETER InputArray
    Array of PSObjects to sumbit to the index
  #>
  param (
    [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
    [string] [Parameter(Mandatory=$true)] $IndexName,
    [Parameter(Mandatory=$true)] $InputObject,
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
  )

  Write-Debug "Processing Bulk Index Request..."

  $BulkIndexURI = '{0}/{1}/_bulk' -f $EsConfig.eshome, $IndexName

  Write-Debug " URI: $BulkIndexURI"

  $ndjson = $InputObject | ConvertTo-EsBulkIndex -Index $IndexName -Pipeline (Get-EsIndexDefinition -EsConfig $EsConfig -IndexName $IndexName).pipeline

  if ($EsCreds) {
    Write-Debug " Credentials Supplied"
    $ndjson -join "`n" | Invoke-Elasticsearch -Uri $BulkIndexURI -Method POST -ContentType 'application/x-ndjson' -User $EsCreds.UserName -Password $EsCreds.Password -SkipCertificateCheck
  } else {
    Write-Debug " No Credentials Supplied"
    $ndjson -join "`n" | Invoke-Elasticsearch -Uri $BulkIndexURI -Method POST -ContentType 'application/x-ndjson' -SkipCertificateCheck
  }

  Start-Sleep -Seconds 2

  # After indexing a bunch of records, update the enrichment indices (if any) associated to the index
  Write-Debug " Updating Enrichment Indices"
  if ($EsCreds) {
    Update-EsEnrichmentIndicesFromIndex -EsConfig $EsConfig -IndexName $IndexName -EsCreds $EsCreds
  } else {
    Update-EsEnrichmentIndicesFromIndex -EsConfig $EsConfig -IndexName $IndexName
  }

}
