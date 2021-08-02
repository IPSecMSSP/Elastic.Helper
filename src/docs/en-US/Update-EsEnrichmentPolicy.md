---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Update-EsEnrichmentPolicy

## SYNOPSIS

Get the currently configured Enrichment Policy configuration on the ElasticSearch server for the specified policy name

## SYNTAX

```powershell
Update-EsEnrichmentPolicy -EsUrl 'http(s)://es-cluster-hostname-or-ip:9200' -Policy 'PolicyName' -PolicyDefinition $PolicyDef [-EsCred PSCredentialObject]
```

## DESCRIPTION

Get the configuration of the specified Enrichment Policy from the nomiated ElasticSearch server.

Optionally supports Authentication.

## EXAMPLES

### Example 1

Update the Enrichment Policy named **MyEnrichmentPolicy** to add the **name** and **description** fields when the **id** field in **MyIndex** matches the field specified in the pipeline using it.

```powershell
$PolicyDef = @{}
$PolicyDef.Add ('match', @{})
$PolicyDef.match.Add('indices','MyIndex')
$PolicyDef.match.Add('match_field','id')
$PolicyDef.match.Add('enrich_fields',('name','description'))
PS C:\> $EnrichPol = Update-EsEnrichmentPolicy -EsUrl http://192.168.1.10:9200 -Policy 'MyEnrichmentPolicy' -PolicyDefinition $PolicyDef
```

## PARAMETERS

### EsUrl

Base URL for your ElasticSearch server/cluster.

### Policy

Name of Enrichment Policy to update definition for.

### PolicyDefinition

Definition of Enrichment Policy to apply.

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
