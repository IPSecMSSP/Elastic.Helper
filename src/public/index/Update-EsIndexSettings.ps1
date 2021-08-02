function Update-EsIndexSettings {
  <#
  .SYNOPSIS
      Update the settings for the specified index with the provided definition.
  .DESCRIPTION
      Use the supplied index definition to update the existing settings of the specified index.

      If additional settings are present on the ElasticSearch index, the new settings will merge with and override existing settings.  Other settings will remain unchanged.

      This allows you to update just the 'number_of_replicas' setting without affecting any other settings.

      Optionally supports Authentication.
  .PARAMETER EsUrl
      Base URL for your ElasticSearch server/cluster
  .PARAMETER IndexName
      Name of ElasticSearch Index to update current configuration of.
  .PARAMETER IndexDefinition
      PSCustomObject defining the desired state of the index configuration
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      None
  .OUTPUTS
      Result of operation
  .EXAMPLE
      Update the index named MyIndex without authentication

      PS C:\> $IndexDef = @{'index' = @{ 'number_of_replicas' = '0'} }
      PS C:\> $EnrichPol = Update-EsIndexSettings -EsUrl http://192.168.1.10:9200 -IndexName 'MyIndex' -IndexDefinition $IndexDef
  .LINK
      https://github.com/jberkers42/Elastic-Helper
  #>

    [CmdletBinding(SupportsShouldProcess)]

    param (
        [string] [Parameter(Mandatory=$true)] $ESUrl,
        [string] [Parameter(Mandatory=$true)] $IndexName,
        [string] [Parameter(Mandatory=$true)] $IndexDefinition,
        [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
    )

    $Method = 'PUT'
    $Uri = [io.path]::Combine($ESUrl, $IndexName, "_settings")
    $EsBody = [Elastic.ElasticsearchRequestBody] $IndexDefinition

    if($PSCmdlet.ShouldProcess($Uri)) {
      if ($EsCreds) {
        $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody -User $EsCreds.UserName -Password $EsCreds.Password  -SkipCertificateCheck| ConvertFrom-Json -depth 8
      } else {
        $Result = Invoke-Elasticsearch -Uri $Uri -Method $Method -ContentType 'application/json' -Body $EsBody  -SkipCertificateCheck| ConvertFrom-Json -depth 8
      }
    }

    return $Result.acknowledged

}
