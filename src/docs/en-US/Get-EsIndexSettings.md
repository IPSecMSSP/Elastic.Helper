---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Get-EsIndexSettings

## SYNOPSIS

Get the currently configured Index configuration on the ElasticSearch server for the specified index name

## SYNTAX

```powershell
Get-EsIndexSettings -EsUrl 'http(s)://es-cluster-hostname-or-ip:9200' -IndexName 'IndexName' [-EsCred PSCredentialObject]
```

## DESCRIPTION

Get the configuration of the specified Index from the nomiated ElasticSearch server.

Optionally supports Authentication.

## EXAMPLES

### Example 1

Retrieve status and configuration about an index named MyIndex without authentication

```powershell
PS C:\> $EsIndexSettings = Get-EsIndex -EsUrl http://192.168.1.10:9200 -IndexName 'MyIndex'
```

## PARAMETERS

### EsUrl

Base URL for your ElasticSearch server/cluster.

### IndexName

Name of ElasticSearch Index to get current information and configuration of.

### EsCreds

PSCredential object containing username and password to access ElasticSearch

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (<http://go.microsoft.com/fwlink/?LinkID=113216>).

## INPUTS

### None

## OUTPUTS

### Information about the specified index on ElasticSearch Cluster

## NOTES

## RELATED LINKS

[Elastic.Helper on GitHub](https://github.com/jberkers42/Elastic.Helper)
