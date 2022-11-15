---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Update-EsEnrichmentIndices

## SYNOPSIS

Rebuild all Enrichment indices associated with the specified Enrichment Policy

## SYNTAX

```powershell
Update-EsEnrichmentIndices -EsUrl 'http(s)://es-cluster-hostname-or-ip:9200' -Policy 'PolicyName' [-EsCred PSCredentialObject]
```

## DESCRIPTION

Each time the base/source index for an Enrichment Policy has documents added or updated, the system indices used to perform enrichment lookups need to be rebuilt.

This operation triggers this task on the cluster.

Optionally supports Authentication.

## EXAMPLES

### Example 1

Rebuld enrichment indices associated to 'MyEnrichmentPolicy'

```powershell
PS C:\> $EnrichPol = Update-EsEnrichmentIndices -EsUrl http://192.168.1.10:9200 -Policy 'MyEnrichmentPolicy'
```

## PARAMETERS

### EsUrl

Base URL for your ElasticSearch server/cluster.

### Policy

Name of Enrichment Policy to rebuild enrichment indices for

### EsCreds

PSCredential object containing username and password to access ElasticSearch

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### None

## OUTPUTS

### Result of requested operation

## NOTES

## RELATED LINKS

[Elastic.Helper on GitHub](https://github.com/IPSecMSSP/Elastic.Helper)
