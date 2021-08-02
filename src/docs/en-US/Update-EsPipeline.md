---
external help file: Elastic.Helper-help.xml
Module Name: Elastic.Helper
schema: 2.0.0
---

# Update-EsPipelineSettings

## SYNOPSIS

Update the settings for the specified Pipeline with the provided definition.

## SYNTAX

```powershell
Update-EsPipelineSettings -EsUrl 'http(s)://es-cluster-hostname-or-ip:9200' -Pipeline 'MyPipeline' -PipelineDefinition $PipelineDef [-EsCred PSCredentialObject]
```

## DESCRIPTION

Use the supplied Pipeline definition to update the existing settings of the specified Pipeline.

If additional settings are present on the ElasticSearch Pipeline, the new settings will merge with and override existing settings.  Other settings will remain unchanged.

This allows you to update just the 'number_of_replicas' setting without affecting any other settings.

Optionally supports Authentication.

## EXAMPLES

### Example 1

Update the Pipeline named MyPipeline without authentication, setting replicas to 0

```powershell
PS C:\> $EsConf = Get-EsHelperConfig -ConfigName 'esproject'
PS C:\> $PipelineDef = $EsConf._ingest.pipelines[0].definition
PS C:\> $EnrichPol = Update-EsEnrichmentPolicy -EsUrl http://192.168.1.10:9200 -Pipeline 'MyPipeline' -PipelineDefinition $PipelineDef
```

## PARAMETERS

### EsUrl

Base URL for your ElasticSearch server/cluster.

### PipelineName

Name of ElasticSearch Pipeline to update current configuration of.

### PipelineDefinition

PSCustomObject defining the desired state of the Pipeline configuration

This is the PSCustomObject representation of the JSON that is obtainable from the Kibana pipeline editor.

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
