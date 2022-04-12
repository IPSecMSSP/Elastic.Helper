function Update-EsIndexSettingsFromConfig {
  <#
  .SYNOPSIS
      Update the ElasticSearch index settings with values from the config file
  .DESCRIPTION
      Use the supplied configuration object to update the ElasticSearch running environment.

      This will recursively identify required objects to create, such as Pipeline, Enrichment Policy, etc

      Optionally supports Authentication.
  .PARAMETER EsConfig
      PSCustomObject containing configuration data loaded with Get-EsHelperConfig
  .PARAMETER IndexName
      Name of ElasticSearch Index to update current configuration of.
  .PARAMETER EsCreds
      PSCredential object containing username and password to access ElasticSearch
  .INPUTS
      None
  .OUTPUTS
      Result of operation
  .EXAMPLE
      Update the index named MyIndex without authentication

      PS C:\> $EsConf = Get-EsHelperConfig -ConfigName 'esproject'
      PS C:\> $result = Update-EsIndexSettingsFromConfig -EsConf $EsConf -IndexName 'MyIndex'
  .LINK
      https://github.com/jberkers42/Elastic.Helper
  #>

    [CmdletBinding(SupportsShouldProcess)]

    param (
        [PSCustomObject] [Parameter(Mandatory=$true)] $EsConfig,
        [string] [Parameter(Mandatory=$true)] $IndexName,
        [PSCustomObject] [Parameter(Mandatory=$false)] $EsCreds
    )

    foreach ($Index in $EsConfig.Indices) {
        if ($IndexName -match $Index.name) {
            If($PSCmdlet.ShouldProcess($IndexName)) {
              If ($EsCreds){
                Update-EsIndexSettings -ESUrl $EsConfig.eshome -IndexName $IndexName -IndexDefinition ($Index.settings | ConvertTo-Json -Depth 8) -EsCreds $EsCreds
              } else {
                Update-EsIndexSettings -ESUrl $EsConfig.eshome -IndexName $IndexName -IndexDefinition ($Index.settings | ConvertTo-Json -Depth 8)
              }
            }
        }
    }

}
