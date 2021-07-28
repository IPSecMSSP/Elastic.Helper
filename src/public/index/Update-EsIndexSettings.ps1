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
