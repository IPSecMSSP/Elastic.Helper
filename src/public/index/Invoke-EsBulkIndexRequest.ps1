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
    [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds,
    [int] [Parameter(Mandatory=$false)] $ChunkSize = 10000
  )

  Write-Debug "Processing Bulk Index Request..."

  $BulkIndexURI = '{0}/_bulk' -f $EsConfig.eshome, $IndexName

  Write-Debug " URI: $BulkIndexURI"

  # Break the task into chunks
  $Chunks = [System.Collections.ArrayList]::new()
  for ($i = 0; $i -lt $InputObject.Count; $i += $ChunkSize) {
    if (($InputObject.Count - $i) -gt ($ChunkSize -1)) {
      $Chunks.Add($InputObject[$i..($i + ($ChunkSize -1))])
    } else {
      $Chunks.Add($InputObject[$i..($InputObject.Count - 1)])
    }
  }

  foreach ($Chunk in $Chunks) {
    $ndjson = $Chunk | ConvertTo-EsBulkIndex -Index $IndexName -Pipeline (Get-EsIndexDefinition -EsConfig $EsConfig -IndexName $IndexName -Exact).pipeline

    if ($EsCreds) {
      Write-Debug " Credentials Supplied"
      $ndjson -join "`n" | Invoke-Elasticsearch -Uri $BulkIndexURI -Method POST -ContentType 'application/x-ndjson; charset=utf-8' -User $EsCreds.UserName -Password $EsCreds.Password -SkipCertificateCheck
    } else {
      Write-Debug " No Credentials Supplied"
      $ndjson -join "`n" | Invoke-Elasticsearch -Uri $BulkIndexURI -Method POST -ContentType 'application/x-ndjson; charset=utf-8' -SkipCertificateCheck
    }
  }

  # After indexing a bunch of records, update the enrichment indices (if any) associated to the index
  Write-Debug " Updating Enrichment Indices"
  if ($EsCreds) {
    Update-EsEnrichmentIndicesFromIndex -EsConfig $EsConfig -IndexName $IndexName -EsCreds $EsCreds
  } else {
    Update-EsEnrichmentIndicesFromIndex -EsConfig $EsConfig -IndexName $IndexName
  }

}
