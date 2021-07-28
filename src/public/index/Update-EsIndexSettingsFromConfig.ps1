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
