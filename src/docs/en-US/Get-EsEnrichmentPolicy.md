---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Get-EsEnrichmentPolicy

## SYNOPSIS

Get the currently configured Enrichment Policy configuration on the ElasticSearch server for the specified policy name

## SYNTAX

```powershell
Get-EsEnrichmentPolicy -EsUrl 'http(s)://es-cluster-hostname-or-ip:9200' -Policy 'PolicyName' [-EsCred PSCredentialObject]
```

## DESCRIPTION

Get the configuration of the specified Enrichment Policy from the nomiated ElasticSearch server.

Optionally supports Authentication.

## EXAMPLES

### Example 1

Retrieve Enrichment Policy named MyEnrichmentPolicy without authentication

```powershell
PS C:\> $EnrichPol = Get-EsEnrichmentPolicy -EsUrl http://192.168.1.10:9200 -Policy 'MyEnrichmentPolicy'
```

## PARAMETERS

### EsUrl

Base URL for your ElasticSearch server/cluster.

### Policy

Name of Enrichment Policy to retrieve current configuration for.

### EsCreds

PSCredential object containing username and password to access ElasticSearch

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### None

## OUTPUTS

### Current Enrichment Policy configuration

## NOTES

## RELATED LINKS

[Elastic.Helper on GitHub](https://github.com/IPSecMSSP/Elastic.Helper)
