# Define common module info variables.
$ModuleName = "Elastic.Helper"
$ModuleManifestName = "$ModuleName.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

# Remove module if already loaded, then import.
Get-Module $ModuleName | Remove-Module
Import-Module $ModuleManifestPath -Force -ErrorAction Stop

# Below here put any custom elements that always need to be present
# This might include "Fake Credentials", paths, URLs, etc that need to be passed as parameters in tests.

$TestAccount = 'Account'
$TestSecurePassword = ConvertTo-SecureString '54006500730074002000500061007300730077006f0072006400'
[pscredential]$EsCred = New-Object System.Management.Automation.PSCredential ($TestAccount, $TestSecurePassword)
$TestUri = 'https://127.0.0.1:9200'

Write-Information "Using $($EsCred.UserName) for testing against $TestUri"

