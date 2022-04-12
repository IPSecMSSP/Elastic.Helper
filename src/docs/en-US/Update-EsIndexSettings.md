---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Update-EsIndexSettings

## SYNOPSIS

Update the settings for the specified index with the provided definition.

## SYNTAX

```powershell
Update-EsIndexSettings -EsUrl 'http(s)://es-cluster-hostname-or-ip:9200' -Index 'MyIndex' -IndexDefinition $IndexDef [-EsCred PSCredentialObject]
```

## DESCRIPTION

Use the supplied index definition to update the existing settings of the specified index.

If additional settings are present on the ElasticSearch index, the new settings will merge with and override existing settings.  Other settings will remain unchanged.

This allows you to update just the 'number_of_replicas' setting without affecting any other settings.

Optionally supports Authentication.

## EXAMPLES

### Example 1

Update the index named MyIndex without authentication, setting replicas to 0

```powershell
PS C:\> $IndexDef = @{'index' = @{ 'number_of_replicas' = '0'} }
PS C:\> $EnrichPol = Update-EsEnrichmentPolicy -EsUrl http://192.168.1.10:9200 -IndexName 'MyIndex' -IndexDefinition $IndexDef
```

## PARAMETERS

### EsUrl

Base URL for your ElasticSearch server/cluster.

### IndexName

Name of ElasticSearch Index to update current configuration of.

### IndexDefinition

PSCustomObject defining the desired state of the index configuration

### EsCreds

PSCredential object containing username and password to access ElasticSearch

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### None

## OUTPUTS

### Status of operation

## NOTES

## RELATED LINKS

[Elastic.Helper on GitHub](https://github.com/jberkers42/Elastic.Helper)
