---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Update-EsIndexSettingsFromConfig

## SYNOPSIS

Update the ElasticSearch index settings with values from the config file.

## SYNTAX

```powershell
Update-EsIndexSettingsFromConfig -EsConf $EsConf -Index 'MyIndex' [-EsCred PSCredentialObject]
```

## DESCRIPTION

Use the supplied configuration object to update the ElasticSearch running environment.

This will recursively identify required objects to create, such as Pipeline, Enrichment Policy, etc

Optionally supports Authentication.

## EXAMPLES

### Example 1

Update the index named MyIndex without authentication from a file named **esproject.json**.

```powershell
PS C:\> $EsConf = Get-EsHelperConfig -ConfigName 'esproject'
PS C:\> $result = Update-EsIndexSettingsFromConfig -EsConf $EsConf -IndexName 'MyIndex'
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

[Elastic.Helper on GitHub](https://github.com/jberkers42/Elastic-Helper)
